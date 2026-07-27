#!/bin/bash
# AWS CloudShell Tools - Interactive Menu
# https://github.com/rwickit/aws-cloudshell-tools

set -euo pipefail

# ─── Colors & Formatting ───────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ─── Helper Functions ──────────────────────────────────────────────────────────
print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}   ${BOLD}AWS CloudShell Tools${NC}                           ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_separator() {
    echo -e "${CYAN}──────────────────────────────────────────────────${NC}"
}

pause() {
    echo ""
    echo -e "${YELLOW}Press any key to continue...${NC}"
    read -n 1 -s -r
}

# ─── AWS CLI Functions ─────────────────────────────────────────────────────────
view_versions() {
    print_header
    echo -e "${GREEN}📋 Current Tool Versions${NC}"
    print_separator
    echo ""

    echo -e "${BOLD}Shell Versions:${NC}"
    echo ""
    bash --version | head -1
    echo ""
    zsh --version 2>/dev/null || echo "zsh: not installed"
    echo ""
    pwsh --version 2>/dev/null || echo "pwsh: not installed"
    echo ""

    echo -e "${BOLD}AWS CLI Versions:${NC}"
    echo ""
    aws --version 2>/dev/null || echo "aws cli: not installed"
    echo ""
    eb --version 2>/dev/null || echo "eb cli: not installed"
    echo ""
    ecs-cli --version 2>/dev/null || echo "ecs-cli: not installed"
    echo ""
    sam --version 2>/dev/null || echo "sam cli: not installed"

    pause
}

update_aws_cli() {
    print_header
    echo -e "${GREEN}⬆️  Updating AWS CLI v2...${NC}"
    print_separator
    echo ""

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q -o awscliv2.zip
    sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

    echo ""
    echo -e "${GREEN}✅ AWS CLI v2 updated!${NC}"

    # Cleanup
    rm -rf awscliv2.zip aws/

    pause
}

# ─── Cloud-Nuke Functions ──────────────────────────────────────────────────────
check_cloud_nuke_installed() {
    command -v cloud-nuke &>/dev/null
}

install_cloud_nuke() {
    print_header
    echo -e "${RED}☁️  Installing Cloud-Nuke...${NC}"
    print_separator
    echo ""

    if check_cloud_nuke_installed; then
        echo -e "${YELLOW}⚠️  Cloud-Nuke is already installed!${NC}"
        echo ""
        cloud-nuke --version
        pause
        return
    fi

    echo "Fetching latest Cloud-Nuke release..."
    echo ""

    local latest_url
    latest_url=$(curl -s https://api.github.com/repos/gruntwork-io/cloud-nuke/releases/latest \
        | grep "browser_download_url.*linux.*amd64" \
        | head -1 \
        | cut -d '"' -f 4)

    if [[ -z "$latest_url" ]]; then
        echo -e "${RED}❌ Failed to fetch Cloud-Nuke release URL.${NC}"
        pause
        return
    fi

    echo "Downloading from: $latest_url"
    curl -Lo /tmp/cloud-nuke "$latest_url"
    chmod +x /tmp/cloud-nuke
    sudo mv /tmp/cloud-nuke /usr/local/bin/cloud-nuke

    echo ""
    echo -e "${GREEN}✅ Cloud-Nuke installed successfully!${NC}"
    cloud-nuke --version

    pause
}

launch_cloud_nuke() {
    print_header
    echo -e "${RED}${BOLD}🚨 LAUNCHING CLOUD-NUKE 🚨${NC}"
    print_separator
    echo ""
    echo -e "${RED}WARNING: Cloud-Nuke will PERMANENTLY DELETE resources in your AWS account.${NC}"
    echo -e "${RED}This action is IRREVERSIBLE.${NC}"
    echo ""
    echo -e "${YELLOW}Make sure you know what you are doing!${NC}"
    echo ""
    echo -e "Current AWS Identity:"
    aws sts get-caller-identity 2>/dev/null || echo "  (unable to determine - check AWS credentials)"
    echo ""
    print_separator
    echo ""
    echo -e "${BOLD}Enter Cloud-Nuke command arguments (or 'q' to go back):${NC}"
    echo -e "${CYAN}Examples:${NC}"
    echo "  aws-nuke --dry-run"
    echo "  nuke --region us-east-1 --dry-run"
    echo "  inspect-nuke"
    echo ""
    echo -n "> cloud-nuke "
    read -r cloud_nuke_args

    if [[ "$cloud_nuke_args" == "q" || "$cloud_nuke_args" == "Q" ]]; then
        return
    fi

    echo ""
    echo -e "${RED}Are you sure you want to run: cloud-nuke ${cloud_nuke_args}? (yes/no)${NC}"
    read -r confirm

    if [[ "$confirm" == "yes" ]]; then
        echo ""
        # shellcheck disable=SC2086
        cloud-nuke $cloud_nuke_args
    else
        echo -e "${YELLOW}Cancelled.${NC}"
    fi

    pause
}

# ─── Install Tools Functions ────────────────────────────────────────────────────
check_brew_installed() {
    command -v brew &>/dev/null
}

