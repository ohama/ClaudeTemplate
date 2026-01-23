# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.5] - 2026-01-23

### Added
- **YouTube MCP Guide**: `.claude/youtube/05-mcp.md` comprehensive MCP tutorial (10-12 min)
  - Context7, Sequential Thinking, Memory, GitHub usage guides
  - Setup instructions and practical tips

### Changed
- **YouTube README**: Added 5th section for MCP, updated keywords
- **YouTube Overview**: Added MCP references and .mcp.json to directory structure

## [0.2.4] - 2026-01-23

### Added
- **MCP Integration**: Pre-configured MCP servers for enhanced AI assistance
  - Context7: Up-to-date library documentation
  - Sequential Thinking: Structured problem-solving
  - Memory: Persistent knowledge graph
  - GitHub: GitHub API for PRs, issues, repos
- **MCP Documentation**: `.claude/docs/mcp.md` with detailed setup and usage guide
- **YouTube Materials**: `.claude/youtube/` explanation documents for tutorial creation

## [0.2.3] - 2026-01-22

### Added
- **`/nextphase` command**: Execute next phase only
  - Default: auto-execute without confirmation
  - `--confirm`: ask for confirmation after each step

### Changed
- **`/phase run`**: Now executes ALL phases (not just current)
- **Removed `/phase all`**: Merged into `/phase run`

## [0.2.2] - 2026-01-22

### Added
- **`/phase all` command**: Execute all phases in the entire project
  - Default: auto-execute without confirmation
  - `--confirm`: ask for confirmation after each step
  - Shows overall project progress (all phases and steps)

## [0.2.1] - 2026-01-22

### Added
- **`/phase run` command**: Execute all steps in current phase automatically
  - Default: auto-execute without confirmation
  - `--confirm`: ask for confirmation after each step

## [0.2.0] - 2026-01-22

### Added
- **Skills system**: 6 new development methodology skills
  - `git.md` - Conventional Commits, branch strategies, AFTER principle
  - `property-testing.md` - Property-based testing patterns
  - `debugging.md` - 7-step debugging framework
  - `logging.md` - Structured logging with OpenTelemetry
  - `code-review.md` - 8-pillar code review checklist
  - `cicd.md` - CI/CD pipeline patterns and deployment strategies
- **`/issue build` command**: Record build/test errors with dedicated template
- **Automatic build issue recording**: `claude-behavior/build-issues.md` skill
  - Auto-record errors after resolution or when stuck
  - TDD Red phase excluded (intentional failures)
- **`scripts/clean.sh`**: Clean script for new projects
  - Resets VERSION to 0.1.0, clears HISTORY/STATE/CACHE, removes logs
- **Quick Start section**: Template user setup guide in README files
- **Commands-Skills documentation**: `.claude/docs/commands.md`, `.claude/docs/skills.md`

### Changed
- **Issue system**: Directory separation (open/ and resolved/) instead of Status field
- **Commands enhanced with Skills references**:
  - `commit.md` → references `skills/git.md`, added `perf` and `ci` types
  - `tdd.md` → simplified, references `skills/tdd.md`
  - `historyupdate.md` → references `skills/claude-behavior/history.md`
  - `startsession.md` → loads multiple skills on session start
- **README files**: User-focused Quick Start with complete reset instructions

### Refactored
- Moved `knowledge/TDD.md` → `skills/tdd.md`
- Moved `prompts/history-summarizer.md` → `skills/claude-behavior/history.md`
- Removed redundant `prompts/prompt-logger.md` (duplicate of logprompts command)

## [0.1.0] - 2026-01-22

### Added
- Initial project setup with Claude configuration and documentation
- Bilingual README support (English + Korean)
- `/plan` command for project progress overview
- `/logprompts` command with Claude response summary feature
- TDD-based development workflow (Red → Green → Refactor)
- Phase > Step workflow for systematic task management
- Knowledge management system (CACHE, flush, knowledge files)
- Custom commands: startsession, endsession, nextstep, endstep, tdd, phase, status, issue, flush, commit, release
- F# expert skill (ROP, Expecto, Serilog)
- Reusable prompts for logging and history summarization
