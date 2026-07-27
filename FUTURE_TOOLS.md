# Future Tool Ideas

Candidate tools to add to the interactive menu later. Prioritized by usefulness for AWS admin / CloudOps / architect workflows.

## Install Tools

| Tool | Description | Use Case |
|------|-------------|----------|
| **eksctl** | Official CLI for Amazon EKS | Create and manage EKS clusters without writing CloudFormation |
| **k9s** | Kubernetes TUI (terminal UI) | Visual cluster management — pods, logs, exec in one interface |
| **cfn-lint** | CloudFormation template linter | Validate templates before deploying, catches errors early |
| **awslogs** | Tail CloudWatch Logs from CLI | Stream log groups during incidents without the console |
| **yq** | YAML processor (like jq for YAML) | Parse and transform CloudFormation/K8s manifests |
| **aws-nuke** (ekristen fork) | Granular account resource deletion | Filter-based nuking with YAML config — more control than cloud-nuke |
| **granted** | Fast AWS role switching | Assume roles across accounts with fuzzy search |
| **infracost** | Cloud cost estimates from Terraform | Show cost impact of infrastructure changes before applying |
| **tfsec** | Terraform security scanner | Static analysis for security misconfigurations in .tf files |
| **checkov** | IaC security/compliance scanner | Covers Terraform, CloudFormation, Kubernetes, and more |
| **aws-vault** | Secure credential storage | Stores IAM creds in OS keystore, exposes temp session tokens |

## Launch Tools (interactive runners)

| Tool | Description | Notes |
|------|-------------|-------|
| **k9s** | Launch with EKS context | Requires kubectl + kubeconfig |
| **Steampipe dashboard** | Launch Steampipe in dashboard mode | Web-based dashboards rendered from SQL queries |
| **Steampipe queries** | Pre-built compliance/audit queries | Run CIS benchmarks, find public resources, etc. |

## AWS CLI Enhancements

| Feature | Description |
|---------|-------------|
| **Enable Auto-Prompt** | Turn on the built-in interactive CLI wizard (`cli_auto_prompt`) |
| **Configure default region** | Set/change the default AWS region |
| **View caller identity** | Quick `sts get-caller-identity` check |

## Considerations

- **CloudShell constraints**: 1GB persistent storage, no Docker, Amazon Linux 2 based
- **Local usage**: If running locally (macOS/Linux), Docker-based tools and heavier installs become viable
- **Architecture support**: All install functions should detect and handle both x86_64 and arm64
