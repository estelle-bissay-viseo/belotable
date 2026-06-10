<!-- tags: fonctionnalités -->
# MVP - Minimum Viable Product

## Vue d'ensemble

Le MVP définit les fonctionnalités essentielles et minimales requises pour que le projet Belotable réponde à son objectif principal.

## Objectif principal

Fournir un outil de gestion de concours de belote pour son organisation et ses scores.

Contraintes :
 - outil compatible à n'importe quel OS
 - fonctionne sans connexion internet
 - outil de préférence portable (càd ne nécessite pas d'installation)

## Fonctionnalités

### Fonctionnalités essentielles

- belote à la vache, sans coinche et sans annonces
- tournoi en 3 parties
- chaque partie fait 10 donnes
- seules les doublettes gagnantes jouent les parties suivantes
- saisie des joueurs par doublette
- génération des premières parties en répartissant les doublettes sur les tables dans l'ordre d'inscription des doublettes
- saisie des scores à chaque fin de partie
- le score de chaque donne doit être juste. Si un score saisi n'est pas juste, il faut le mettre en évidence.
- pour une belote à la vache, le score d'une donne est juste si la somme des points est égale à 162.
- génération de l'arbre du tournoi
- visualisation de l'arbre du tournoi avec les résultats : mise en évidence des gagnants de chaque partie
- sauvegarde automatique de toutes les informations du tournoi pour reprendre en cas d'erreur
- possibilité de créer un nouveau tournoi ou de charger un précédent tournoi
- possibilité d'exporter les données d'un tournoi dans un format exploitable pour l'outil lui-même pour charger à nouveau le tournoi

### Fonctionnalités bonus

- créer un pdf imprimable A4 noir et blanc (une seule page) pour saisir manuellement par les joueurs le score d'une partie sur une table
- créer un pdf imprimable A4 noir et blanc (une seule page) pour préciser les règles de jeu et comment compter les points
- créer un pdf imprimable A4 noir et blanc (plusieurs pages) qui récapitule toutes les parties de toutes les parties avec les résultats finaux, et l'arbre du tournoi avec mise en évidence des gagnants de chaque partie
- possibilité d'exporter les données d'un tournoi dans un format csv

## Solution technique retenue : Flutter

L'application est développée avec **Flutter** (Dart), ciblant les plateformes desktop : Windows, macOS et Linux.

Flutter dispose de son propre moteur de rendu (Impeller/Skia), indépendant de la WebView système. Le rendu est donc **identique sur tous les OS** sans dépendance externe.

### Stack technique cible

| Composant | Technologie |
|---|---|
| Framework UI | Flutter (Dart) |
| Gestion d'état | Riverpod |
| Persistance locale | SQLite via `drift` |
| Sauvegarde / export natif | Fichiers JSON via `path_provider` + `file_picker` |
| Génération PDF | Package `pdf` + `printing` |
| Export CSV | Package `csv` |
| Visualisation bracket | Widget personnalisé (`CustomPainter`) |
| Packaging desktop | `flutter build windows/linux/macos` |
