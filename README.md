# Belotable

![Belotable Logo](resources/logo_full.png)

Besoin : organisation et scoring d'un tournoi de belote

Contraintes :
 - outil compatible à n'importe quel OS
 - fonctionne sans connexion internet
 - outil de préférence portable (càd ne nécessite pas d'installation)

# Benchmark mai 2026

- Belote : https://tournois-apps.com/belote
- Belote Manager : https://www.belote.lozdev-informatique.fr/

## MVP

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

## Fonctionnalités bonus au MVP

 - créer un pdf imprimable A4 noir et blanc (une seule page) pour saisir manuellement par les joueurs le score d'une partie sur une table
 - créer un pdf imprimable A4 noir et blanc (une seule page) pour préciser les règles de jeu et comment compter les points
 - créer un pdf imprimable A4 noir et blanc (plusieurs pages) qui récapitule toutes les parties de toutes les parties avec les résultats finaux, et l'arbre du tournoi avec mise en évidence des gagnants de chaque partie
 - possibilité d'exporter les données d'un tournoi dans un format csv

## Solution technique retenue : Flutter Desktop

L'application est développée avec **Flutter** (Dart), ciblant les plateformes desktop : Windows, macOS et Linux.

Flutter dispose de son propre moteur de rendu (Impeller/Skia), indépendant de la WebView système. Le rendu est donc **identique sur tous les OS** sans dépendance externe.

### Stack technique

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

### Structure du projet (couches)

```
lib/
├── data/           # Accès données : SQLite, fichiers JSON, CSV
├── domain/         # Logique métier : règles belote, calcul scores, génération tournoi
├── presentation/   # Widgets et écrans Flutter
│   ├── desktop/    # Layouts optimisés PC (multi-colonnes, clavier/souris)
│   └── shared/     # Widgets réutilisables toutes plateformes
└── main.dart
```

La logique métier (`domain/`) et l'accès aux données (`data/`) sont **découplés de l'UI**, ce qui facilite les évolutions futures.

### Portage smartphone (perspective future)

Flutter ciblant nativement Android et iOS, un portage mobile est envisageable **sans réécriture** des couches `domain/` et `data/` (réutilisation estimée à ~90 %).

Les adaptations nécessaires se limitent à la couche `presentation/` :

- Ajouter des layouts adaptés aux petits écrans dans `presentation/mobile/` (navigation en pile, vues simplifiées)
- Adapter la visualisation du bracket du tournoi pour le tactile (scroll horizontal, zoom)
- Gérer les différences d'accès fichiers (sandbox mobile via `path_provider`)

Un cas d'usage mobile pertinent serait une **application compagne** permettant la saisie des scores à la table par les joueurs eux-mêmes sur smartphone, synchronisée avec l'application desktop de l'organisateur.
