#!/bin/bash
# Validation tests for .claude DevEx configuration files
# Tests the files added in the claude-devex v1.0.0 integration

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

# Helper function to check if file exists
assert_file_exists() {
    local file="$1"
    local test_name="$2"

    if [ -f "$file" ]; then
        print_test_result "$test_name" "PASS"
        return 0
    else
        print_test_result "$test_name" "FAIL" "File does not exist: $file"
        return 1
    fi
}

# Helper function to check file content
assert_file_contains() {
    local file="$1"
    local pattern="$2"
    local test_name="$3"

    if grep -q "$pattern" "$file" 2>/dev/null; then
        print_test_result "$test_name" "PASS"
        return 0
    else
        print_test_result "$test_name" "FAIL" "Pattern not found: $pattern"
        return 1
    fi
}

# Helper function to validate semver format
assert_semver_format() {
    local version="$1"
    local test_name="$2"

    # Regex for semantic versioning (simplified)
    if echo "$version" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' > /dev/null; then
        print_test_result "$test_name" "PASS"
        return 0
    else
        print_test_result "$test_name" "FAIL" "Invalid semver format: $version"
        return 1
    fi
}

echo "================================================"
echo "  Claude DevEx Files Validation Test Suite"
echo "================================================"
echo ""

# Change to repository root
cd "$(dirname "$0")/.."

###########################################
# Test Suite 1: .devex-version file
###########################################
echo "Test Suite 1: .devex-version file"
echo "-----------------------------------"

DEVEX_VERSION_FILE=".claude/.devex-version"

# Test 1.1: File exists
assert_file_exists "$DEVEX_VERSION_FILE" "1.1 - .devex-version file exists"

# Test 1.2: File is not empty
if [ -f "$DEVEX_VERSION_FILE" ]; then
    if [ -s "$DEVEX_VERSION_FILE" ]; then
        print_test_result "1.2 - .devex-version file is not empty" "PASS"
    else
        print_test_result "1.2 - .devex-version file is not empty" "FAIL" "File is empty"
    fi
fi

# Test 1.3: Version follows semver format
if [ -f "$DEVEX_VERSION_FILE" ]; then
    VERSION=$(head -n 1 "$DEVEX_VERSION_FILE" | tr -d '[:space:]')
    assert_semver_format "$VERSION" "1.3 - Version follows semver format (X.Y.Z)"
fi

# Test 1.4: Version is 1.0.0
if [ -f "$DEVEX_VERSION_FILE" ]; then
    VERSION=$(head -n 1 "$DEVEX_VERSION_FILE" | tr -d '[:space:]')
    if [ "$VERSION" = "1.0.0" ]; then
        print_test_result "1.4 - Version is 1.0.0" "PASS"
    else
        print_test_result "1.4 - Version is 1.0.0" "FAIL" "Expected 1.0.0, got: $VERSION"
    fi
fi

echo ""

###########################################
# Test Suite 2: README.md file
###########################################
echo "Test Suite 2: .claude/README.md file"
echo "-------------------------------------"

README_FILE=".claude/README.md"

# Test 2.1: File exists
assert_file_exists "$README_FILE" "2.1 - README.md file exists"

# Test 2.2: Contains main title
assert_file_contains "$README_FILE" "# AI-Native Development Guide" "2.2 - Contains main title"

# Test 2.3: Contains requirements section
assert_file_contains "$README_FILE" "## 요구사항" "2.3 - Contains requirements section"

# Test 2.4: Contains development cycle section
assert_file_contains "$README_FILE" "## 개발 사이클" "2.4 - Contains development cycle section"

# Test 2.5: Contains issue sizing criteria
assert_file_contains "$README_FILE" "## 이슈 사이징 기준" "2.5 - Contains issue sizing criteria"

# Test 2.6: Contains skills operation explanation
assert_file_contains "$README_FILE" "## 스킬 동작 방식" "2.6 - Contains skills operation explanation"

# Test 2.7: Contains directory structure
assert_file_contains "$README_FILE" "## 디렉토리 구조" "2.7 - Contains directory structure"

# Test 2.8: Contains project profile section
assert_file_contains "$README_FILE" "## 프로젝트 프로필" "2.8 - Contains project profile section"

# Test 2.9: Contains setup.sh instructions
assert_file_contains "$README_FILE" "setup.sh" "2.9 - Contains setup.sh instructions"

# Test 2.10: Contains mermaid diagram
assert_file_contains "$README_FILE" "\`\`\`mermaid" "2.10 - Contains mermaid diagram"

# Test 2.11: Mentions all 5 skills
if [ -f "$README_FILE" ]; then
    skills_found=0
    for skill in github-issue spec implement commit github-pr; do
        if grep -q "/$skill" "$README_FILE"; then
            skills_found=$((skills_found + 1))
        fi
    done

    if [ $skills_found -eq 5 ]; then
        print_test_result "2.11 - Mentions all 5 skills" "PASS"
    else
        print_test_result "2.11 - Mentions all 5 skills" "FAIL" "Found $skills_found/5 skills"
    fi
fi

echo ""

###########################################
# Test Suite 3: implement/SKILL.md file
###########################################
echo "Test Suite 3: skills/implement/SKILL.md file"
echo "----------------------------------------------"

IMPLEMENT_SKILL=".claude/skills/implement/SKILL.md"

# Test 3.1: File exists
assert_file_exists "$IMPLEMENT_SKILL" "3.1 - implement/SKILL.md file exists"

# Test 3.2: Contains title
assert_file_contains "$IMPLEMENT_SKILL" "# Implement Skill" "3.2 - Contains skill title"

