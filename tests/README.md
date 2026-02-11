# Test Suite for Claude DevEx Configuration Files

Comprehensive validation tests for the `.claude/` directory structure and configuration files added in the claude-devex v1.0.0 integration.

## Overview

This test suite validates the following changed files:
- `.claude/.devex-version` - Version tracking file
- `.claude/README.md` - AI-Native Development workflow guide
- `.claude/skills/implement/SKILL.md` - Implementation workflow skill
- `.claude/skills/spec/SKILL.md` - Specification workflow skill

## Test Coverage

### Total Test Count: 67 tests across 2 test suites

#### 1. Basic Validation Tests (40 tests)
**File:** `validate_devex_files.sh`

- **Suite 1: .devex-version file (4 tests)**
  - File existence and readability
  - Non-empty content
  - Semantic versioning format (X.Y.Z)
  - Correct version value (1.0.0)

- **Suite 2: README.md file (11 tests)**
  - File existence
  - Main title presence
  - Required sections (요구사항, 개발 사이클, 이슈 사이징 기준, etc.)
  - Mermaid diagram inclusion
  - All 5 skills mentioned (/github-issue, /spec, /implement, /commit, /github-pr)

- **Suite 3: implement/SKILL.md file (11 tests)**
  - File existence and structure
  - Required sections (역할, 프로젝트 프로필 연동, 전제조건, 워크플로우, 규칙)
  - Project profile integration
  - References to /spec skill
  - Verification/validation requirements
  - Prohibition of direct commits

- **Suite 4: spec/SKILL.md file (11 tests)**
  - File existence and structure
  - Required sections (역할, 프로젝트 프로필 연동, 워크플로우, 산출물, 규칙)
  - Mermaid diagram references
  - Code writing prohibition
  - User approval requirement

- **Suite 5: Cross-file consistency (3 tests)**
  - Both SKILL files reference project-profile.md
  - README mentions both /implement and /spec
  - README describes complete workflow

#### 2. Edge Cases & Negative Tests (27 tests)
**File:** `edge_cases_and_negative_tests.sh`

- **Suite 1: Version Format Edge Cases (5 tests)**
  - No leading/trailing whitespace
  - Stable version (no pre-release identifiers)
  - Appropriate line count
  - Strict semver format (no 'v' prefix)
  - Reasonable file size (< 100 bytes)

- **Suite 2: Markdown File Integrity (5 tests)**
  - Reasonable file size (500B-50KB)
  - At least one H1 header
  - Balanced code blocks (backticks)
  - Markdown tables present
  - No placeholder text (TODO, FIXME, etc.)

- **Suite 3: SKILL File Edge Cases (8 tests)**
  - Reasonable file sizes (200B-20KB)
  - Exactly one H1 header per file
  - No placeholder text
  - Correct section ordering (역할 before 워크플로우)

- **Suite 4: Cross-file Compatibility (4 tests)**
  - Consistent header style (ATX format)
  - No broken internal links
  - Lowercase directory names
  - All expected SKILL.md files exist

- **Suite 5: Regression Tests (5 tests)**
  - Complete workflow cycle documentation
  - Implement skill references spec workflow
  - Spec skill enforces no-code constraint
  - Implement skill requires design document
  - Version is exactly 1.0.0 (stable release)

## Running the Tests

### Run All Tests
```bash
./tests/run_all_tests.sh
```

### Run Individual Test Suites
```bash
# Basic validation tests
./tests/validate_devex_files.sh

# Edge cases and negative tests
./tests/edge_cases_and_negative_tests.sh
```

## Test Results

Current status: **✅ ALL TESTS PASSING (67/67)**

```
Basic Validation Tests:     40/40 passed
Edge Cases & Negative Tests: 27/27 passed
```

## Test Philosophy

These tests follow best practices for documentation validation:

1. **Structure Validation**: Ensures required sections and proper formatting
2. **Content Validation**: Verifies key concepts and references are present
3. **Format Validation**: Checks file formats (semver, markdown syntax)
4. **Consistency Validation**: Ensures cross-file references are correct
5. **Edge Case Testing**: Validates boundary conditions and file integrity
6. **Regression Testing**: Prevents workflow integrity issues

## Dependencies

- Bash 4.0 or higher
- Standard Unix utilities (grep, wc, tr)
- Files must be checked out from git repository

## Test Design

The tests are designed to be:
- **Fast**: Complete execution in under 5 seconds
- **Portable**: No external dependencies beyond standard Unix tools
- **Clear**: Descriptive test names and colored output
- **Maintainable**: Each test is independent and well-documented
- **Comprehensive**: Covers functionality, edge cases, and regressions

## Adding New Tests

To add new tests:

1. Choose the appropriate test suite file
2. Follow the existing pattern:
   ```bash
   assert_file_contains "$FILE" "pattern" "Test description"
   ```
3. Update this README with test count and description
4. Ensure test is idempotent and doesn't modify files

## File Structure

```
tests/
├── README.md                          # This file
├── run_all_tests.sh                   # Master test runner
├── validate_devex_files.sh            # Basic validation tests (40 tests)
└── edge_cases_and_negative_tests.sh   # Edge case tests (27 tests)
```

## Exit Codes

- `0`: All tests passed
- `1`: One or more tests failed

## Continuous Integration

These tests are designed to be CI-friendly and can be integrated into:
- Pre-commit hooks
- GitHub Actions workflows
- GitLab CI pipelines
- Any CI/CD system supporting bash scripts

Example GitHub Actions usage:
```yaml
- name: Run DevEx validation tests
  run: |
    chmod +x tests/run_all_tests.sh
    tests/run_all_tests.sh
```

## Contributing

When modifying `.claude/` files, ensure all tests still pass:
1. Make your changes
2. Run `./tests/run_all_tests.sh`
3. Add new tests for new functionality
4. Update test count in this README