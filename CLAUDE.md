# CLAUDE.md

Keycloak Practice 프로젝트 AI 협업 가이드

## 프로젝트 개요

Keycloak SSO 및 OAuth2 연동 실습. Spring Boot 3 + Spring Security 6 + Java 17+ LTS.

## 작업 방식: MDD

```
문서 작성 → 리뷰 → 구현 → 검증
```

코드 작성 전 Markdown으로 설계 문서 먼저 작성.

## 가이드 준수 원칙

1. **문서-가이드 동기화**: 문서 또는 가이드 수정 시 상호 일치 유지
2. **멱등성 검증**: 작업 완료 후 가이드 기준으로 검증
   - 다이어그램 규칙 준수 여부
   - 커밋 컨벤션 준수 여부
   - 디렉토리 구조 일치 여부

## 다이어그램

| 용도 | 도구 |
|------|------|
| 플로우, 시퀀스, 구조도 | Mermaid (README에 임베딩) |
| 클래스, ERD 등 상세 | PlantUML + SVG 이미지 |

**PlantUML 사용 시**: 동일 이름의 `.svg` 파일 필수 생성
```
example.puml → example.svg (plantuml -tsvg)
```

## 커밋 컨벤션

`타입: 설명` 형식 (한글 작성, 불가 시 영어)

| 타입 | 용도 |
|------|------|
| init | 초기 설정 |
| feat | 새 기능 |
| fix | 버그 수정 |
| docs | 문서 |
| refactor | 리팩토링 |
| chore | 기타 |

예시: `docs: CLAUDE.md 가이드 준수 원칙 추가`

**커밋/푸시**: 개발자 요청 시에만 진행 (작업 내용은 로컬 수정사항으로 확인)

## 디렉토리 구조

- `keycloak/` - Keycloak 서버 설정
- `sso/` - Google, GitHub SSO 연동
- `backend/` - Spring Boot 연동 (구현 예정)

## 명령어

```bash
docker-compose up -d      # Keycloak 실행
docker-compose down -v    # 종료 및 볼륨 삭제
```
