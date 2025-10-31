# SQS Queue Migration to Terraform

This project contains Terraform configuration to manage your existing SQS queue without deleting it.

## Queue Details

- **Queue Name:** demo
- **Region:** us-east-1
- **Queue URL:** https://sqs.us-east-1.amazonaws.com/373456726732/demo

## Prerequisites

1. AWS CLI installed and configured
2. Terraform installed (>= 1.0)
3. AWS credentials with the following SQS permissions:
   - `sqs:GetQueueAttributes`
   - `sqs:GetQueueUrl`
   - `sqs:ListQueueTags`

## Setup Instructions

### Step 1: Install Terraform (Windows)

Install Terraform using Windows Package Manager:

```powershell
winget install --id HashiCorp.Terraform
```

Verify installation:
```powershell
terraform --version
```

### Step 2: Install AWS CLI (if not already installed)

```powershell
winget install --id Amazon.AWSCLI
```

Verify installation:
```powershell
aws --version
```

### Step 3: Configure AWS Credentials

This project is configured to use AWS profiles. Choose one of these methods:

**Option A: Use Existing AWS Profile (Recommended)**
If you already have AWS profiles configured, list them:
```powershell
aws configure list-profiles
```

Set the profile you want to use:
```powershell
$env:AWS_PROFILE="your-profile-name"
```

Or update the default profile in `variables.tf`:
```hcl
variable "aws_profile" {
  description = "AWS profile to use for authentication"
  type        = string
  default     = "your-profile-name"  # Change this to your preferred profile
}
```

**Option B: Configure AWS SSO Profile**
```powershell
aws configure sso
```

**Option C: Configure Standard AWS Profile**
```powershell
aws configure --profile your-profile-name
```

**Option D: Environment Variables (Windows)**
```powershell
$env:AWS_ACCESS_KEY_ID="your_access_key"
$env:AWS_SECRET_ACCESS_KEY="your_secret_key"
$env:AWS_DEFAULT_REGION="us-east-1"
```

### Step 4: Test AWS Credentials

Verify your AWS credentials are working:
```powershell
aws sts get-caller-identity
```

### Step 5: Initialize Terraform

```powershell
cd migrate-resources-to-tf
terraform init
```

### Step 6: Import Existing SQS Queue

Import your existing queue into Terraform state (this does NOT modify the queue):

```powershell
terraform import aws_sqs_queue.demo "https://sqs.us-east-1.amazonaws.com/373456726732/demo"
```

### Step 7: Verify Configuration

Run a plan to see if there are any differences:

```powershell
terraform plan
```

### Step 8: Visualize Resources (Optional)

Generate a visual graph of your Terraform resources:

```powershell
terraform graph | dot -Tsvg > terraform-graph.svg
```

Note: This requires Graphviz to be installed. Install it with:
```powershell
winget install --id Graphviz.Graphviz
```

### Step 9: Update Configuration to Match Existing Queue

If `terraform plan` shows changes, you need to update `main.tf` to match your queue's current configuration.

Get your queue's current attributes:
```powershell
aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/373456726732/demo --attribute-names All --region us-east-1
```

Update the commented sections in `main.tf` to match your actual queue settings:
- `delay_seconds`
- `max_message_size`
- `message_retention_seconds`
- `receive_wait_time_seconds`
- `visibility_timeout_seconds`
- FIFO settings (if applicable)
- Encryption settings (if applicable)
- Dead letter queue settings (if applicable)

### Step 10: Verify No Changes

After updating `main.tf`, run plan again:

```powershell
terraform plan
```

It should show "No changes. Your infrastructure matches the configuration."

## Project Structure

```
migrate-resources-to-tf/
├── provider.tf      # Terraform and AWS provider configuration
├── main.tf          # SQS queue resource definition
├── variables.tf     # Input variables
├── outputs.tf       # Output values
└── README.md        # This file
```

## Important Notes

- The import process does NOT modify your existing queue
- Always run `terraform plan` before `terraform apply`
- Make sure your Terraform configuration matches your existing queue settings to avoid unintended changes
- Keep the `.terraform.lock.hcl` file in version control

## Common SQS Attributes

Here are the default values for standard SQS queues:

- **delay_seconds:** 0
- **max_message_size:** 262144 (256 KB)
- **message_retention_seconds:** 345600 (4 days)
- **receive_wait_time_seconds:** 0
- **visibility_timeout_seconds:** 30

## Next Steps

After successfully importing and verifying your configuration:

1. Commit your Terraform files to version control
2. Set up a remote state backend (S3 + DynamoDB) for team collaboration
3. Consider adding additional SQS resources (dead letter queues, etc.)
4. Document any manual changes that should now go through Terraform

## Troubleshooting

### "No valid credential sources found" Error

If you see a credential error:
1. Verify your AWS profile is set: `$env:AWS_PROFILE="your-profile-name"`
2. Test credentials: `aws sts get-caller-identity`
3. Check available profiles: `aws configure list-profiles`
4. Ensure the profile matches the one in `variables.tf` (currently set to "sandbox")

### Access Denied Error

If you see an "AccessDenied" error during import, verify:
1. Your AWS credentials are configured correctly
2. The credentials belong to the correct AWS account (373456726732)
3. The IAM user/role has the necessary SQS permissions

### Plan Shows Unwanted Changes

If `terraform plan` shows changes you don't want:
1. Review the current queue configuration in AWS Console
2. Update `main.tf` to match the actual settings
3. Run `terraform plan` again to verify

### AWS Profile Configuration

The project uses AWS profiles for authentication. The current configuration in `variables.tf` defaults to the "sandbox" profile. You can:

1. **Use a different profile**: Set `$env:AWS_PROFILE="your-profile"`
2. **Change the default**: Modify the `aws_profile` variable default in `variables.tf`
3. **Override at runtime**: Use `terraform plan -var="aws_profile=your-profile"`
