# AWS CloudShell Tools

An interactive menu for managing AWS CloudShell environments — update tools, view versions, and run destructive operations safely behind confirmation prompts.

_**TLDR;** Just run this:_

```bash
curl -LfsS https://link.rwick.it/aws-cloudshell-menu | bash
```

## Features

- **AWS CLI Tools** — View installed tool versions and update AWS CLI v2
- **DANGER ZONE** — Install and launch [Cloud-Nuke](https://github.com/gruntwork-io/cloud-nuke) with safety confirmations

## Usage

1. Open a CloudShell session in the AWS Console
2. Run the interactive menu:

```bash
curl -LfsS https://link.rwick.it/aws-cloudshell-menu | bash
```

Or clone and run directly:

```bash
git clone https://github.com/rwickit/aws-cloudshell-tools.git
cd aws-cloudshell-tools
./menu.sh
```

## Menu Structure

```text
Main Menu
├── 1) AWS CLI Tools
│   ├── 1) View Current Versions
│   └── 2) Update AWS CLI v2
├── 2) 🔧 Install Tools
│   ├── 1) Install Brew
│   ├── 2) Install Terraform
│   ├── 3) Install Steampipe
│   └── 4) Install Session Manager Plugin
└── 3) ⚠️  DANGER ZONE
    ├── 1) Install Cloud-Nuke
    └── 2) Launch Cloud-Nuke (only available if installed)
```

## Individual Scripts

The original standalone scripts are still available:

### View Current Versions

```bash
curl -LfsS https://link.rwick.it/aws-cloudshell-versions | bash
```

### Update AWS CLI v2

```bash
curl -LfsS https://link.rwick.it/aws-cloudshell-update | bash
```

## References

- [AWS CloudShell VM Specs](https://docs.aws.amazon.com/cloudshell/latest/userguide/vm-specs.html)
- [Cloud-Nuke by Gruntwork](https://github.com/gruntwork-io/cloud-nuke)
