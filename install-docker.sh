#!/usr/bin/env bash
set -e

echo "==> Updating system and installing prerequisites..."
sudo apt update
sudo apt install -y ca-certificates curl

echo "==> Creating keyrings directory..."
sudo install -m 0755 -d /etc/apt/keyrings

echo "==> Downloading Docker GPG key..."
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "==> Adding Docker repository..."
CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: ${CODENAME}
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo "==> Updating apt sources..."
sudo apt update

echo "==> Installing Docker Engine..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "==> Adding current user to docker group (no sudo required)..."
sudo usermod -aG docker $USER

echo
echo "====================================================="
echo " Docker installation completed successfully!"
echo " Please log out and log back in to use docker without sudo."
echo " Test with: docker run hello-world"
echo "====================================================="
