#!/bin/bash

set -e

echo "===== Updating System ====="
sudo apt update -y
sudo apt upgrade -y

echo "===== Installing Required Packages ====="
sudo apt install -y wget curl gnupg ca-certificates fontconfig openjdk-21-jre

echo "===== Verifying Java ====="
java -version

echo "===== Adding Jenkins Repository ====="
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
sudo gpg --dearmor -o /etc/apt/keyrings/jenkins-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "===== Installing Jenkins ====="
sudo apt update
sudo apt install -y jenkins

echo "===== Starting Jenkins ====="
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl restart jenkins

echo "===== Jenkins Status ====="
sudo systemctl status jenkins --no-pager

echo ""
echo "========================================="
echo "Jenkins URL:"
echo "http://$(hostname -I | awk '{print $1}'):8080"
echo ""
echo "Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "========================================="
