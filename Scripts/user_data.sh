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
  > /home/ubuntu/logs/app/app.out.log \
  2> /home/ubuntu/logs/app/app.err.log &


# Schedule log upload and shutdown
cat <<'EOF' | at now + 3 minutes
#!/bin/bash

# Set PATH so aws CLI and other tools are available
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin



# Ensure AWS credentials are active (via instance profile)
aws sts get-caller-identity > /dev/null 2>&1

# Make sure logs are readable
sudo chmod -R a+r /home/ubuntu/logs

# Copy EC2 system logs
sudo cp /var/log/cloud-init.log /home/ubuntu/logs/ec2/
sudo cp /var/log/cloud-init-output.log /home/ubuntu/logs/ec2/

# Upload logs to S3
aws s3 cp /home/ubuntu/logs/ec2/ s3://${s3_bucket_name}/logs/ec2/ --recursive
aws s3 cp /home/ubuntu/logs/app/ s3://${s3_bucket_name}/logs/app/ --recursive

# Shutdown the instance
sudo shutdown -h now
EOF

