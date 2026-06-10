# Documentation technique Belotable

Ce répertoire applique le framework [Diátaxis](https://diataxis.fr/) pour séparer les besoins de documentation en quatre types :

- Tutorials : apprendre en faisant.
- How-to guides : résoudre une tâche précise.
- Référence : consulter des faits techniques exacts.
- Explanation : comprendre les choix et compromis.

## Plan de lecture recommandé

- Nouveau sur le projet : commencer par [tutorials/00-mise-en-place-poste-dev.md](tutorials/00-mise-en-place-poste-dev.md).
- Besoin d'une action concrète : aller dans [how-to](how-to/).
- Besoin d'une information précise (commande, version, fichier, workflow, ...) : aller dans [reference](reference/).
- Besoin du pourquoi architectural : aller dans [explanation](explanation/).

## Documentation par catégorie

Voir [la page listant chaque page par catégorie](TAGS.md).

## Rédaction de la documentation

- chaque page doit avoir une première ligne commentée indiquant ses tags en suivant ce format précis : `<!-- tags: tag-1, tag-2, ... -->` (tout en minuscule, et chaque tag en kebab-case). Ces tags permettent de générer la page TAGS.md via le script `dev-scripts/technical-doc-tags-page.sh`.
- Le skill `doc-diataxis` est disponible pour les agents IA pour la rédaction de la documentation technique. Si vous l'utilisez, assurez-vous de relire le contenu généré pour corriger les erreurs éventuelles et compléter les informations manquantes.