#!/bin/bash

set -e

REPO_URL="${REPO_URL:-https://github.com/TU_USUARIO/webfusion-wordpress.git}"
REPO_DIR="/repo"
OUTPUT_DIR="/output"

echo "=============================="
echo "  WebFusion — Git Sync"
echo "=============================="
echo "Repositorio: $REPO_URL"

if [ -d "$REPO_DIR/.git" ]; then
    echo "Repositorio ya existe. Actualizando (git pull)..."
    cd "$REPO_DIR"
    git pull origin main 2>/dev/null || git pull origin master
else
    echo "Clonando repositorio por primera vez..."
    git clone "$REPO_URL" "$REPO_DIR"
fi

echo "Copiando archivos PHP al directorio del tema..."
if [ -d "$REPO_DIR/php" ]; then
    cp -rv "$REPO_DIR/php/." "$OUTPUT_DIR/"
else
    echo "ADVERTENCIA: No se encontró la carpeta /php en el repositorio."
fi

echo ""
echo "✔ Sincronización completada. Archivos en $OUTPUT_DIR:"
ls -la "$OUTPUT_DIR"
