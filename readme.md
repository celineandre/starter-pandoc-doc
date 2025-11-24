# Starter Pandoc Doc

Projet pour aider à générer d'autres formats de fichier pour la documentation rédigé en Markdown.

## Prérequis

Installer [Pandoc](https://pandoc.org/installing.html)

## Script

Exécution du script pour générer pour chaque fichier du dossier "src" un fichier au format choisi dans le dossier "dist".

- "src/fichier.md" > "dist/DOCX/fichier.docx" :

  ```bash
  ./convert_md_to_docx.sh
  ```

- "src/fichier.md" > "dist/HTML/fichier.html" :

  ```bash
  ./convert_md_to_docx.sh
  ```
