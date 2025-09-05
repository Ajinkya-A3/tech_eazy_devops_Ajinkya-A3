#!/bin/bash
set -e

# ------------------------------
# VARIABLES
# ------------------------------
LOG_DIR=/home/ubuntu/logs/app
CW_CONFIG=/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# ------------------------------
# 1. Install CloudWatch Agent
# ------------------------------
cd /tmp
curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

# ------------------------------
# 2. Create persistent CloudWatch Agent JSON config
# ------------------------------
sudo tee $CW_CONFIG <<'EOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ubuntu/logs/app/app.out.log",
            "log_group_name": "app-log-group",
            "log_stream_name": "{instance_id}-out",
            "timezone": "UTC"
          },
          {
            "file_path": "/home/ubuntu/logs/app/app.err.log",
            "log_group_name": "app-log-group",
            "log_stream_name": "{instance_id}-err",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
EOF

# ------------------------------
# 3. Start CloudWatch Agent
# ------------------------------
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:$CW_CONFIG \
  -s

# ------------------------------
# 4. Check status and restart if needed
# ------------------------------
STATUS=$(/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status | grep "running")
if [ -z "$STATUS" ]; then
    echo "CloudWatch Agent not running. Restarting..."
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
      -a fetch-config -m ec2 -c file:$CW_CONFIG -s
else
    echo "CloudWatch Agent is running."
fi
