#!/bin/bash

# Evidence Analysis Script for BMAD-METHOD Integration
# Analyzes evidence files and generates .gitignore recommendations
# Usage: ./analyze-evidence.sh evidence-file.txt

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to extract section from evidence file
extract_section() {
    local section="$1"
    sed -n "/^=== $section ===/,/^===/p" "$EVIDENCE_FILE" | sed '1d;$d' | sed '$d'
}

# Function to analyze security-sensitive files
analyze_security() {
    print_status "Analyzing security-sensitive files..."
    {
        echo "=== SECURITY-SENSITIVE FILES ANALYSIS ==="
        local security_files
        security_files=$(extract_section "SECURITY-SENSITIVE FILES")

        if echo "$security_files" | grep -q "No.*found"; then
            echo "STATUS: ✅ No security files found (Good)"
            echo "RECOMMENDATION: Add preventive .gitignore rules for *.key, *.pem, *.crt"
        else
            echo "STATUS: ⚠️  Security files found!"
            echo "$security_files"
            echo "RECOMMENDATION: These files MUST be ignored"
        fi
        echo ""
    } >> "$ANALYSIS_FILE"
}

# Function to analyze AI assistant files
analyze_ai_assistants() {
    print_status "Analyzing AI assistant files..."
    {
        echo "=== AI ASSISTANT FILES ANALYSIS ==="
        local ai_files
        ai_files=$(extract_section "AI ASSISTANT FILES")

        if echo "$ai_files" | grep -q "No.*found"; then
            echo "STATUS: ✅ No AI assistant files found"
            echo "RECOMMENDATION: No AI assistant .gitignore rules needed"
        else
            echo "STATUS: ⚠️  AI assistant files found"
            echo "$ai_files"
            echo "RECOMMENDATION: These are machine-specific and should be ignored"
        fi
        echo ""
    } >> "$ANALYSIS_FILE"
}

# Function to analyze temporary/cache files
analyze_temp_files() {
    print_status "Analyzing temporary and cache files..."
    {
        echo "=== TEMPORARY/CACHE FILES ANALYSIS ==="
        local temp_files
        temp_files=$(extract_section "TEMPORARY AND CACHE FILES")

        if echo "$temp_files" | grep -q "No.*found"; then
            echo "STATUS: ✅ No temporary files found"
            echo "RECOMMENDATION: Clean environment"
        else
            echo "STATUS: ⚠️  Temporary files found"
            echo "$temp_files"
            echo "RECOMMENDATION: These should be ignored"
        fi
        echo ""
    } >> "$ANALYSIS_FILE"
}

# Function to analyze environment-specific files
analyze_environment_specific() {
    print_status "Analyzing environment-specific files..."
    {
        echo "=== ENVIRONMENT-SPECIFIC FILES ANALYSIS ==="
        local env_files
        env_files=$(extract_section "ENVIRONMENT-SPECIFIC FILES")

        if echo "$env_files" | grep -q "No.*found"; then
            echo "STATUS: ✅ No environment-specific files found"
            echo "RECOMMENDATION: Clean cross-platform environment"
        else
            echo "STATUS: ⚠️  Environment-specific files found"
            echo "$env_files"
            echo "RECOMMENDATION: These should be ignored"
        fi
        echo ""
    } >> "$ANALYSIS_FILE"
}

# Function to analyze build artifacts
analyze_build_artifacts() {
    print_status "Analyzing build artifacts..."
    {
        echo "=== BUILD ARTIFACTS ANALYSIS ==="
        local build_files
        build_files=$(extract_section "BUILD ARTIFACTS")

        if echo "$build_files" | grep -q "No.*found"; then
            echo "STATUS: ✅ No build artifacts found"
            echo "RECOMMENDATION: Clean build state"
        else
            echo "STATUS: ⚠️  Build artifacts found"
            echo "$build_files"
            echo "RECOMMENDATION: These should be ignored"
        fi
        echo ""
    } >> "$ANALYSIS_FILE"
}

# Function to analyze IDE files
analyze_ide_files() {
    print_status "Analyzing IDE and editor files..."
    {
        echo "=== IDE/EDITOR FILES ANALYSIS ==="
        local ide_files
        ide_files=$(extract_section "IDE AND EDITOR FILES")

        if echo "$ide_files" | grep -q "No.*found"; then
            echo "STATUS: ✅ No IDE-specific files found"
            echo "RECOMMENDATION: Clean environment"
        else
            echo "STATUS: ⚠️  IDE-specific files found"
            echo "$ide_files"
            echo "RECOMMENDATION: These are machine-specific and should be ignored"
        fi
        echo ""
    } >> "$ANALYSIS_FILE"
}

