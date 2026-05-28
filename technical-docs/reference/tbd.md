# Référence: TBD (Trunk-Based Development)

## Définition rapide

Le TBD (Trunk-Based Development) est une stratégie de développement où l'équipe intègre fréquemment sur une branche principale (le trunk), avec des branches de travail courtes et un feedback CI rapide.

Principes clés :

- Intégrations fréquentes.
- Branches courtes (éviter les divergences longues).
- Validation automatique (tests, analyse, build) avant et après fusion.

## Application dans ce projet

Dans ce dépôt, le flux documenté est `dev` -> `release` -> `main`.

Lecture TBD appliquée ici (forme adaptée) :

- `dev` joue le rôle de branche d'intégration continue (proche d'un trunk technique).
- `release` sert de branche de stabilisation technique avant publication.
- `main` reste la référence de production.

Ce n'est donc pas un TBD "pur" à branche unique, mais une adaptation orientée livraison, qui conserve l'objectif principal du TBD : intégrer tôt, valider souvent, et réduire les écarts entre développement et production.

## Intégration des branches via rebase

Les mise à jour des branches (`release` -> `main`, `main` -> `dev`) sont effectuées via **rebase** plutôt que merge. Cette approche :

- Conserve un historique Git linéaire et propre.
- Évite les merge commits inutiles.
- Facilite la traçabilité des changements.

Le rebase est effectué automatiquement par le pipeline `release.yml` lors de la synchronisation des branches après la création du tag de release.

## Points d'attention

- Plus les branches de travail restent courtes, plus le modèle reste proche de l'esprit TBD.
- Les contrôles automatiques (tests, build, docs strictes) sont essentiels pour préserver la vitesse d'intégration.
- Le rebase suppose que l'historique ne diverge pas fortement entre les branches ; le flux linéaire du pipeline en garantit la stabilité.


## Sources (dépôt)

- `technical-docs/reference/ci-cd.md`
- `technical-docs/explanation/strategie-release.md`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
