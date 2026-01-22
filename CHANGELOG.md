# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
- **`scripts/init.sh`**: Initialization script for new projects
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
