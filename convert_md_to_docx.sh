#!/bin/bash

# Dossier contenant les fichiers à convertir
INPUT_DIR="./src"

# Dossier de sortie
OUTPUT_DIR="./dist"

# Dossier du template
DOCX_TEMPLATE="./template/template.docx"

# Nom du fichier d'index
INDEX_NAME="_index"

# Vider le dossier de sortie s'il existe
if [ -d "$OUTPUT_DIR" ]; then
  echo "🔹 Nettoyage du dossier $OUTPUT_DIR..."
  rm -rf "$OUTPUT_DIR"/*
else
  # Création du dossier de sortie s'il n'existe pas
  mkdir -p "$OUTPUT_DIR"
fi

# Vérifie le template
if [ ! -f "$DOCX_TEMPLATE" ]; then
  echo "❌ Template introuvable : $DOCX_TEMPLATE"
  exit 1
fi

INDEX_MD="$OUTPUT_DIR/$INDEX_NAME.md"
echo "# Index des documents" > "$INDEX_MD"
echo "" >> "$INDEX_MD"

# Conversion des fichiers Markdown à la racine de INPUT_DIR
for file in "$INPUT_DIR"/*.md "$INPUT_DIR"/*.mdr; do
  [ -e "$file" ] || continue

  filename=$(basename "$file")
  name="${filename%.*}"
  output_docx="$OUTPUT_DIR/$name.docx"

  echo "Conversion : $file → $output_docx"

  pandoc "$file" \
    --standalone \
    --reference-doc="$DOCX_TEMPLATE" \
    --resource-path="$INPUT_DIR" \
    -o "$output_docx"

  # Extraction du titre H1
  title=$(grep -m 1 "^# " "$file" | sed 's/^# //')
  [ -z "$title" ] && title="$name"

  # Ajout dans l'index (lien cliquable)
  echo "- [$title]($name.docx)" >> "$INDEX_MD"
done

# Génération de index.docx
pandoc "$INDEX_MD" \
  --standalone \
  --reference-doc="$DOCX_TEMPLATE" \
  --resource-path="$INPUT_DIR" \
  -o "$OUTPUT_DIR/$INDEX_NAME.docx"

# Suppression du fichier index.md temporaire
rm "$INDEX_MD"

echo "✔ Terminé !"
echo "📁 Fichiers DOCX générés dans : $OUTPUT_DIR"
echo "📄 Index généré dans : $OUTPUT_DIR/$INDEX_NAME.docx"
