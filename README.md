# AWS Solutions Architect Study Labs

Terraform-based hands-on labs for AWS Solutions Architect certification preparation. Each folder represents a specific AWS service or concept with practical implementations.

## Lab Structure

### 00-utils/
Utility scripts and reusable Terraform modules for common AWS configurations.

### 01-IAM/
Identity and Access Management labs covering users, groups, roles, policies, and permissions.

### 02-EC2/
Elastic Compute Cloud labs including instance types, security groups, key pairs, and networking.

### 03-EBS/
Elastic Block Store labs covering volume types, encryption, snapshots, and performance optimization.

### 04-AMI/
Amazon Machine Image labs including creation, sharing, copying, and lifecycle management.

### 05-EFS/
Elastic File System labs covering NFS configurations, performance modes, and cross-region access.

### 06-ALB/
Application Load Balancer labs including target groups, listeners, health checks, and multi-AZ deployments.

### 07-NLB/
Network Load Balancer labs covering layer 4 load balancing, static IP addresses, and high-performance scenarios.

## Quick Start
1. Navigate to any lab folder
2. Copy `terraform.tfvars.example` to `terraform.tfvars` and configure your AWS settings
3. Run standard Terraform workflow:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
4. Clean up resources: `terraform destroy`

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed (>= 1.0)
- Basic understanding of AWS services and Terraform syntax

## Study Notes
- Each lab builds on previous concepts
- Start with 00-utils for foundational modules
- Follow the numerical order for optimal learning progression
- Test scenarios include both CLI and console operations

## Security
- Never commit AWS credentials or sensitive data
- Use IAM roles with least privilege principle
- All `.tfvars` files are gitignored for safety
- Review security groups and NACLs before applying
