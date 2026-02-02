# GitHub Workflows

## Claude PR Review

PR 생성 시 Claude API를 통해 자동 코드 리뷰를 수행합니다.

### 설정

#### 1. API 키 발급

[Anthropic Console](https://console.anthropic.com/)에서 API 키 발급

#### 2. 시크릿 등록

1. Repository → Settings → Secrets and variables → Actions
2. "New repository secret" 클릭
3. Name: `ANTHROPIC_API_KEY`
4. Secret: 발급받은 API 키 입력

### 파일 구조

```
.github/
├── workflows/
│   └── pr-review.yml      # 워크플로우 정의
└── review-config.yml      # 리뷰 설정
```

### 리뷰 설정 (review-config.yml)

```yaml
persona: |
  시니어 개발자로서 코드 리뷰를 수행합니다.

language: ko          # 리뷰 언어

focus:                 # 집중할 영역
  - 버그 가능성
  - 보안 취약점
  - 성능 이슈

ignore:                # 무시할 파일
  - "*.md"
  - "*.yml"

max_comments: 10       # 최대 코멘트 수
```

### 동작 방식

1. PR 생성/업데이트 시 워크플로우 트리거
2. PR diff 추출
3. Claude API로 리뷰 요청
4. 리뷰 결과를 PR 코멘트로 작성

### 비용

- Claude API 사용량에 따라 과금
- 일반적인 PR: ~$0.01-0.05/리뷰

### 확장

다른 레포에 적용 시:
1. `.github/workflows/pr-review.yml` 복사
2. `.github/review-config.yml` 복사 후 수정
3. `ANTHROPIC_API_KEY` 시크릿 설정
