# BMAD-METHOD Evidence Collection Tools

This directory contains tools for collecting and analyzing evidence from different environments to optimize .gitignore rules for the BMAD-METHOD integration across multiple machines.

## Files

- `collect-evidence.sh` - Comprehensive evidence collection script
- `analyze-evidence.sh` - Evidence analysis and .gitignore generation script
- `README.md` - This documentation

## Usage

### Step 1: Collect Evidence

Run the evidence collection script in each environment:

```bash
# Navigate to isaac_ros_custom repository
cd ~/workspace/isaac_ros_custom

# Make sure you're on the correct branch
git checkout bmad-cipher-integration-success-20251016

# Run evidence collection
/path/to/BMAD-METHOD/tools/evidence-collection/collect-evidence.sh
```

This will create an evidence file with timestamp and hostname, e.g.:

- `evidence-macbook-20251016-143022.txt`
- `evidence-nano1-20251016-143545.txt`
- `evidence-nano2-20251016-144123.txt`

### Step 2: Analyze Evidence

Analyze the collected evidence to generate .gitignore recommendations:

```bash
# Analyze evidence file
/path/to/BMAD-METHOD/tools/evidence-collection/analyze-evidence.sh evidence-macbook-20251016-143022.txt
```

This will create:

- `analysis-macbook-20251016-143022.txt` - Detailed analysis report
- `gitignore-macbook-20251016-143022.txt` - Generated .gitignore rules

### Step 3: Apply Gitignore

Review and apply the generated .gitignore:

```bash
# Review the generated rules
cat gitignore-macbook-20251016-143022.txt

# Apply to repository (after review)
cp gitignore-macbook-20251016-143022.txt .gitignore
git add .gitignore
git commit -m "Add evidence-based .gitignore rules"
```

## What the Tools Collect

### Evidence Collection (`collect-evidence.sh`)

The script collects comprehensive evidence from each environment:

1. **Baseline Information**
   - Repository size and status
   - Current git branch and working tree state

2. **System Information**
   - OS details, hostname, user
   - Python, Node.js versions
   - Docker/Podman availability
   - Disk space and memory

3. **ROS2 Information**
   - ROS2 distro and setup
   - Available packages

4. **BMAD Framework**
   - Directory structure and file count
   - Configuration files

5. **Security-Sensitive Files**
   - Keys, certificates, secrets
   - SSH keys

6. **Temporary/Cache Files**
   - Logs, PID files, temporary files
   - Cache directories

7. **AI Assistant Files**
   - Claude, Gemini, Cursor configurations
   - Machine-specific AI data

8. **Environment-Specific Files**
   - macOS (.DS_Store)
   - Linux (.nvidia\*, .jetson)
   - Windows (Thumbs.db)

9. **Build Artifacts**
   - Build/install directories
   - ROS bag files
   - Test results

10. **IDE/Editor Files**
    - VS Code settings
    - Editor configurations

### Evidence Analysis (`analyze-evidence.sh`)

The analysis script:

1. **Categorizes Findings** - Groups files by type and risk level
2. **Provides Recommendations** - Suggests what to ignore vs keep
3. **Generates .gitignore** - Creates targeted gitignore rules
4. **Creates Reports** - Detailed analysis for review

## Deployment Instructions

### On MacBook (Your Machine)

```bash
# Already have the tools in BMAD-METHOD repo
cd ~/workspace/BMAD-METHOD
git checkout feature/cipher-integration
./tools/evidence-collection/collect-evidence.sh
```

### On nano1 and nano2

```bash
# Navigate to BMAD-METHOD repository
cd ~/workspace/BMAD-METHOD

# Make sure you're on the cipher branch
git checkout feature/cipher-integration
git pull origin feature/cipher-integration

# Navigate to isaac_ros_custom
cd ~/workspace/isaac_ros_custom
git checkout bmad-cipher-integration-success-20251016

# Run evidence collection
../BMAD-METHOD/tools/evidence-collection/collect-evidence.sh

# Run analysis (optional, can be done on MacBook after collecting evidence)
../BMAD-METHOD/tools/evidence-collection/analyze-evidence.sh evidence-nano1-YYYYMMDD-HHMMSS.txt
```

## Expected Output

### Evidence File Structure

```
========================================
BMAD-METHOD Evidence Collection Report
========================================
Hostname: nano1
Date: Tue Oct 16 14:35:45 PDT 2025
Timestamp: 20251016-143545
Directory: /home/amazon1148/workspace/isaac_ros_custom

=== BASELINE INFORMATION ===
Repository Size: 7.2M
Current Branch: bmad-cipher-integration-success-20251016
Git Status:
 M README.md
 M docs/HELPERS_OVERVIEW.md
?? CONTRIBUTING.md

=== SYSTEM INFORMATION ===
OS Info: Linux nano1 5.15.0-1015-jetson #...
Hostname: nano1
User: amazon1148
Shell: /bin/bash
Python: Python 3.10.12
Docker: Docker version 24.0.7

[... more sections ...]
```

### Generated .gitignore Structure

```
# Generated .gitignore based on evidence from nano1
# Generated: Tue Oct 16 14:40:12 PDT 2025

# ===========================================
# SECURITY-SENSITIVE FILES (HIGH PRIORITY)
# ===========================================
*.key
*.pem
*.crt
*.p12
bmad/keys/
bmad/certs/

# ===========================================
# AI ASSISTANT FILES (MACHINE-SPECIFIC)
# ===========================================
.claude/
.gemini/
.cursor/

[... more sections based on actual evidence ...]
```

## Benefits of This Approach

1. **Evidence-Based** - Only ignore files that actually exist
2. **Machine-Specific** - Tailored to each environment's needs
3. **Risk-Aware** - Prioritizes security files
4. **Validated** - Each rule backed by concrete evidence
5. **Minimal** - Avoids over-ignore
6. **Documented** - Complete analysis trail

## Next Steps

1. Collect evidence from all three machines
2. Analyze findings across environments
3. Compare .gitignore recommendations
4. Create unified .gitignore strategy
5. Apply and test across all machines
