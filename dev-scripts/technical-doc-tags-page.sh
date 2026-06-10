#!/usr/bin/env bash

set -euo pipefail

# Ce script génère un fichier TAGS.md listant les documents techniques par tag.

DOCS_DIR="technical-docs"
OUTPUT_FILE="$DOCS_DIR/TAGS.md"

declare -A TAG_MAP

while IFS= read -r -d '' file; do
  [[ "$(basename "$file")" == "TAGS.md" ]] && continue

  first_line=$(head -n 1 "$file")

  if [[ "$first_line" =~ \<\!--[[:space:]]*tags[[:space:]]*:[[:space:]]*(.*)[[:space:]]*--\> ]]; then
    tags_raw="${BASH_REMATCH[1]}"
    IFS=',' read -ra tags <<< "$tags_raw"

    rel_path="${file#$DOCS_DIR/}"

    # Nom lisible (fichier sans extension)
    filename=$(basename "$rel_path" .md)

    for tag in "${tags[@]}"; do
      clean_tag=$(echo "$tag" | xargs | tr '[:upper:]' '[:lower:]')

      # Stocker "nom|chemin"
      TAG_MAP["$clean_tag"]+="$filename|$rel_path"$'\n'
    done
  fi

done < <(find "$DOCS_DIR" -type f -name "*.md" -print0)

# Génération du fichier
{
  echo "# Documentation par tag"
  echo

  for tag in "${!TAG_MAP[@]}"; do
    echo "$tag"
  done | sort | while read -r tag; do
    echo "## $tag"

    echo -n "${TAG_MAP[$tag]}" | sort | while IFS='|' read -r name path; do
      [[ -n "$path" ]] && echo "- [$name]($path)"
    done

    echo
  done

} > "$OUTPUT_FILE"

echo "Fichier généré : $OUTPUT_FILE"