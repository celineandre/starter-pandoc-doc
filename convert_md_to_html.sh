#!/bin/bash

# Dossier contenant les fichiers à convertir
INPUT_DIR="./src"

# Dossier de sortie
OUTPUT_DIR="./dist/HTML"

# Template
STYLE_TEMPLATE="./template/pandoc.css"
FOOTER_TEMPLATE="./template/footer.html"

# Nom du fichier d'index
INDEX_NAME="index"

# Vider le dossier de sortie s'il existe
if [ -d "$OUTPUT_DIR" ]; then
  echo "🔹 Nettoyage du dossier $OUTPUT_DIR..."
  rm -rf "$OUTPUT_DIR"/*
else
  # Création du dossier de sortie s'il n'existe pas
  mkdir -p "$OUTPUT_DIR"
fi

# Vérifie le template
if [ ! -f "$STYLE_TEMPLATE" ]; then
  echo "❌ Template introuvable : $STYLE_TEMPLATE"
  exit 1
fi

if [ ! -f "$FOOTER_TEMPLATE" ]; then
  echo "❌ Template introuvable : $FOOTER_TEMPLATE"
  exit 1
fi

# Copier le dossier des images
cp -r "$INPUT_DIR/img" "$OUTPUT_DIR/"

# Copier le style
mkdir -p "$OUTPUT_DIR/template/"
cp -r "./template/pandoc.css" "$OUTPUT_DIR/template/"

INDEX_MD="$OUTPUT_DIR/$INDEX_NAME.md"
echo "# Index des fichiers HTML" > "$INDEX_MD"
echo "" >> "$INDEX_MD"

# Conversion des fichiers Markdown à la racine de INPUT_DIR
for file in "$INPUT_DIR"/*.md "$INPUT_DIR"/*.mdr; do
  [ -e "$file" ] || continue

  filename=$(basename "$file")
  name="${filename%.*}"
  output_html="$OUTPUT_DIR/$name.html"

  echo "Conversion : $file → $output_html"

  pandoc "$file" \
    --standalone \
    --css="$STYLE_TEMPLATE" \
    --include-after-body="$FOOTER_TEMPLATE" \
    --resource-path="$INPUT_DIR" \
    -o "$output_html"

  # Extraction du titre H1
  title=$(grep -m 1 "^# " "$file" | sed 's/^# //')
  [ -z "$title" ] && title="$name"

  # Ajout dans l'index (lien cliquable)
  echo "- [$title]($name.html)" >> "$INDEX_MD"
done

# Génération de index.html
pandoc "$INDEX_MD" \
  --standalone \
  --css="$STYLE_TEMPLATE" \
  --include-after-body="$FOOTER_TEMPLATE" \
  --resource-path="$INPUT_DIR" \
  -o "$OUTPUT_DIR/$INDEX_NAME.html"

# Suppression du fichier index.md temporaire
rm "$INDEX_MD"

echo "✔ Terminé !"
echo "📁 Fichiers HTML générés dans : $OUTPUT_DIR"
echo "📄 Index généré dans : $OUTPUT_DIR/$INDEX_NAME.html"
