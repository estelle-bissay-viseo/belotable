# ─────────────────────────────────────────────────────────
# Stage 1 : Build Flutter web
# ─────────────────────────────────────────────────────────
FROM debian:bookworm-slim AS builder

ARG FLUTTER_VERSION
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"
ENV PUB_CACHE=/root/.pub-cache

COPY .fvmrc /tmp/.fvmrc

RUN --mount=type=secret,id=ca_cert,required=false \
    if [ -s /run/secrets/ca_cert ] && grep -q "BEGIN CERTIFICATE" /run/secrets/ca_cert; then \
      mkdir -p /usr/local/share/ca-certificates; \
      cp /run/secrets/ca_cert /usr/local/share/ca-certificates/corp.crt; \
    fi

RUN apt-get update && apt-get install -y \
    ca-certificates curl git unzip xz-utils zip \
    && update-ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN flutter_version="${FLUTTER_VERSION}" \
    && if [ -z "$flutter_version" ]; then \
         flutter_version="$(sed -nE 's/.*"flutter"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' /tmp/.fvmrc | head -n1)"; \
       fi \
    && test -n "$flutter_version" \
    && curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${flutter_version}-stable.tar.xz" \
    -o flutter.tar.xz \
    && tar xf flutter.tar.xz -C /usr/local \
    && rm flutter.tar.xz

RUN git config --global --add safe.directory ${FLUTTER_HOME}

RUN flutter --disable-analytics
    
WORKDIR /app

# Copier uniquement les fichiers de dépendances en premier pour profiter du cache Docker
COPY belotable/pubspec.yaml belotable/pubspec.lock ./
RUN flutter pub get

COPY belotable/ .
RUN flutter build web --release

# ─────────────────────────────────────────────────────────
# Stage 2 : Image de production (nginx:alpine ~20 MB)
# ─────────────────────────────────────────────────────────
FROM nginx:alpine AS runtime

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY build/docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
