# AWS CloudShell Tools

Display and update current version of all software and specifications within AWS CloudShell Environments.

## Purpose

The script here is used to update and/or display the version of tools deployed to AWS CloudShell Environments.

Details for the software and specifications for these tools are documented by AWS [https://docs.aws.amazon.com/cloudshell/latest/userguide/vm-specs.html](https://docs.aws.amazon.com/cloudshell/latest/userguide/vm-specs.html).

## Implementation

This solution can be run two ways.

1. [View current](#View-Current) version of all installed software
2. [Update all](#Update-All) versions of software

To successfully run this solution:
1. Change to the region within the AWS Console you wish to run your commands from
2. Start CloudShell Session (the user session may take a few moments to establish)
3. Once established, copy the desired operation below
4. Paste the command into your `CloudShell` terminal from within the AWS Console
5. Run the script

### View Current

**curl**
```bash
curl -fsS https://raw.githubusercontent.com/rwickit/aws-cloudshell-tools/main/scripts/cloudshell.sh | bash
```

**wget**
```bash
wget https://raw.githubusercontent.com/rwickit/aws-cloudshell-tools/main/scripts/cloudshell.sh -O- | bash
```

### Update All

**curl**
```bash
curl -fsS https://raw.githubusercontent.com/rwickit/aws-cloudshell-tools/main/scripts/cloudshell.sh | bash
```

**wget**
```bash
wget https://raw.githubusercontent.com/rwickit/aws-cloudshell-tools/main/scripts/cloudshell.sh -O- | bash
```
