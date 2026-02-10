# GitHub 설정

## CodeRabbit PR 자동 리뷰

PR 생성 시 [CodeRabbit](https://coderabbit.ai)을 통해 자동 코드 리뷰를 수행합니다.

### 설정 파일

`.coderabbit.yaml` (프로젝트 루트에 위치해야 함)

> CodeRabbit은 프로젝트 루트의 `.coderabbit.yaml`만 인식합니다. `.github/` 하위에는 배치할 수 없습니다.
> [공식 문서 참고](https://docs.coderabbit.ai/getting-started/yaml-configuration)

### 주요 설정 항목

```yaml
language: ko-KR                    # 리뷰 언어

reviews:
  profile: assertive               # 리뷰 스타일 (chill | assertive | supportive)
  high_level_summary: true         # PR 요약 생성
  request_changes_workflow: false   # Change Request 사용 여부
  path_filters:                    # 리뷰 제외 파일
    - "!**/*.md"
    - "!**/*.yml"
    - "!**/*.yaml"
  auto_review:
    enabled: true                  # 자동 리뷰 활성화
    drafts: false                  # Draft PR 제외

chat:
  auto_reply: true                 # PR 코멘트 자동 응답
```

### 리뷰 범위 (path_filters)

`!` 접두사로 리뷰 제외 패턴을 지정합니다:

| 패턴 | 설명 |
|------|------|
| `!**/*.md` | 마크다운 파일 제외 |
| `!**/*.yml` | YAML 파일 제외 |
| `!**/*.yaml` | YAML 파일 제외 |
| `!.gitignore` | .gitignore 제외 |
| `!docs/**` | docs 디렉토리 제외 |

### 동작 방식

1. PR 생성/업데이트 시 CodeRabbit이 자동 트리거
2. 변경된 파일의 diff 분석
3. AI 기반 리뷰 코멘트 자동 작성
4. PR 코멘트에서 `@coderabbitai`로 추가 질문 가능

### 비용

- 오픈소스(public) 프로젝트: **무료**
- Private 프로젝트: [요금제 확인](https://coderabbit.ai/pricing)

### 다른 레포에 적용

1. [CodeRabbit](https://github.com/apps/coderabbit)을 레포에 설치
2. 프로젝트 루트에 `.coderabbit.yaml` 생성
3. 설정 커스터마이즈 후 PR 생성하여 확인
