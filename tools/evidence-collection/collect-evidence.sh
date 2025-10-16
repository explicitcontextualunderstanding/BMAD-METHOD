#!/bin/bash

# Evidence Collection Script for BMAD-METHOD Integration
# Collects comprehensive evidence from each environment for .gitignore optimization
# Usage: ./collect-evidence.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get current directory and verify we're in isaac_ros_custom
CURRENT_DIR=$(pwd)
if [[ ! "$CURRENT_DIR" =~ "isaac_ros_custom" ]]; then
    print_error "This script must be run from the isaac_ros_custom repository"
    print_error "Current directory: $CURRENT_DIR"
    exit 1
fi

# Create evidence file
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
HOSTNAME=$(hostname)
EVIDENCE_FILE="evidence-${HOSTNAME}-${TIMESTAMP}.txt"

print_status "Starting evidence collection for $HOSTNAME"
print_status "Evidence will be saved to: $EVIDENCE_FILE"

# Initialize evidence file
cat > "$EVIDENCE_FILE" << EOF
========================================
BMAD-METHOD Evidence Collection Report
========================================
Hostname: $HOSTNAME
Date: $(date)
Timestamp: $TIMESTAMP
Directory: $(pwd)

EOF

# Collect baseline information
print_status "Collecting baseline information..."
{
    echo "=== BASELINE INFORMATION ==="
    echo "Repository Size: $(du -sh . | cut -f1)"
    echo "Current Branch: $(git branch --show-current 2>/dev/null || echo 'Not a git repository')"
    echo "Git Status:"
    git status --porcelain 2>/dev/null || echo "Not a git repository"
    echo ""
} >> "$EVIDENCE_FILE"

# Collect system information
print_status "Collecting system information..."
{
    echo "=== SYSTEM INFORMATION ==="
    echo "OS Info: $(uname -a)"
    echo "Hostname: $HOSTNAME"
    echo "User: $(whoami)"
    echo "Shell: $SHELL"
    echo "Python: $(python3 --version 2>/dev/null || echo 'Not found')"
    echo "Node: $(node --version 2>/dev/null || echo 'Not found')"
    echo "Docker/Podman: $(docker --version 2>/dev/null || podman --version 2>/dev/null || echo 'Not found')"
    echo "Available Disk Space:"
    df -h . | tail -1
    echo "Available Memory:"
    free -h 2>/dev/null || echo "free command not available"
    echo ""
} >> "$EVIDENCE_FILE"

# Collect ROS2 information
print_status "Collecting ROS2 information..."
{
    echo "=== ROS2 INFORMATION ==="
    if [ -f "/opt/ros/humble/setup.bash" ]; then
        source /opt/ros/humble/setup.bash
        echo "ROS2 Distro: $ROS_DISTRO"
        echo "ROS2 Setup: /opt/ros/humble/setup.bash"
    elif [ -f "/opt/ros/jazzy/setup.bash" ]; then
        source /opt/ros/jazzy/setup.bash
        echo "ROS2 Distro: $ROS_DISTRO"
        echo "ROS2 Setup: /opt/ros/jazzy/setup.bash"
    elif [ -f "/opt/ros/iron/setup.bash" ]; then
        source /opt/ros/iron/setup.bash
        echo "ROS2 Distro: $ROS_DISTRO"
        echo "ROS2 Setup: /opt/ros/iron/setup.bash"
    else
        echo "ROS2: Not found or not sourced"
    fi

    # Check for ROS2 packages
    if command -v ros2 &> /dev/null; then
        echo "ROS2 packages: $(ros2 pkg list 2>/dev/null | wc -l || echo 'Unable to count')"
    fi
    echo ""
} >> "$EVIDENCE_FILE"

# Collect BMAD framework information
print_status "Collecting BMAD framework information..."
{
    echo "=== BMAD FRAMEWORK INFORMATION ==="
    if [ -d "bmad" ]; then
        echo "BMAD Directory: Found"
        echo "BMAD Size: $(du -sh bmad/ 2>/dev/null | cut -f1)"
        echo "BMAD Structure:"
        find bmad/ -type d | sort
        echo ""
        echo "BMAD Files (first 30):"
        find bmad/ -type f | head -30
        echo ""
        echo "BMAD File Count: $(find bmad/ -type f | wc -l)"
    else
        echo "BMAD Directory: Not found"
    fi
    echo ""
} >> "$EVIDENCE_FILE"

# Collect configuration files
print_status "Collecting configuration files..."
{
    echo "=== CONFIGURATION FILES ==="
    echo "YAML Files:"
    find . -name "*.yaml" -o -name "*.yml" | sort
    echo ""
    echo "JSON Files:"
    find . -name "*.json" | sort
    echo ""
    echo "Configuration Files (.conf, .cfg):"
    find . -name "*.conf" -o -name "*.cfg" | sort
    echo ""
} >> "$EVIDENCE_FILE"

# Collect security-sensitive files
print_status "Collecting security-sensitive files..."
{
    echo "=== SECURITY-SENSITIVE FILES ==="
    echo "Key Files:"
    find . -name "*.key" 2>/dev/null || echo "No .key files found"
    echo ""
    echo "Certificate Files:"
    find . -name "*.pem" -o -name "*.crt" -o -name "*.p12" 2>/dev/null || echo "No certificate files found"
    echo ""
    echo "Secret Files:"
    find . -name "*secret*" -o -name "*password*" -o -name "*token*" 2>/dev/null || echo "No obvious secret files found"
    echo ""
    echo "SSH Keys (in .ssh):"
    if [ -d "$HOME/.ssh" ]; then
        ls -la "$HOME/.ssh/" | grep -E "id_|known_hosts" || echo "No SSH keys found in standard location"
    fi
    echo ""
} >> "$EVIDENCE_FILE"

