<!-- tags: architecture, database, développement -->
# Référence: Modèle de données en base de données

## Principe

L'objet principal est `Concours`. Tous les autres objets liés doivent être supprimés en cascade avec le concours.

## Schéma

```mermaid
erDiagram
  Concours {
    string id PK
    datetime date
    string lieu
    string organisateur
    int nombreDonnesParManche
    int nombreMaxPointsParDonne
    string reglesJeu
    string statutConcours
  }
  Doublettes {
    string concoursId FK
    int doubletteId PK
    string joueurA
    string joueurB
    string nomEquipe
    int totalPoints
  }
  Manches {
    int id PK
    string concoursId FK
    int numero
    string statut
  }
  TablesDeJeu {
    int id PK
    int mancheId FK
    int numero
    string statut
  }
  TableDoublettes {
    int id PK
    int tableId FK
    string concoursId FK
    int doubletteId FK
    int points
    string statut
  }
  DealPoints {
    int tableDoubletteId FK
    int dealNumber PK
    int points
  }
  Concours ||--o{ Doublettes : "cascade"
  Concours ||--o{ Manches : "cascade"
  Manches ||--o{ TablesDeJeu : "cascade"
  TablesDeJeu ||--o{ TableDoublettes : "cascade"
  Doublettes ||--o{ TableDoublettes : "cascade SQL composite"
  TableDoublettes ||--o{ DealPoints : "cascade"
```

## Validation

Il y a des tests pour valider les suppressions en cascade dans `belotable\test\data\repositories\cascade_delete_test.dart`.