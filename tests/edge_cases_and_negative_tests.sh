#!/bin/bash
# Edge case and negative validation tests for .claude DevEx configuration files
# These tests verify boundary conditions, error handling, and regression scenarios

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test result tracking
print_test_result() {
    local test_name="$1"
    local result="$2"
    local message="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✓${NC} ${test_name}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} ${test_name}"
        if [ -n "$message" ]; then
            echo -e "  ${YELLOW}${message}${NC}"
        fi
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo "================================================"
echo "  Edge Cases & Negative Tests"
echo "================================================"
echo ""

# Change to repository root
cd "$(dirname "$0")/.."

###########################################
# Test Suite 1: Version Format Edge Cases
###########################################
echo "Test Suite 1: Version Format Edge Cases"
echo "-----------------------------------------"

DEVEX_VERSION_FILE=".claude/.devex-version"

# Test 1.1: Version doesn't have extra whitespace
if [ -f "$DEVEX_VERSION_FILE" ]; then
    VERSION_RAW=$(head -n 1 "$DEVEX_VERSION_FILE")
    VERSION_TRIMMED=$(echo "$VERSION_RAW" | tr -d '[:space:]')

    if [ "$VERSION_RAW" = "$VERSION_TRIMMED" ] || [ "${VERSION_RAW}" = "${VERSION_TRIMMED}" ]; then
        print_test_result "1.1 - Version has no leading/trailing whitespace" "PASS"
    else
        # This is actually OK if it's just a trailing newline
        if [ "$(echo -n "$VERSION_TRIMMED")" = "1.0.0" ]; then
            print_test_result "1.1 - Version has no leading/trailing whitespace" "PASS"
        else
            print_test_result "1.1 - Version has no leading/trailing whitespace" "FAIL" "Has whitespace"
        fi
    fi
fi

# Test 1.2: Version is not pre-release (no -alpha, -beta, etc.)
if [ -f "$DEVEX_VERSION_FILE" ]; then
    VERSION=$(head -n 1 "$DEVEX_VERSION_FILE" | tr -d '[:space:]')

    if echo "$VERSION" | grep -qE '\-'; then
        print_test_result "1.2 - Version is stable (not pre-release)" "FAIL" "Contains pre-release identifier"
    else
        print_test_result "1.2 - Version is stable (not pre-release)" "PASS"
    fi
fi

# Test 1.3: Version file has exactly 1 line (or 2 with trailing newline)
if [ -f "$DEVEX_VERSION_FILE" ]; then
    LINE_COUNT=$(wc -l < "$DEVEX_VERSION_FILE")

    if [ "$LINE_COUNT" -eq 1 ] || [ "$LINE_COUNT" -eq 2 ]; then
        print_test_result "1.3 - Version file has appropriate line count" "PASS"
    else
        print_test_result "1.3 - Version file has appropriate line count" "FAIL" "Has $LINE_COUNT lines"
    fi
fi

# Test 1.4: Version doesn't contain 'v' prefix (strict semver)
if [ -f "$DEVEX_VERSION_FILE" ]; then
    VERSION=$(head -n 1 "$DEVEX_VERSION_FILE" | tr -d '[:space:]')

    if echo "$VERSION" | grep -qE '^v'; then
        print_test_result "1.4 - Version follows strict semver (no 'v' prefix)" "FAIL" "Contains 'v' prefix"
    else
        print_test_result "1.4 - Version follows strict semver (no 'v' prefix)" "PASS"
    fi
fi

# Test 1.5: File size is reasonable (under 100 bytes)
if [ -f "$DEVEX_VERSION_FILE" ]; then
    FILE_SIZE=$(wc -c < "$DEVEX_VERSION_FILE" | tr -d '[:space:]')

    if [ "$FILE_SIZE" -lt 100 ]; then
        print_test_result "1.5 - Version file size is reasonable (< 100 bytes)" "PASS"
    else
        print_test_result "1.5 - Version file size is reasonable (< 100 bytes)" "FAIL" "Size: $FILE_SIZE bytes"
    fi
fi

echo ""

###########################################
# Test Suite 2: Markdown File Integrity
###########################################
echo "Test Suite 2: Markdown File Integrity"
echo "---------------------------------------"

README_FILE=".claude/README.md"

# Test 2.1: README has reasonable file size (not empty, not huge)
if [ -f "$README_FILE" ]; then
    FILE_SIZE=$(wc -c < "$README_FILE" | tr -d '[:space:]')

    if [ "$FILE_SIZE" -gt 500 ] && [ "$FILE_SIZE" -lt 50000 ]; then
        print_test_result "2.1 - README file size is reasonable (500B-50KB)" "PASS"
    else
        print_test_result "2.1 - README file size is reasonable (500B-50KB)" "FAIL" "Size: $FILE_SIZE bytes"
    fi
fi

# Test 2.2: README has at least one H1 header
if [ -f "$README_FILE" ]; then
    H1_COUNT=$(grep -c "^# " "$README_FILE" || true)

    if [ "$H1_COUNT" -ge 1 ]; then
        print_test_result "2.2 - README has at least one H1 header" "PASS"
    else
        print_test_result "2.2 - README has at least one H1 header" "FAIL" "Found $H1_COUNT H1 headers"
    fi
fi

# Test 2.3: README has balanced markdown code blocks
if [ -f "$README_FILE" ]; then
    TRIPLE_BACKTICK_COUNT=$(grep -c '```' "$README_FILE" || true)

    # Should be even number (opening and closing)
    if [ $((TRIPLE_BACKTICK_COUNT % 2)) -eq 0 ]; then
        print_test_result "2.3 - README has balanced code blocks" "PASS"
    else
        print_test_result "2.3 - README has balanced code blocks" "FAIL" "Unbalanced backticks: $TRIPLE_BACKTICK_COUNT"
    fi
fi

# Test 2.4: README has at least one table (for workflow description)
if [ -f "$README_FILE" ]; then
    if grep -q "|.*|.*|" "$README_FILE"; then
        print_test_result "2.4 - README contains markdown tables" "PASS"
    else
        print_test_result "2.4 - README contains markdown tables" "FAIL" "No tables found"
    fi
fi

# Test 2.5: README doesn't contain placeholder text
if [ -f "$README_FILE" ]; then
    if grep -qiE "TODO|FIXME|XXX|placeholder|lorem ipsum" "$README_FILE"; then
        print_test_result "2.5 - README has no placeholder text" "FAIL" "Contains placeholder markers"
    else
        print_test_result "2.5 - README has no placeholder text" "PASS"
    fi
fi

echo ""

###########################################
# Test Suite 3: SKILL File Edge Cases
###########################################
echo "Test Suite 3: SKILL File Edge Cases"
echo "-------------------------------------"

IMPLEMENT_SKILL=".claude/skills/implement/SKILL.md"
SPEC_SKILL=".claude/skills/spec/SKILL.md"

# Test 3.1: Both SKILL files have reasonable sizes
for skill_file in "$IMPLEMENT_SKILL" "$SPEC_SKILL"; do
    if [ -f "$skill_file" ]; then
        FILE_SIZE=$(wc -c < "$skill_file" | tr -d '[:space:]')
        SKILL_NAME=$(basename $(dirname "$skill_file"))

        if [ "$FILE_SIZE" -gt 200 ] && [ "$FILE_SIZE" -lt 20000 ]; then
            print_test_result "3.1 - ${SKILL_NAME}/SKILL.md has reasonable size (200B-20KB)" "PASS"
        else
            print_test_result "3.1 - ${SKILL_NAME}/SKILL.md has reasonable size (200B-20KB)" "FAIL" "Size: $FILE_SIZE bytes"
        fi
    fi
done

# Test 3.2: SKILL files don't have multiple H1 headers
for skill_file in "$IMPLEMENT_SKILL" "$SPEC_SKILL"; do
    if [ -f "$skill_file" ]; then
        H1_COUNT=$(grep -c "^# " "$skill_file" || true)
        SKILL_NAME=$(basename $(dirname "$skill_file"))

        if [ "$H1_COUNT" -eq 1 ]; then
            print_test_result "3.2 - ${SKILL_NAME}/SKILL.md has exactly one H1 header" "PASS"
        else
            print_test_result "3.2 - ${SKILL_NAME}/SKILL.md has exactly one H1 header" "FAIL" "Found $H1_COUNT"
        fi
    fi
done

# Test 3.3: SKILL files don't contain placeholder text
for skill_file in "$IMPLEMENT_SKILL" "$SPEC_SKILL"; do
    if [ -f "$skill_file" ]; then
        SKILL_NAME=$(basename $(dirname "$skill_file"))

        if grep -qiE "TODO|FIXME|XXX|placeholder" "$skill_file"; then
            print_test_result "3.3 - ${SKILL_NAME}/SKILL.md has no placeholders" "FAIL" "Contains placeholder markers"
        else
            print_test_result "3.3 - ${SKILL_NAME}/SKILL.md has no placeholders" "PASS"
        fi
    fi
done

# Test 3.4: SKILL files have consistent section ordering (역할 before 워크플로우)
for skill_file in "$IMPLEMENT_SKILL" "$SPEC_SKILL"; do
    if [ -f "$skill_file" ]; then
        SKILL_NAME=$(basename $(dirname "$skill_file"))

        # Get line numbers
        ROLE_LINE=$(grep -n "## 역할" "$skill_file" | cut -d: -f1 || echo "999")
        WORKFLOW_LINE=$(grep -n "## 워크플로우" "$skill_file" | cut -d: -f1 || echo "0")

        if [ "$ROLE_LINE" -lt "$WORKFLOW_LINE" ]; then
            print_test_result "3.4 - ${SKILL_NAME}/SKILL.md has correct section order" "PASS"
        else
            print_test_result "3.4 - ${SKILL_NAME}/SKILL.md has correct section order" "FAIL" "역할 should come before 워크플로우"
        fi
    fi
done

echo ""

###########################################
# Test Suite 4: Cross-file Compatibility
###########################################
echo "Test Suite 4: Cross-file Compatibility"
echo "----------------------------------------"

# Test 4.1: All markdown files use consistent header style (ATX vs Setext)
MD_FILES=("$README_FILE" "$IMPLEMENT_SKILL" "$SPEC_SKILL")
USES_ATX=0
USES_SETEXT=0

for md_file in "${MD_FILES[@]}"; do
    if [ -f "$md_file" ]; then
        if grep -q "^#" "$md_file"; then
            USES_ATX=1
        fi
        if grep -q "^===" "$md_file" || grep -q "^---" "$md_file"; then
            USES_SETEXT=1
        fi
    fi
done

if [ "$USES_ATX" -eq 1 ] && [ "$USES_SETEXT" -eq 0 ]; then
    print_test_result "4.1 - All markdown files use consistent header style (ATX)" "PASS"
elif [ "$USES_ATX" -eq 0 ] && [ "$USES_SETEXT" -eq 1 ]; then
    print_test_result "4.1 - All markdown files use consistent header style (Setext)" "PASS"
else
    print_test_result "4.1 - All markdown files use consistent header style" "FAIL" "Mixed styles detected"
fi

# Test 4.2: No broken internal links in README
if [ -f "$README_FILE" ]; then
    # Extract markdown links [text](path) and check if file paths exist
    BROKEN_LINKS=0

    # Look for links to .claude files - using a temp file instead of process substitution
    TEMP_LINKS=$(mktemp)
    grep -oP '\[.*?\]\(\K[^)]+' "$README_FILE" 2>/dev/null > "$TEMP_LINKS" || true

    while IFS= read -r link; do
        # Skip empty lines
        [ -z "$link" ] && continue

        # Skip URLs (http://, https://)
        if [[ "$link" =~ ^https?: ]]; then
            continue
        fi

        # Skip anchors (#section)
        if [[ "$link" =~ ^# ]]; then
            continue
        fi

        # Check if file exists (relative to repo root)
        if [ ! -f "$link" ] && [ ! -d "$link" ]; then
            BROKEN_LINKS=$((BROKEN_LINKS + 1))
        fi
    done < "$TEMP_LINKS"

    rm -f "$TEMP_LINKS"

    if [ "$BROKEN_LINKS" -eq 0 ]; then
        print_test_result "4.2 - README has no broken local file links" "PASS"
    else
        print_test_result "4.2 - README has no broken local file links" "FAIL" "Found $BROKEN_LINKS broken links"
    fi
fi

# Test 4.3: Skill naming is consistent (lowercase directory names)
SKILL_DIRS=(".claude/skills/implement" ".claude/skills/spec" ".claude/skills/commit" ".claude/skills/github-issue" ".claude/skills/github-pr")
ALL_LOWERCASE=1

for skill_dir in "${SKILL_DIRS[@]}"; do
    if [ -d "$skill_dir" ]; then
        DIR_NAME=$(basename "$skill_dir")
        if [[ "$DIR_NAME" =~ [A-Z] ]]; then
            ALL_LOWERCASE=0
        fi
    fi
done

if [ "$ALL_LOWERCASE" -eq 1 ]; then
    print_test_result "4.3 - All skill directory names are lowercase" "PASS"
else
    print_test_result "4.3 - All skill directory names are lowercase" "FAIL" "Found uppercase in directory names"
fi

# Test 4.4: All SKILL.md files exist in their respective directories
EXPECTED_SKILLS=("implement" "spec" "commit" "github-issue" "github-pr")
MISSING_SKILLS=0

for skill_name in "${EXPECTED_SKILLS[@]}"; do
    if [ ! -f ".claude/skills/$skill_name/SKILL.md" ]; then
        MISSING_SKILLS=$((MISSING_SKILLS + 1))
    fi
done

if [ "$MISSING_SKILLS" -eq 0 ]; then
    print_test_result "4.4 - All expected SKILL.md files exist" "PASS"
else
    print_test_result "4.4 - All expected SKILL.md files exist" "FAIL" "Missing $MISSING_SKILLS skills"
fi

echo ""

###########################################
# Test Suite 5: Regression Tests
###########################################
echo "Test Suite 5: Regression Tests"
echo "--------------------------------"

# Test 5.1: Workflow cycle is complete (no missing steps)
if [ -f "$README_FILE" ]; then
    WORKFLOW_STEPS=("Issue" "Spec" "Implement" "Commit" "PR")
    MISSING_STEPS=0

    for step in "${WORKFLOW_STEPS[@]}"; do
        if ! grep -q "$step" "$README_FILE"; then
            MISSING_STEPS=$((MISSING_STEPS + 1))
        fi
    done

    if [ "$MISSING_STEPS" -eq 0 ]; then
        print_test_result "5.1 - README documents complete workflow cycle" "PASS"
    else
        print_test_result "5.1 - README documents complete workflow cycle" "FAIL" "Missing $MISSING_STEPS steps"
    fi
fi

# Test 5.2: Both SKILL files properly reference the /spec -> /implement workflow
if [ -f "$IMPLEMENT_SKILL" ] && [ -f "$SPEC_SKILL" ]; then
    # implement should mention spec
    if grep -q "/spec\|설계 문서" "$IMPLEMENT_SKILL"; then
        print_test_result "5.2 - implement skill references spec workflow" "PASS"
    else
        print_test_result "5.2 - implement skill references spec workflow" "FAIL"
    fi
fi

# Test 5.3: Spec skill emphasizes no code writing (critical workflow constraint)
if [ -f "$SPEC_SKILL" ]; then
    if grep -q "코드.*금지\|코드 작성 금지" "$SPEC_SKILL"; then
        print_test_result "5.3 - spec skill enforces no-code constraint" "PASS"
    else
        print_test_result "5.3 - spec skill enforces no-code constraint" "FAIL"
    fi
fi

# Test 5.4: Implement skill requires design document (prevents premature implementation)
if [ -f "$IMPLEMENT_SKILL" ]; then
    if grep -q "전제조건\|설계 문서.*존재" "$IMPLEMENT_SKILL"; then
        print_test_result "5.4 - implement skill requires design document" "PASS"
    else
        print_test_result "5.4 - implement skill requires design document" "FAIL"
    fi
fi

# Test 5.5: Version is exactly 1.0.0 (first stable release)
if [ -f "$DEVEX_VERSION_FILE" ]; then
    VERSION=$(head -n 1 "$DEVEX_VERSION_FILE" | tr -d '[:space:]')
    if [ "$VERSION" = "1.0.0" ]; then
        print_test_result "5.5 - Version is 1.0.0 (stable initial release)" "PASS"
    else
        print_test_result "5.5 - Version is 1.0.0 (stable initial release)" "FAIL" "Version is $VERSION"
    fi
fi

echo ""
echo "================================================"
echo "  Test Summary"
echo "================================================"
echo "Total tests run: $TESTS_RUN"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
else
    echo -e "Failed: $TESTS_FAILED"
fi
echo ""

# Exit with appropriate code
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}SOME EDGE CASE TESTS FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}ALL EDGE CASE TESTS PASSED${NC}"
    exit 0
fi