# Claude Code Project Template

[![Korean](https://img.shields.io/badge/lang-한국어-blue.svg)](README.ko.md)

A template for large-scale project development using Claude Code.

---

## ⚡ Quick Start (IMPORTANT)

After cloning this template, you **MUST** reset template-specific files for your own project.

### Option A: Use init script (Recommended)

```bash
git clone https://github.com/ohama/ClaudeTemplate my-project
cd my-project
./scripts/init.sh "My Project Name"
```

### Option B: Manual setup

```bash
# 1. Clone the template
git clone https://github.com/ohama/ClaudeTemplate my-project
cd my-project

# 2. Remove template's git history
rm -rf .git

# 3. Remove template files
rm README.md README.ko.md CHANGELOG.md
rm -rf .claude/logs/

# 4. Reset version
echo "0.1.0" > VERSION

# 5. Reset state files (clear template history)
cat > .claude/HISTORY.md << 'EOF'
# HISTORY

Major decisions, changes, issues only.

## YYYY-MM-DD
- Decision:
- Change:
- Issue:
EOF

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

# 6. Initialize your own git repository
git init

# 7. Create your own README.md
echo "# My Project" > README.md

# 8. Initial commit
git add .
git commit -m "chore: initial project setup from ClaudeTemplate"
```

### After Setup - Edit These Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Your project's context for Claude |
| `.claude/PLAN.md` | Project goals and Phase/Step plan |
| `.claude/knowledge/ARCHITECTURE.md` | Project structure |
| `.claude/knowledge/BUILD.md` | Build commands |
| `.claude/knowledge/TESTING.md` | Test commands |

### Start Working

```
/startsession
```

---

## Features

- **TDD-based Development**: Red → Green → Refactor cycle
- **Phase > Step Workflow**: Systematic task division and progress management
- **Knowledge Management**: Document discoveries, decisions, and patterns
- **Custom Commands**: Automate repetitive tasks
- **Skills**: Language/framework-specific expert guidelines

---

## Directory Structure

```
.claude/
├── PLAN.md              # Project plan with Phase > Step structure
├── STATE.md             # Current progress state
├── CACHE.md             # Temporary discoveries
├── HISTORY.md           # Summary of key decisions/milestones
├── DECISIONS.md         # Technical decision records
├── README.md            # .claude directory guide
├── USAGE.md             # Command usage scenarios
│
├── commands/            # Custom commands
│   ├── startsession.md  # Start session
│   ├── endsession.md    # End session
│   ├── nextstep.md      # Start new Step
│   ├── endstep.md       # Complete Step
│   ├── tdd.md           # TDD cycle
│   ├── phase.md         # Phase management
│   ├── status.md        # Status check
│   ├── issue.md         # Issue management
│   ├── flush.md         # Cache cleanup
│   ├── commit.md        # Smart commit
│   ├── release.md       # Release
│   └── ...
│
├── skills/              # Language/framework/methodology experts
│   ├── fsharp.md        # F# expert (ROP, Expecto, Serilog)
│   ├── tdd.md           # TDD methodology
│   └── claude-behavior/ # Claude meta-skills
│       └── history.md   # History summarization
│
└── knowledge/           # Project knowledge
    ├── ARCHITECTURE.md  # Project structure
    ├── BUILD.md         # Build guide
    ├── TESTING.md       # Testing guide
    ├── PATTERNS.md      # Code patterns
    └── RULES.md         # Development rules

docs/
├── spec/                # Specification documents
└── issues/              # Issue records
```

---

## Workflow

### Basic Work Flow

```
/startsession → /nextstep → /tdd (repeat) → /endstep → /endsession
```

### Phase Transition

```
/phase status → /phase complete → /phase next
```

### Work Structure

```
Phase 1: (Phase Name)
  └─ Step 1.1: (Step Name)     ← 1-2 hour scope
  └─ Step 1.2: (Step Name)
  └─ Step 1.3: (Step Name)
Phase 2: (Phase Name)
  └─ Step 2.1: (Step Name)
```

---

## Command List

### Session Management

| Command | Description |
|---------|-------------|
| `/startsession` | Start work session, load context |
| `/endsession` | End session, save state |
| `/status` | Check current status |

### Step Management

| Command | Description |
|---------|-------------|
| `/nextstep` | Start next Step |
| `/nextstep "goal"` | Create Step with new goal |
| `/endstep` | Complete current Step |
| `/tdd` | Execute TDD cycle |

### Phase Management

| Command | Description |
|---------|-------------|
| `/phase status` | Phase progress status |
| `/phase complete` | Complete current Phase |
| `/phase next` | Start next Phase |

### Knowledge Management

| Command | Description |
|---------|-------------|
| `/flush` | Organize CACHE → knowledge files |
| `/issue` | Record issue |
| `/issue resolve <id>` | Resolve issue |

### Release

| Command | Description |
|---------|-------------|
| `/commit` | Smart commit (gitignore + grouped commits) |
| `/release` | Version upgrade + CHANGELOG |
| `/howto` | Generate tutorial documentation |

---

## CACHE and Knowledge Management

### What is CACHE?

`.claude/CACHE.md` is a file for storing temporary information discovered during work.

**Who records it?**
- **Claude automatically** records findings during work
- **By user request** - "Record this in CACHE"

**When to record?**
- When discovering new patterns during coding
- When finding anomalies after build/test execution
- When discovering project rules or constraints
- When finding TODOs to organize later

**Purpose**:
- Findings during work (bugs, improvements, anomalies)
- Notes to organize later
- TODO items

**Structure**:
```markdown
# CACHE

**Status**: CLEAN | DIRTY

---

## Discoveries
- --release flag needed for build
- API response time is slow

## Notes
- Refactoring ideas

## TODO (process later)
- Update documentation
```

**Status**:
- `CLEAN`: Nothing to organize
- `DIRTY`: `/flush` needed

### /flush Command

Categorizes and moves CACHE contents to appropriate knowledge files.

**How it works**:

```
CACHE.md (DIRTY)
    │
    ├─ Build related ────→ knowledge/BUILD.md
    ├─ Test related ─────→ knowledge/TESTING.md
    ├─ TDD related ──────→ knowledge/TDD.md
    ├─ Code patterns ────→ knowledge/PATTERNS.md
    └─ Rules/constraints → knowledge/RULES.md
    │
    ▼
CACHE.md (CLEAN)
```

**When to use**:
- Before ending session (before `/endsession`)
- When CACHE has accumulated a lot
- After completing a Step

**Example**:
```
User: /flush

Claude: CACHE status: DIRTY (5 items)

Classification results:
- Moved to BUILD.md: 2 items
  - "dotnet build --configuration Release required"
  - "DOTNET_ROOT environment variable setting required"
- Moved to PATTERNS.md: 2 items
  - "Result type chaining pattern"
  - "Async error handling pattern"
- Moved to RULES.md: 1 item
  - "XML comments required for public API"

CACHE cleanup complete. Status: CLEAN
```

### Why use CACHE?

1. **Context Preservation**: Discoveries are not lost between sessions
2. **Knowledge Accumulation**: Project know-how accumulates in knowledge files
3. **Quick Recording**: Note-taking without interrupting work
4. **Systematic Organization**: Auto-categorization with `/flush`

---

## TDD Workflow

### /tdd Command

Executes the TDD (Test-Driven Development) cycle.

**Cycle**:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ┌─────────┐     ┌─────────┐     ┌──────────┐     │
│   │   Red   │ ──→ │  Green  │ ──→ │ Refactor │     │
│   └─────────┘     └─────────┘     └──────────┘     │
│        │                               │           │
│        └───────────────────────────────┘           │
│                    Repeat                          │
└─────────────────────────────────────────────────────┘
```

### 1. Red - Write Failing Test

```
Goal: Confirm that the test fails

- Write test first for the feature to implement
- Run test to confirm failure
- Verify failure message is as expected
```

**Example**:
```fsharp
[<Test>]
let ``should validate email format`` () =
    let result = validateEmail "invalid-email"
    Expect.isError result "Invalid email should fail"
```

### 2. Green - Minimal Implementation

```
Goal: Write minimal code to pass the test

- Doesn't need to be perfect code
- Hardcoding is allowed
- Just confirm test passes
```

**Example**:
```fsharp
let validateEmail email =
    if email.Contains("@") then Ok email
    else Error "Invalid email"
```

### 3. Refactor - Code Improvement

```
Goal: Improve code quality (tests keep passing)

- Remove duplication
- Clear naming
- Structure improvement
- Verify tests still pass
```

**Example**:
```fsharp
let private isValidEmailFormat email =
    let emailRegex = Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$")
    emailRegex.IsMatch(email)

let validateEmail email =
    if String.IsNullOrWhiteSpace(email) then
        Error EmptyEmail
    elif not (isValidEmailFormat email) then
        Error (InvalidEmailFormat email)
    else
        Ok email
```

### TDD Rules

| Rule | Description |
|------|-------------|
| Test First | No production code without tests |
| One at a Time | Write only one test at a time |
| Bug Reproduction | Write reproduction test first when fixing bugs |
| Focus on Refactoring | No new features during refactoring |

### TDD Usage Example

```
User: /tdd

Claude: Current Step: 1.2 - Email Validation

[Red] Writing test:
- Added email validation test to tests/ValidationTests.fs
- Running test... Failed ✓

[Green] Minimal implementation:
- Added validateEmail function to src/Validation.fs
- Running test... Passed ✓

[Refactor] Code improvement:
- Improved validation logic with regex
- Refined error types
- Running test... Passed ✓

STATE.md updated.
Proceed to next test?
```

---

## Skills

### F# Expert (`skills/fsharp.md`)

Expert guidelines automatically activated for F# projects:

- **Railway Oriented Programming (ROP)**: Apply ROP pattern to all error handling
- **Expecto + FsCheck**: Testing framework
- **Serilog**: Structured logging

### Adding New Skills

Create a markdown file in `.claude/skills/` directory:

```markdown
# Skill Name

## Activation Conditions
- File extension: *.xx
- Specific conditions

## Core Principles
...

## Code Style
...
```

---

## Customization

### Adding New Commands

Create a markdown file in `.claude/commands/` directory:

```markdown
# command-name

Description

## Usage
/command-name [args]

## Procedure
1. ...
2. ...

## Rules
- ...
```

### Modifying Knowledge Files

Modify `.claude/knowledge/` files to fit your project:

- `ARCHITECTURE.md`: Project structure
- `BUILD.md`: Build commands
- `TESTING.md`: Testing strategy
- `PATTERNS.md`: Project code patterns
- `RULES.md`: Team rules

---

## Tips

1. **Always Start/End Sessions**: Use `/startsession` to start and `/endsession` to end for context preservation

2. **Step Size**: Scope completable within 1-2 hours

3. **Flush Often**: Use `/flush` to organize accumulated CACHE into knowledge files

4. **Record Issues Immediately**: `/issue` when discovered, `/issue resolve` when resolved

5. **Use `/commit` Before Committing**: Automatic gitignore management and grouped file commits

---

## License

MIT License