install_brew() {
    print_header
    echo -e "${GREEN}🍺 Installing Homebrew (Linuxbrew)...${NC}"
    print_separator
    echo ""

    if check_brew_installed; then
        echo -e "${YELLOW}⚠️  Homebrew is already installed!${NC}"
        echo ""
        brew --version
        pause
        return
    fi

    echo "Cloning Homebrew..."
    git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew

    echo "Creating local bin directory..."
    mkdir -p ~/.linuxbrew/bin

    echo "Linking brew executable..."
    ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin/brew

    echo "Configuring shell environment..."
    eval "$(~/.linuxbrew/bin/brew shellenv)"

    echo "Making environment change permanent in bash..."
    echo 'eval $(~/.linuxbrew/bin/brew shellenv)' >> ~/.bashrc

    echo ""
    echo "Verifying installation..."
    brew --version

    echo ""
    echo -e "${GREEN}✅ Homebrew installed successfully!${NC}"

    pause
}

check_terraform_installed() {
    command -v terraform &>/dev/null
}

install_terraform() {
    print_header
    echo -e "${GREEN}🏗️  Installing Terraform...${NC}"
    print_separator
    echo ""

    if check_terraform_installed; then
        echo -e "${YELLOW}⚠️  Terraform is already installed!${NC}"
        echo ""
        terraform --version
        pause
        return
    fi

    echo "Fetching latest Terraform version..."
    local latest_version
    latest_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | grep -o '"current_version":"[^"]*"' | cut -d'"' -f4)

    if [[ -z "$latest_version" ]]; then
        echo -e "${RED}❌ Failed to determine latest Terraform version.${NC}"
        pause
        return
    fi

    echo "Latest version: ${latest_version}"
    echo ""

    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) echo -e "${RED}❌ Unsupported architecture: ${arch}${NC}"; pause; return ;;
    esac

    local os
    os=$(uname -s | tr '[:upper:]' '[:lower:]')

    local url="https://releases.hashicorp.com/terraform/${latest_version}/terraform_${latest_version}_${os}_${arch}.zip"

    echo "Downloading from: $url"
    curl -Lo /tmp/terraform.zip "$url"

    echo "Extracting..."
    unzip -q -o /tmp/terraform.zip -d /tmp/

    echo "Installing to /usr/local/bin..."
    sudo mv /tmp/terraform /usr/local/bin/terraform
    sudo chmod +x /usr/local/bin/terraform

    # Cleanup
    rm -f /tmp/terraform.zip

    echo ""
    echo -e "${GREEN}✅ Terraform installed successfully!${NC}"
    terraform --version

    pause
}

check_steampipe_installed() {
    command -v steampipe &>/dev/null
}

install_steampipe() {
    print_header
    echo -e "${GREEN}🔍 Installing Steampipe...${NC}"
    print_separator
    echo ""

    if check_steampipe_installed; then
        echo -e "${YELLOW}⚠️  Steampipe is already installed!${NC}"
        echo ""
        steampipe --version
        pause
        return
    fi

    echo "Running Steampipe installer..."
    echo ""

    sudo /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)"

    echo ""
    echo "Installing AWS plugin..."
    steampipe plugin install aws

    echo ""
    echo -e "${GREEN}✅ Steampipe installed with AWS plugin!${NC}"
    steampipe --version

    pause
}

check_ssm_plugin_installed() {
    command -v session-manager-plugin &>/dev/null
}

install_session_manager_plugin() {
    print_header
    echo -e "${GREEN}🔌 Installing Session Manager Plugin...${NC}"
    print_separator
    echo ""

    if check_ssm_plugin_installed; then
        echo -e "${YELLOW}⚠️  Session Manager Plugin is already installed!${NC}"
        echo ""
        session-manager-plugin --version
        pause
        return
    fi

    local arch
    arch=$(uname -m)
    local os
    os=$(uname -s | tr '[:upper:]' '[:lower:]')

    if [[ "$os" == "linux" ]]; then
        case "$arch" in
            x86_64)
                local url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"
                echo "Downloading Session Manager Plugin (Linux x86_64)..."
                curl -Lo /tmp/session-manager-plugin.deb "$url"
                sudo dpkg -i /tmp/session-manager-plugin.deb 2>/dev/null || \
                    sudo rpm -i /tmp/session-manager-plugin.deb 2>/dev/null || {
                        # Fallback: try RPM package
                        local rpm_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/64bit/session-manager-plugin.rpm"
                        curl -Lo /tmp/session-manager-plugin.rpm "$rpm_url"
                        sudo rpm -i /tmp/session-manager-plugin.rpm
                    }
                rm -f /tmp/session-manager-plugin.deb /tmp/session-manager-plugin.rpm
                ;;
            aarch64|arm64)
                local url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb"
                echo "Downloading Session Manager Plugin (Linux arm64)..."
                curl -Lo /tmp/session-manager-plugin.deb "$url"
                sudo dpkg -i /tmp/session-manager-plugin.deb 2>/dev/null || {
                    local rpm_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/arm64/session-manager-plugin.rpm"
                    curl -Lo /tmp/session-manager-plugin.rpm "$rpm_url"
                    sudo rpm -i /tmp/session-manager-plugin.rpm
                }
                rm -f /tmp/session-manager-plugin.deb /tmp/session-manager-plugin.rpm
                ;;
            *) echo -e "${RED}❌ Unsupported architecture: ${arch}${NC}"; pause; return ;;
        esac
    elif [[ "$os" == "darwin" ]]; then
        echo "Downloading Session Manager Plugin (macOS)..."
        local url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/session-manager-plugin.pkg"
        curl -Lo /tmp/session-manager-plugin.pkg "$url"
        sudo installer -pkg /tmp/session-manager-plugin.pkg -target /
        rm -f /tmp/session-manager-plugin.pkg
    else
        echo -e "${RED}❌ Unsupported OS: ${os}${NC}"
        pause
        return
    fi

    echo ""
    echo -e "${GREEN}✅ Session Manager Plugin installed successfully!${NC}"
    session-manager-plugin --version 2>/dev/null || echo "  (installed)"

    pause
}

