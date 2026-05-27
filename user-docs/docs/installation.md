# Installation

Lien vers les releases du projet : https://github.com/estelle-bissay-viseo/belotable/releases

## Windows

1. Téléchargez l'installeur depuis les releases du projet.
2. Lancez l'installeur puis suivez les étapes.
3. Ouvrez Belotable depuis le menu Démarrer ou depuis le raccourci sur votre Bureau.

## Web

Une version web est disponible via une image docker.

Pour chaque release du projet, une image docker est stockée sur le GitHub Container Registry. Vous pouvez parcourir les releases du projet, choisir la version que vous souhaitez démarrer sur votre poste, copier le path de l'image correspondante et démarrer ainsi en ligne de commande :

```bash
docker run --rm -p 80:80 ghcr.io/estelle-bissay-viseo/belotable-web:<tag>
```

L'application est alors disponible à l'adresse http://localhost depuis votre navigateur web (de préférence Chrome ou Firefox).

## Linux, macOS, Android, iOS

Disponibles dans une prochaine version.
