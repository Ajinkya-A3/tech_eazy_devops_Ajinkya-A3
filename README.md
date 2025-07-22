# 🚀 Terraform EC2 Java App Deployment with Auto-Shutdown

This project provisions an EC2 instance using Terraform to deploy a Java-based application. The instance auto-shuts down after 60 minutes to optimize cost.

---

## 📁 Project Structure

```
.
├── LICENSE
├── Scripts
│   └── user_data.sh              # Bootstraps EC2: Installs Java, clones repo, builds, runs app, shuts down
├── Terraform
│   ├── backend.tf                # (Optional) Remote state backend config
│   ├── dev.tfvars                # Dev environment variables
│   ├── main.tf                   # Main resources (EC2, IAM, SG)
│   ├── outputs.tf                # Useful outputs
│   ├── prod.tfvars               # Prod environment variables
│   ├── provider.tf               # AWS provider
│   └── variables.tf              # Input variables
└── policies
    └── ec2_policy.json           # Custom IAM policy for EC2
```

---

## 📦 Features

- EC2 instance with IAM role and instance profile
- Open ports: `80` for HTTP and `22` for SSH
- Auto installs Java 21, Maven, Git
- Clones and runs Java app from GitHub
- Auto-shuts down after 60 minutes using Bash `at` command (no AWS CLI required)

---

## 🔧 How to Use

1. **Set up AWS credentials** (via environment or `~/.aws/credentials`).
2. **Initialize Terraform**:
   ```bash
   cd Terraform
   terraform init
   ```

3. **Apply for Dev environment**:
   ```bash
   terraform apply -var-file=dev.tfvars
   ```

4. **Apply for Prod environment**:
   ```bash
   terraform apply -var-file=prod.tfvars
   ```

---

## 📄 Sample `dev.tfvars`

```hcl
env           = "dev"
ami_id        = "ami-0c1234567890abcde"
instance_type = "t2.micro"
key_name      = "my-key"
vpc_id        = "vpc-xxxxxxxx"
subnet_id     = "subnet-xxxxxxxx"
script_path   = "../Scripts/user_data.sh"
policy_path   = "../policies/ec2_policy.json"
```

---

## 📜 License

MIT License