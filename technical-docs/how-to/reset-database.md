<!-- tags:  flutter, database -->
# How-to: Remettre la base de données à zéro

## Contexte

Dans le cas des montées de version de l'application qui modifient le schéma de la base de données, les migrations de ce schéma ne sont PAS prévues tant que l'application est en version bêta (version 0.x.x).

Il est donc nécessaire de remettre la base de données à zéro pour éviter les conflits de schéma et les erreurs d'exécution.

## Étapes pour l'application Windows

Sous Windows, la base de données est stockée sur votre disque local.

1. Fermer l'application si elle est en cours d'exécution.
2. Supprimer le fichier de base de données sqlite locale (situé dans C:\Users\VotreUtilisateur\AppData\Roaming\belotable\belotable).
3. Redémarrer l'application, qui recréera automatiquement la base de données avec le schéma actuel.

## Étapes pour l'application web

Avec l'application web, la base de données est stockée parmi les données du navigateur (cookies, stockage local, IndexedDB, etc.).

1. Démarrer le serveur web de l'application.
2. Ouvrir l'application via votre navigateur.
3. Supprimer les cookies et données liés à l'adresse de l'application via votre navigateur.
4. Rafraichir la page de l'application dans votre navigateur.
