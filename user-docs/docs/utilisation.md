# Utilisation

## Page d'accueil

![Page d'accueil](./assets/images/page-home.png)

La page d'accueil est votre point d'entrée après le lancement de l'application.

## Création d'un concours

Depuis la page d'accueil, cliquez sur **Créer un nouveau concours**.

L'écran *Créer un concours* vous permet de renseigner les informations minimales du concours.

![Créer un nouveau concours page](./assets/images/page-creer-concours.png)

Les informations obligatoires sont :

- La **Date** du concours
- Le **Lieu** du concours (de préférence une adresse postale complète)
- L'**Organisateur** du concours (le nom de la personne ou de l'entité responsable)

La date du concours est initialisée à la date du jour, mais vous pouvez la modifier.

![Créer un nouveau concours modifier date](./assets/images/page-creer-concours-modifier-date.png)

![Créer un nouveau concours exemple](./assets/images/page-creer-concours-exemple.png)

Valider la création du concours en sélectionnant **Valider**. Vous serez redirigé vers la page d'accueil avec le nouveau concours enregistré.

Annuler la création du concours en sélectionnant **Annuler**. Vous serez redirigé vers la page d'accueil sans enregistrer de nouveau concours.

## Liste des concours

Depuis la page d'accueil, cliquez sur **Liste des concours**.

La page *Liste des concours* affiche tous les concours enregistrés, triés du plus récent au plus ancien.

Chaque ligne affiche :

- La **Date** du concours
- Le **Lieu** du concours
- L'**Organisateur** du concours
- Le nombre de **Doublettes** inscrites au concours

![Liste des concours](./assets/images/page-liste-concours.png)

Si aucun concours n'est disponible, le message **Aucun concours disponible** est affiché.

La page de liste propose un bouton **+** pour créer un nouveau concours. Ce bouton ouvre directement l'écran *Créer un concours*.

### Modification d'un concours

Depuis la page de liste des concours, cliquez sur le bouton **Modifier** associé au concours que vous souhaitez modifier.

Vous serez redirigé vers l'écran *Modifier un concours*, qui affiche les informations du concours et vous permet de les modifier.

![Page de modification d'un concours](./assets/images/page-modifier-concours.png)

### Suppression d'un concours

Depuis la page de liste des concours, cliquez sur le bouton **Supprimer** associé au concours que vous souhaitez supprimer.

Une pop-up de confirmation de suppression s'affichera pour éviter les suppressions accidentelles.

### Gestion d'un concours

Après la création d'un concours, vous pouvez gérer les informations de ce concours depuis la page de liste des concours en cliquant sur le bouton **Gérer** associé au concours.

Vous serez redirigé vers la page de gestion du concours, qui affiche les informations du concours et propose des actions de gestion.

## Gestion d'un concours

La page de gestion d'un concours affiche les informations du concours et propose des actions de gestion.

![Page de gestion d'un concours](./assets/images/page-gestion-concours.png)

Vous pouvez gérer ici les doublettes inscrites au concours, le déroulement du concours et les résultats.

### Gestion des doublettes

Depuis la page de gestion d'un concours, cliquez sur **Doublettes**.

La page *Liste des doublettes* affiche les équipes inscrites au concours.

![Liste des doublettes](./assets/images/page-liste-doublettes.png)

Cette liste vous permet de visualiser les doublettes déjà inscrites, d'en ajouter de nouvelles, de modifier les inscriptions existantes, ou de supprimer des doublettes.

A la création d'une doublette, un nom d'équipe est automatiquement proposé par l'application, mais vous pouvez le modifier. Le nom d'équipe doit rester unique dans le concours.

### Gestion des manches

Depuis la page de gestion d'un concours, vous pouvez gérer les manches *(uniquement la première manche pour le moment)*.

Lorsque vous avez enregistrer toutes les doublettes du concours, cliquez sur **Préparer la première manche** pour démarrer le concours.

Vous pouvez voir la répartition des doublettes sur les tables de la première manche, et inscrire les résultats des parties jouées en cliquant sur le bouton **Manche 1**.

![Page de gestion d'une manche](./assets/images/page-manche-tables.png)

#### Première manche (manche 1)

La liste des tables de la **première manche** est générée automatiquement, en répartissant les doublettes sur les tables **par ordre d'inscription**.

Dès que la manche est créée, les **modifications des doublettes ont des impacts sur la répartition des tables** de la manche 1 :

- si une doublette est supprimée, cela libèrera une place sur la table où elle était prévue, mais ne réorganisera pas les autres tables.
- si une doublette est ajoutée après la préparation de la manche, elle sera placée sur une table libre si possible, sinon elle sera placée sur une nouvelle table en attente d'une autre doublette pour compléter la table.
- si une doublette est supprimée alors qu'elle a déjà joué une partie, la doublette ne sera pas supprimée mais sera marquée comme "Abandon" sur sa partie, et son adversaire sera marquée comme "Gagné".
- si deux tables attendent une doublette pour compléter la table, les 2 tables seront fusionnées.