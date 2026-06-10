<!-- tags: git, méthodes, cicd -->
# Explanation: Stratégie de release

## Intentions du flux de branches

Le flux `dev` -> `release` -> `main` sépare clairement :

- intégration continue rapide (`dev`).
- branche purement technique pour déclencher le process de release (`release`).
- référence de production (`main`).

## Ce que fait le pipeline release

Le workflow `release.yml` automatise un cycle complet :

1. normaliser la version stable depuis `belotable/pubspec.yaml`.
2. construire les artefacts (Docker web, installeur Windows, PDF docs).
3. créer le tag `vX.Y.Z`.
4. créer une release GitHub en brouillon avec artefacts.
5. synchroniser `release` vers `main`, puis `main` vers `dev` via **rebase**.
6. incrémenter `dev` vers la prochaine version `-alpha`.

## Approche rebase plutôt que merge

Les mise à jour des branches utilisent **rebase** au lieu de merge commits. Cela :

- Crée un historique linéaire et exempt de merge commits.
- Simplifie le suivi des changements et la compréhension de l'arborescence.
- Maintient la cohérence avec la philosophie TBD (trunk-based development).

Le rebase est exécuté dans l'étape "Rebase release into main then prepare dev" du workflow `release.yml` :
- Rebase de `release` dans `main`.
- Rebase de `main` dans `dev`.

## Avantages

- Reproductibilité : la release est issue d'un SHA explicite (`release_sha`).
- Traçabilité : tag Git et release GitHub lient code et artefacts.
- Continuité : la branche `dev` est automatiquement remise sur la prochaine itération.
- Historique propre : pas de merge commits polluant l'arborescence.

## Limites et vigilance

- Le pipeline ne résout pas automatiquement les conflits de rebase.
- Un tag déjà présent sur le remote bloque la release.
- La fiabilité dépend des tests et du build docs strict avant publication.
- Le flux linéaire repose sur l'absence de divergence significative entre les branches ; le processus TBD en garantit la stabilité.


## Sources (dépôt)

- `.github/workflows/README.md`
- `.github/workflows/release.yml`
- `.github/workflows/ci.yml`
