<!-- tags: architecture -->
# Explanation: Choix techniques

## Pourquoi Flutter

Le projet vise une application multiplateforme, portable et hors ligne. Flutter est retenu pour :

- un moteur de rendu unifié entre OS desktop.
- une base de code unique Dart.
- une possibilité de ciblage web et mobile depuis la même base.

https://flutter.dev/

## Pourquoi une architecture en couches

La structure `data/`, `domain/`, `presentation/` fixe des frontières claires :

- `presentation` : UI et interaction utilisateur.
- `domain` : logique métier pure.
- `data` : persistance et intégration technique.

Cette séparation facilite :

- le test unitaire de la logique métier.
- l'évolution de l'UI sans couplage fort.
- un futur portage mobile sans réécriture complète.

## Pourquoi un socle minimal au stade actuel

Le code dans `lib/` est volontairement initial. Il etablit :

- un point d'entrée fonctionnel.
- un écran d'accueil simple.
- une arborescence prête pour les futures fonctionnalités métier.

Cela permet de valider la chaîne de build (desktop, web, CI/CD, packaging) avant d'étendre la logique applicative.

## Pourquoi centraliser la version Flutter

La version Flutter est centralisée dans `.fvmrc` pour éviter les dérives entre :

- développement local.
- workflows CI.
- build Docker.

Ce choix réduit les écarts d'environnement et les régressions difficiles à reproduire.

## Sources (dépôt)

- `.fvmrc`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
