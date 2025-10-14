# Manual Multi-Agent Development Workflows

1. Feature Branch Parallel Development

## On macOS M2 (main development machine)

git worktree add ../feature-frontend feature/frontend
cd ../feature-frontend
claude # Work on frontend components

## On Jetson Orin Nano1 (GPU-heavy tasks)

git worktree add ../feature-model-training feature/model-training
cd ../feature-model-training
gemini # Work on ML model optimization

## On Jetson Orin Nano2 (computer vision)

git worktree add ../feature-vision-processing feature/vision-processing
cd ../feature-vision-processing
claude # Work on camera/integration

## On Orange Pi Zero 3 (lightweight tasks)

git worktree add ../feature-data-pipeline feature/data-pipeline
cd ../feature-data-pipeline
github-copilot-cli # Work on data ingestion scripts

1. Agent Specialization by Task Type

- Claude: Architecture, code review, documentation, complex problem-solving
- GitHub Copilot CLI: Boilerplate code, unit tests, API integrations
- Gemini: Data analysis, ML pipelines, optimization tasks

1. Manual Task Distribution Workflow

## Create feature branches and worktrees

git checkout -b feature/multi-agent-pipeline
bmad worktree add ../workspaces/frontend frontend-workspace
bmad worktree add ../workspaces/backend backend-workspace
bmad worktree add ../workspaces/ml-pipeline ml-workspace

## SSH into machines and start agents

ssh jetson-orin-1 "cd /path/to/ml-workspace && gemini"
ssh jetson-orin-2 "cd /path/to/cv-workspace && claude"
ssh orange-pi "cd /path/to/data-workspace && github-copilot-cli"

## Local development on macOS

cd ../workspaces/frontend
claude

1. Cross-Platform Testing Pipeline

macOS M2: Development + UI testing
├── claude: Write React components
├── github-copilot-cli: Generate unit tests
└── Manual browser testing

Jetson Orin Nano 1: ML model validation
├── gemini: Optimize TensorFlow models
├── Test GPU performance
└── Validate model accuracy

Jetson Orin Nano 2: Computer vision integration
├── claude: Camera integration code
├── Test real-time processing
└── Validate video pipelines

Orange Pi Zero 3: Edge deployment
├── github-copilot-cli: Docker configurations
├── Test resource constraints
└── Validate deployment scripts

1. Manual Synchronization Workflow

## Morning sync across all machines

for machine in macos jetson1 jetson2 orange-pi; do
ssh $machine "cd /workspace && git pull origin main"
done

## During day - manual commits and pushes

## On each machine

git add .
git commit -m "Progress on [component]"
git push origin feature/[branch-name]

## Evening integration

git checkout main
git merge feature/frontend
git merge feature/ml-pipeline
git merge feature/data-pipeline

1. Agent Handoff Workflow

1. Claude (macOS): Design architecture and create base implementation
1. GitHub Copilot CLI (macOS): Generate boilerplate and tests
1. Gemini (Jetson 1): Optimize ML components for GPU
1. Claude (Jetson 2): Integrate computer vision components
1. GitHub Copilot CLI (Orange Pi): Create deployment configurations
1. Claude (macOS): Final integration and code review

1. Resource-Specific Task Assignment

- macOS M2: Heavy development, UI work, compilation tasks
- Jetson Orin Nano 1: TensorFlow/PyTorch model training, GPU acceleration
- Jetson Orin Nano 2: Real-time video processing, camera integration
- Orange Pi Zero 3: Lightweight data processing, IoT integrations, monitoring

1. Manual Session Management

## Use tmux/screen for persistent sessions

ssh jetson-orin-1 "tmux new -s ml-session"
ssh jetson-orin-2 "tmux new -s vision-session"
ssh orange-pi "tmux new -s data-session"

## Attach/detach as needed

ssh jetson-orin-1 "tmux attach -t ml-session"

These workflows leverage your hardware capabilities and agent strengths while requiring only manual coordination. The key is establishing clear handoff points and synchronization routines to avoid
conflicts.
