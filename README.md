# Keycloak Practice

Keycloak SSO 및 OAuth2 연동 실습

## 목표

| 단계 | 내용 | 문서 |
|------|------|------|
| 1 | Keycloak 실행 | [keycloak/](./keycloak/) |
| 2 | Google SSO 연동 | [sso/](./sso/) |
| 3 | GitHub SSO 연동 | [sso/](./sso/) |
| 4 | BE 서버 OAuth2 연동 | [backend/](./backend/) |

## 기술 스택

| 구분 | 기술 | 버전 |
|------|------|------|
| Identity Provider | Keycloak | latest |
| Backend | Spring Boot | 3.x |
| Security | Spring Security | 6.x |
| Language | Java | 17+ (LTS) |

## 프로젝트 구조

```
keycloak-practice/
├── README.md
├── docker-compose.yml
├── keycloak/              # Keycloak 서버 설정
│   ├── README.md
│   └── overview.puml
├── sso/                   # SSO 연동 (Google, GitHub)
│   ├── README.md
│   └── flow.puml
└── backend/               # Spring Boot 연동
    ├── README.md
    ├── oauth2-flow.puml
    └── src/
```

## 빠른 시작

```bash
# Keycloak 실행
docker-compose up -d

# 관리자 콘솔
open http://localhost:8080/admin  # admin / admin
```

## 작업 방식

**MDD (Markdown Driven Development)**

- 문서: Markdown
- 다이어그램: PlantUML
- 순서: 문서 → 구현 → 검증

## 참고

- [Keycloak Docs](https://www.keycloak.org/documentation)
- [Spring Security OAuth2](https://docs.spring.io/spring-security/reference/servlet/oauth2/index.html)
