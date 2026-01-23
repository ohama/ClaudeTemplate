#!/bin/bash

# ClaudeTemplate Clean Script
# Usage: ./scripts/clean.sh [project-name]

set -e

PROJECT_NAME="${1:-My Project}"

echo "=========================================="
echo " ClaudeTemplate Initialization"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -d ".claude" ]; then
    echo "Error: .claude directory not found."
    echo "Please run this script from the template root directory."
    exit 1
fi

# Check if already initialized
if [ ! -f "README.ko.md" ] && [ ! -f "CHANGELOG.md" ]; then
    echo "Warning: Template appears to be already initialized."
    read -p "Continue anyway? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "Aborted."
        exit 0
    fi
fi

echo "Project name: $PROJECT_NAME"
echo ""

# 1. Remove template's git history
echo "[1/8] Removing template git history..."
rm -rf .git

# 2. Remove template files
echo "[2/8] Removing template files..."
rm -f README.md README.ko.md CHANGELOG.md
rm -rf .claude/logs/
rm -rf .claude/youtube/

# 3. Reset version
echo "[3/8] Resetting version..."
echo "0.1.0" > VERSION

# 4. Reset HISTORY.md
echo "[4/8] Resetting HISTORY.md..."
cat > .claude/HISTORY.md << 'EOF'
# HISTORY

Major decisions, changes, issues only.

## YYYY-MM-DD
- Decision:
- Change:
- Issue:
EOF

# 5. Reset STATE.md
echo "[5/8] Resetting STATE.md..."
cat > .claude/STATE.md << 'EOF'
# STATE

## Current Phase
(none)

## Current Step
(none)

## Completed Steps
- (none)

## In Progress
- (none)

## Next Step
(none)

## Blockers
- (none)

## Evidence
```
(last command/test result)
```

---

## Meta
- Cache: CLEAN
- Last Updated: (auto)
EOF

# 6. Reset CACHE.md
echo "[6/8] Resetting CACHE.md..."
cat > .claude/CACHE.md << 'EOF'
# CACHE

임시 발견 사항, 메모, 나중에 정리할 내용을 기록합니다.
`/flush` 명령으로 knowledge 파일로 이동시킵니다.

**Status**: CLEAN

---

## 발견 사항

(없음)

## 메모

(없음)

## TODO (나중에 처리)

(없음)
EOF

# 7. Initialize git repository
echo "[7/8] Initializing git repository..."
git init

# 8. Create README.md
echo "[8/8] Creating README.md..."
cat > README.md << EOF
# $PROJECT_NAME

## Description

(프로젝트 설명)

## Getting Started

\`\`\`bash
# Build
(빌드 명령어)

# Test
(테스트 명령어)
\`\`\`

## Development

This project uses [ClaudeTemplate](https://github.com/ohama/ClaudeTemplate) for Claude Code development.

\`\`\`
/startsession   # Start working
/endsession     # End session
/status         # Check status
\`\`\`
EOF

echo ""
echo "=========================================="
echo " Initialization Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "  1. Edit CLAUDE.md - Your project context"
echo "  2. Edit .claude/PLAN.md - Project goals and Phase/Step plan"
echo "  3. Edit .claude/knowledge/ARCHITECTURE.md - Project structure"
echo "  4. Edit .claude/knowledge/BUILD.md - Build commands"
echo "  5. Edit .claude/knowledge/TESTING.md - Test commands"
echo ""
echo "  Then run:"
echo "    git add ."
echo "    git commit -m \"chore: initial project setup from ClaudeTemplate\""
echo ""
echo "  Start working:"
echo "    /startsession"
echo ""
