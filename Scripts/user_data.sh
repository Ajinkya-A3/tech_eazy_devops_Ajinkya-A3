#!/bin/bash
set -e

# Update system and install dependencies
sudo apt update -y
sudo apt install -y openjdk-21-jdk maven git awscli at

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
nohup sudo java -jar target/hellomvc-0.0.1-SNAPSHOT.jar \
  > /home/ubuntu/logs/app/app.out.log \
  2> /home/ubuntu/logs/app/app.err.log &

# Schedule log upload and shutdown
cat <<'EOF' | at now + 60 minutes
#!/bin/bash


# Copy EC2 system logs
sudo cp /var/log/cloud-init.log /home/ubuntu/logs/ec2/
sudo cp /var/log/cloud-init-output.log /home/ubuntu/logs/ec2/

# Upload logs to S3 (replace with actual bucket name or export before)
aws s3 cp /home/ubuntu/logs/ec2/ s3://$S3_BUCKET_NAME/logs/ec2/ --recursive
aws s3 cp /home/ubuntu/logs/app/ s3://$S3_BUCKET_NAME/logs/app/ --recursive

# Shutdown the instance
sudo shutdown -h now
EOF
