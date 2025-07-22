#!/bin/bash
set -e

# Update system and install dependencies
sudo apt update -y
sudo apt install -y openjdk-21-jdk maven git

# Clone the app repository
cd /home/ubuntu
git clone https://github.com/techeazy-consulting/techeazy-devops.git
cd techeazy-devops

# Build the Java app
mvn clean package

# Run the app in background
nohup java -jar target/techeazy-devops-0.0.1-SNAPSHOT.jar > output.log 2>&1 &