# ─── Sub-Menus ─────────────────────────────────────────────────────────────────
menu_aws_cli() {
    while true; do
        print_header
        echo -e "${GREEN}${BOLD}  AWS CLI Tools${NC}"
        print_separator
        echo ""
        echo -e "  ${BOLD}1)${NC} View Current Versions"
        echo -e "  ${BOLD}2)${NC} Update AWS CLI v2"
        echo ""
        echo -e "  ${BOLD}b)${NC} ← Back to Main Menu"
        echo ""
        print_separator
        echo -n "  Select an option: "
        read -r choice

        case $choice in
            1) view_versions ;;
            2) update_aws_cli ;;
            b|B) return ;;
            *) echo -e "${RED}Invalid option.${NC}"; sleep 1 ;;
        esac
    done
}

menu_install_tools() {
    while true; do
        print_header
        echo -e "${BLUE}${BOLD}  🔧 Install Tools${NC}"
        print_separator
        echo ""
        echo -e "  ${BOLD}1)${NC} Install Brew"
        echo -e "  ${BOLD}2)${NC} Install Terraform"
        echo -e "  ${BOLD}3)${NC} Install Steampipe"
        echo -e "  ${BOLD}4)${NC} Install Session Manager Plugin"
        echo ""
        echo -e "  ${BOLD}b)${NC} ← Back to Main Menu"
        echo ""
        print_separator
        echo -n "  Select an option: "
        read -r choice

        case $choice in
            1) install_brew ;;
            2) install_terraform ;;
            3) install_steampipe ;;
            4) install_session_manager_plugin ;;
            b|B) return ;;
            *) echo -e "${RED}Invalid option.${NC}"; sleep 1 ;;
        esac
    done
}

menu_cloud_nuke() {
    while true; do
        print_header
        echo -e "${RED}${BOLD}  ⚠️  DANGER ZONE - Cloud-Nuke${NC}"
        print_separator
        echo ""

        echo -e "  ${BOLD}1)${NC} Install Cloud-Nuke"

        if check_cloud_nuke_installed; then
            echo -e "  ${BOLD}2)${NC} ${RED}Launch Cloud-Nuke${NC}"
        else
            echo -e "  ${BOLD}2)${NC} ${YELLOW}Launch Cloud-Nuke (not installed)${NC}"
        fi

        echo ""
        echo -e "  ${BOLD}b)${NC} ← Back to Main Menu"
        echo ""
        print_separator
        echo -n "  Select an option: "
        read -r choice

        case $choice in
            1) install_cloud_nuke ;;
            2)
                if check_cloud_nuke_installed; then
                    launch_cloud_nuke
                else
                    echo -e "  ${RED}Cloud-Nuke is not installed. Please install it first.${NC}"
                    sleep 2
                fi
                ;;
            b|B) return ;;
            *) echo -e "${RED}Invalid option.${NC}"; sleep 1 ;;
        esac
    done
}

# ─── Main Menu ─────────────────────────────────────────────────────────────────
main_menu() {
    while true; do
        print_header
        echo -e "  ${BOLD}1)${NC} ${GREEN}AWS CLI Tools${NC}"
        echo -e "  ${BOLD}2)${NC} ${BLUE}🔧 Install Tools${NC}"
        echo -e "  ${BOLD}3)${NC} ${RED}⚠️  DANGER ZONE${NC}"
        echo ""
        echo -e "  ${BOLD}q)${NC} Exit"
        echo ""
        print_separator
        echo -n "  Select an option: "
        read -r choice

        case $choice in
            1) menu_aws_cli ;;
            2) menu_install_tools ;;
            3) menu_cloud_nuke ;;
            q|Q) echo -e "\n${GREEN}Goodbye!${NC}\n"; exit 0 ;;
            *) echo -e "${RED}Invalid option.${NC}"; sleep 1 ;;
        esac
    done
}

# ─── Entry Point ───────────────────────────────────────────────────────────────
main_menu
