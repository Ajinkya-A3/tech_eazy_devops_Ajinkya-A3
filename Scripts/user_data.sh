#!/bin/bash
set -e

# Update the system
sudo apt update -y
sudo apt install -y openjdk-21-jdk maven git

# Clone the application repository
cd /home/ubuntu
git clone https://github.com/techeazy-consulting/techeazy-devops.git
cd techeazy-devops

# Build the application
mvn clean package

# Run the application with root privileges so it can bind to port 80
nohup sudo java -jar target/techeazy-devops-0.0.1-SNAPSHOT.jar > /home/ubuntu/app.out.log 2> /home/ubuntu/app.err.log &

# Schedule automatic shutdown after 60 minutes
echo "sudo shutdown -h now" | at now + 60 minutes