# Collect temporary and cache files
print_status "Collecting temporary and cache files..."
{
    echo "=== TEMPORARY AND CACHE FILES ==="
    echo "Log Files:"
    find . -name "*.log" 2>/dev/null || echo "No .log files found"
    echo ""
    echo "PID Files:"
    find . -name "*.pid" 2>/dev/null || echo "No .pid files found"
    echo ""
    echo "Temporary Files:"
    find . -name "*.tmp" -o -name "*.temp" 2>/dev/null || echo "No temporary files found"
    echo ""
    echo "Cache Files:"
    find . -name "*.cache" 2>/dev/null || echo "No cache files found"
    echo ""
} >> "$EVIDENCE_FILE"

# Collect AI assistant files
print_status "Collecting AI assistant files..."
{
    echo "=== AI ASSISTANT FILES ==="
    echo "Claude Files:"
    find . -name ".claude" -o -name "CLAUDE*" 2>/dev/null || echo "No Claude files found"
    echo ""
    echo "Gemini Files:"
    find . -name ".gemini" -o -name "GEMINI*" 2>/dev/null || echo "No Gemini files found"
    echo ""
    echo "Cursor Files:"
    find . -name ".cursor" -o -name "CURSOR*" 2>/dev/null || echo "No Cursor files found"
    echo ""
    echo "Other AI Assistant Files:"
    find . -name ".ai" -o -name "*.mcp" -o -name "mcp.json" 2>/dev/null || echo "No other AI assistant files found"
    echo ""
} >> "$EVIDENCE_FILE"

# Collect environment-specific files
print_status "Collecting environment-specific files..."
{
    echo "=== ENVIRONMENT-SPECIFIC FILES ==="
    echo "macOS Files:"
    find . -name ".DS_Store" -o -name ".AppleDouble" -o -name ".LSOverride" 2>/dev/null || echo "No macOS-specific files found"
    echo ""
    echo "Linux Files:"
    find . -name ".nvidia*" -o -name ".compute-cache" -o -name ".jetson" 2>/dev/null || echo "No Linux-specific files found"
    echo ""
    echo "Windows Files:"
    find . -name "Thumbs.db" -o -name "desktop.ini" 2>/dev/null || echo "No Windows-specific files found"
    echo ""
} >> "$EVIDENCE_FILE"

# Collect IDE and editor files
print_status "Collecting IDE and editor files..."
{
    echo "=== IDE AND EDITOR FILES ==="
    echo "VS Code Files:"
    find . -path "*/.vscode/*" -name "settings.json" -o -path "*/.vscode/*" -name "launch.json" 2>/dev/null || echo "No VS Code settings found"
    echo ""
    echo "Other Editor Files:"
    find . -name ".editorconfig" -o -name ".vimrc" -o -name ".emacs" 2>/dev/null || echo "No editor config files found"
    echo ""
} >> "$EVIDENCE_FILE"

# Collect build artifacts
print_status "Collecting build artifacts..."
{
    echo "=== BUILD ARTIFACTS ==="
    echo "Build Directories:"
    find . -name "build" -type d 2>/dev/null || echo "No build directories found"
    echo ""
    echo "Install Directories:"
    find . -name "install" -type d 2>/dev/null || echo "No install directories found"
    echo ""
    echo "Log Directories:"
    find . -name "log" -type d -o -name "logs" -type d 2>/dev/null || echo "No log directories found"
    echo ""
    echo "ROS Bag Files:"
    find . -name "*.bag" -o -name "*.bag.active" 2>/dev/null || echo "No ROS bag files found"
    echo ""
} >> "$EVIDENCE_FILE"

# Collect container information
print_status "Collecting container information..."
{
    echo "=== CONTAINER INFORMATION ==="
    if command -v docker &> /dev/null; then
        echo "Docker Version: $(docker --version)"
        echo "Docker Containers: $(docker ps -a 2>/dev/null | wc -l)"
        echo "Docker Images: $(docker images 2>/dev/null | wc -l)"
    elif command -v podman &> /dev/null; then
        echo "Podman Version: $(podman --version)"
        echo "Podman Containers: $(podman ps -a 2>/dev/null | wc -l)"
        echo "Podman Images: $(podman images 2>/dev/null | wc -l)"
    else
        echo "Container runtime not found"
    fi
    echo ""
} >> "$EVIDENCE_FILE"

# Final summary
print_status "Creating summary..."
{
    echo "=== SUMMARY ==="
    echo "Total Files in Repository: $(find . -type f | wc -l)"
    echo "Total Directories: $(find . -type d | wc -l)"
    echo "Total Size: $(du -sh . | cut -f1)"
    echo ""
    echo "Evidence Collection Completed: $(date)"
    echo "Evidence File: $EVIDENCE_FILE"
} >> "$EVIDENCE_FILE"

print_success "Evidence collection completed!"
print_success "Evidence saved to: $EVIDENCE_FILE"
print_status "File size: $(du -sh "$EVIDENCE_FILE" | cut -f1)"
print_status "Line count: $(wc -l < "$EVIDENCE_FILE") lines"

# Show a preview
print_status "Evidence file preview (first 20 lines):"
echo "----------------------------------------"
head -20 "$EVIDENCE_FILE"
echo "----------------------------------------"

print_success "To view the full evidence file: cat $EVIDENCE_FILE"
print_success "To analyze evidence: ./analyze-evidence.sh $EVIDENCE_FILE"