# Test 3.3: Contains role section
assert_file_contains "$IMPLEMENT_SKILL" "## 역할" "3.3 - Contains role section"

# Test 3.4: Contains project profile integration section
assert_file_contains "$IMPLEMENT_SKILL" "## 프로젝트 프로필 연동" "3.4 - Contains project profile integration section"

# Test 3.5: Contains prerequisites section
assert_file_contains "$IMPLEMENT_SKILL" "## 전제조건" "3.5 - Contains prerequisites section"

# Test 3.6: Contains workflow section
assert_file_contains "$IMPLEMENT_SKILL" "## 워크플로우" "3.6 - Contains workflow section"

# Test 3.7: Contains rules section
assert_file_contains "$IMPLEMENT_SKILL" "## 규칙" "3.7 - Contains rules section"

# Test 3.8: References project-profile.md
assert_file_contains "$IMPLEMENT_SKILL" "project-profile.md" "3.8 - References project-profile.md"

# Test 3.9: References /spec skill
assert_file_contains "$IMPLEMENT_SKILL" "/spec" "3.9 - References /spec skill"

# Test 3.10: Mentions verification/validation
assert_file_contains "$IMPLEMENT_SKILL" "검증" "3.10 - Mentions verification/validation"

# Test 3.11: Prohibits direct commit
if [ -f "$IMPLEMENT_SKILL" ]; then
    if grep -q "커밋.*금지\|푸시.*수행하지" "$IMPLEMENT_SKILL"; then
        print_test_result "3.11 - Prohibits direct commit" "PASS"
    else
        print_test_result "3.11 - Prohibits direct commit" "FAIL" "Should mention not to commit/push"
    fi
fi

echo ""

###########################################
# Test Suite 4: spec/SKILL.md file
###########################################
echo "Test Suite 4: skills/spec/SKILL.md file"
echo "----------------------------------------"

SPEC_SKILL=".claude/skills/spec/SKILL.md"

# Test 4.1: File exists
assert_file_exists "$SPEC_SKILL" "4.1 - spec/SKILL.md file exists"

# Test 4.2: Contains title
assert_file_contains "$SPEC_SKILL" "# Spec Skill" "4.2 - Contains skill title"

# Test 4.3: Contains role section
assert_file_contains "$SPEC_SKILL" "## 역할" "4.3 - Contains role section"

# Test 4.4: Contains project profile integration section
assert_file_contains "$SPEC_SKILL" "## 프로젝트 프로필 연동" "4.4 - Contains project profile integration section"

# Test 4.5: Contains workflow section
assert_file_contains "$SPEC_SKILL" "## 워크플로우" "4.5 - Contains workflow section"

# Test 4.6: Contains output/deliverables section
assert_file_contains "$SPEC_SKILL" "## 산출물" "4.6 - Contains output/deliverables section"

# Test 4.7: Contains rules section
assert_file_contains "$SPEC_SKILL" "## 규칙" "4.7 - Contains rules section"

# Test 4.8: References project-profile.md
assert_file_contains "$SPEC_SKILL" "project-profile.md" "4.8 - References project-profile.md"

# Test 4.9: Mentions Mermaid diagrams
assert_file_contains "$SPEC_SKILL" "Mermaid" "4.9 - Mentions Mermaid diagrams"

# Test 4.10: Prohibits code writing
if [ -f "$SPEC_SKILL" ]; then
    if grep -q "코드.*금지\|코드 작성 금지" "$SPEC_SKILL"; then
        print_test_result "4.10 - Prohibits code writing in spec phase" "PASS"
    else
        print_test_result "4.10 - Prohibits code writing in spec phase" "FAIL" "Should mention no code writing"
    fi
fi

# Test 4.11: Requires user approval
assert_file_contains "$SPEC_SKILL" "승인" "4.11 - Requires user approval"

echo ""

###########################################
# Test Suite 5: Cross-file consistency
###########################################
echo "Test Suite 5: Cross-file consistency"
echo "--------------------------------------"

# Test 5.1: Both SKILL files reference project-profile.md
if [ -f "$IMPLEMENT_SKILL" ] && [ -f "$SPEC_SKILL" ]; then
    impl_has_profile=$(grep -c "project-profile.md" "$IMPLEMENT_SKILL" || true)
    spec_has_profile=$(grep -c "project-profile.md" "$SPEC_SKILL" || true)

    if [ "$impl_has_profile" -gt 0 ] && [ "$spec_has_profile" -gt 0 ]; then
        print_test_result "5.1 - Both SKILL files reference project-profile.md" "PASS"
    else
        print_test_result "5.1 - Both SKILL files reference project-profile.md" "FAIL"
    fi
fi

# Test 5.2: README mentions both implement and spec skills
if [ -f "$README_FILE" ]; then
    has_implement=$(grep -c "/implement" "$README_FILE" || true)
    has_spec=$(grep -c "/spec" "$README_FILE" || true)

    if [ "$has_implement" -gt 0 ] && [ "$has_spec" -gt 0 ]; then
        print_test_result "5.2 - README mentions both /implement and /spec" "PASS"
    else
        print_test_result "5.2 - README mentions both /implement and /spec" "FAIL"
    fi
fi

# Test 5.3: README workflow matches skill workflow
if [ -f "$README_FILE" ]; then
    # Check if README describes the workflow: Issue → Spec → Implement → Commit → PR
    if grep -q "Issue.*Spec.*Implement" "$README_FILE"; then
        print_test_result "5.3 - README describes complete workflow" "PASS"
    else
        print_test_result "5.3 - README describes complete workflow" "FAIL"
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
    echo -e "${RED}TESTS FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}ALL TESTS PASSED${NC}"
    exit 0
fi