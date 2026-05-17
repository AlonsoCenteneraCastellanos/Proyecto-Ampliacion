#!/bin/bash

set -e

echo "=============================================="
echo "  WebFusion Digital — Inicio de aprovisionamiento"
echo "=============================================="

echo "[1/5] Actualizando paquetes del sistema..."
apt-get update -qq

echo "[2/5] Instalando dependencias..."
apt-get install -y -qq     ca-certificates     curl     gnupg     lsb-release     git

echo "[3/5] Instalando Docker..."

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg     | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -qq
apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker vagrant

echo "Docker instalado: $(docker --version)"

echo "[4/5] Desplegando contenedores con Docker Compose..."

cd /vagrant

docker compose down --remove-orphans 2>/dev/null || true

docker compose up -d --build

echo "Contenedores en ejecución:"
docker compose ps

echo "[5/5] Esperando a que WordPress esté disponible..."
sleep 10

echo ""
echo "=============================================="
echo "  ¡Despliegue completado!"
echo "  Accede a WordPress en: http://localhost:8080"
echo "=============================================="
