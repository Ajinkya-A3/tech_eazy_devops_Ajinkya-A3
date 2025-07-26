#!/bin/bash
set -e

# Update system and install dependencies
sudo apt update -y
# Update system and install dependencies
sudo apt update -y
sudo apt install -y unzip curl git openjdk-21-jdk maven at

# Install AWS CLI v2 (official method)
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Clone the application repository
cd /home/ubuntu
git clone https://github.com/Trainings-TechEazy/test-repo-for-devops.git
cd test-repo-for-devops

# Build the application
mvn clean package

# Create local log directories
mkdir -p /home/ubuntu/logs/app
mkdir -p /home/ubuntu/logs/ec2

# Run the application and redirect logs
sudo nohup java -jar target/hellomvc-0.0.1-SNAPSHOT.jar \
  > /home/ubuntu/app.out.log \
  2> /home/ubuntu/app.err.log &


# Schedule log upload and shutdown
cat <<'EOF' | at now + 3 minutes
#!/bin/bash


# Copy EC2 system logs
sudo cp /var/log/cloud-init.log /home/ubuntu/logs/ec2/
sudo cp /var/log/cloud-init-output.log /home/ubuntu/logs/ec2/

# Upload logs to S3 (replace with actual bucket name or export before)
sudo aws s3 cp /home/ubuntu/logs/ec2/ s3://$S3_BUCKET_NAME/logs/ec2/ --recursive
sudo aws s3 cp /home/ubuntu/logs/app/ s3://$S3_BUCKET_NAME/logs/app/ --recursive

# Shutdown the instance
sudo shutdown -h now
EOF