main() {
    # Check if evidence file provided
    if [ $# -eq 0 ]; then
        print_error "Usage: $0 <evidence-file.txt>"
        print_error "Example: $0 evidence-macbook-20251016-143022.txt"
        exit 1
    fi

    EVIDENCE_FILE="$1"

    if [ ! -f "$EVIDENCE_FILE" ]; then
        print_error "Evidence file not found: $EVIDENCE_FILE"
        exit 1
    fi

    # Extract hostname from evidence file
    HOSTNAME=$(grep "Hostname:" "$EVIDENCE_FILE" | cut -d' ' -f2)
    TIMESTAMP=$(grep "Timestamp:" "$EVIDENCE_FILE" | cut -d' ' -f2)

    print_status "Analyzing evidence from $HOSTNAME"
    print_status "Evidence file: $EVIDENCE_FILE"

    # Create analysis file
    ANALYSIS_FILE="analysis-${HOSTNAME}-${TIMESTAMP}.txt"
    GITIGNORE_FILE="gitignore-${HOSTNAME}-${TIMESTAMP}.txt"

    print_status "Analysis will be saved to: $ANALYSIS_FILE"
    print_status "Gitignore recommendations: $GITIGNORE_FILE"

    # Initialize analysis file
    cat > "$ANALYSIS_FILE" << EOF
========================================
BMAD-METHOD Evidence Analysis Report
========================================
Hostname: $HOSTNAME
Timestamp: $TIMESTAMP
Evidence File: $EVIDENCE_FILE
Analysis Date: $(date)

EOF

    # Run all analysis functions
    analyze_security
    analyze_ai_assistants
    analyze_temp_files
    analyze_environment_specific
    analyze_build_artifacts
    analyze_ide_files

    # Generate gitignore recommendations
    print_status "Generating .gitignore recommendations..."

    cat > "$GITIGNORE_FILE" << EOF
# Generated .gitignore based on evidence from $HOSTNAME
# Generated: $(date)
# Evidence file: $EVIDENCE_FILE

# ===========================================
# SECURITY-SENSITIVE FILES (HIGH PRIORITY)
# ===========================================
# Prevent any security files from being committed
*.key
*.pem
*.crt
*.p12
*.der
bmad/keys/
bmad/certs/
bmad/secrets/
*secret*
*password*
*token*

EOF

    # Add AI assistant rules if found
    if ! extract_section "AI ASSISTANT FILES" | grep -q "No.*found"; then
        cat >> "$GITIGNORE_FILE" << EOF

# ===========================================
# AI ASSISTANT FILES (MACHINE-SPECIFIC)
# ===========================================
.claude/
.gemini/
.cursor/
.ai/
.mcp.json
CLAUDE.local.md
CLAUDE.md
.cursor/settings.json
.gemini/settings.json

EOF
    fi

    # Add temporary files rules if found
    if ! extract_section "TEMPORARY AND CACHE FILES" | grep -q "No.*found"; then
        cat >> "$GITIGNORE_FILE" << EOF

# ===========================================
# TEMPORARY AND CACHE FILES
# ===========================================
*.log
*.pid
*.tmp
*.temp
*.cache
logs/
cache/
temp/
tmp/

EOF
    fi

    # Add environment-specific rules if found
    if ! extract_section "ENVIRONMENT-SPECIFIC FILES" | grep -q "No.*found"; then
        cat >> "$GITIGNORE_FILE" << EOF

# ===========================================
# ENVIRONMENT-SPECIFIC FILES
# ===========================================
.DS_Store
.AppleDouble
.LSOverride
Thumbs.db
desktop.ini
.nvidia*
.compute-cache/
.jetson/

EOF
    fi

    # Add build artifact rules if found
    if ! extract_section "BUILD ARTIFACTS" | grep -q "No.*found"; then
        cat >> "$GITIGNORE_FILE" << EOF

# ===========================================
# BUILD ARTIFACTS
# ===========================================
build/
install/
logs/
*.bag
*.bag.active
colcon_test_results/
test_results/
.devel/
.envrc

EOF
    fi

    # Add IDE rules if found
    if ! extract_section "IDE AND EDITOR FILES" | grep -q "No.*found"; then
        cat >> "$GITIGNORE_FILE" << EOF

# ===========================================
# IDE AND EDITOR FILES
# ===========================================
.vscode/settings.json
.vscode/launch.json
.cursor/settings.json
.editorconfig
.vimrc
.emacs

EOF
    fi

    # Add standard recommendations
    cat >> "$GITIGNORE_FILE" << EOF

# ===========================================
# STANDARD RECOMMENDATIONS
# ===========================================
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
.venv/

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# System
.DS_Store
Thumbs.db

# Backup files
*.bak
*.backup
*~
.~*

EOF

    # Final summary in analysis file
    {
        echo "=== SUMMARY ==="
        echo "Analysis completed for: $HOSTNAME"
        echo "Total .gitignore rules generated: $(wc -l < "$GITIGNORE_FILE")"
        echo "Gitignore file: $GITIGNORE_FILE"
        echo ""
        echo "NEXT STEPS:"
        echo "1. Review the generated .gitignore file"
        echo "2. Test with: git check-ignore <file>"
        echo "3. Apply to repository: cp $GITIGNORE_FILE .gitignore"
        echo "4. Commit changes: git add .gitignore && git commit -m 'Add evidence-based .gitignore'"
        echo ""
    } >> "$ANALYSIS_FILE"

    print_success "Evidence analysis completed!"
    print_success "Analysis saved to: $ANALYSIS_FILE"
    print_success "Gitignore recommendations: $GITIGNORE_FILE"

    # Show preview
    print_status "Generated .gitignore preview (first 20 lines):"
    echo "----------------------------------------"
    head -20 "$GITIGNORE_FILE"
    echo "----------------------------------------"

    print_success "To view full analysis: cat $ANALYSIS_FILE"
    print_success "To view generated .gitignore: cat $GITIGNORE_FILE"
}

main "$@"