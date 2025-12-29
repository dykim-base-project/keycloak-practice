# SSO 연동

Keycloak Identity Provider로 Google, GitHub 연동

## 플로우

```mermaid
sequenceDiagram
    actor User
    participant Browser
    participant Keycloak as Keycloak:8080
    participant IdP as Google/GitHub

    User->>Browser: 로그인 페이지 접속
    Browser->>Keycloak: GET /realms/practice/account
    Keycloak->>Browser: 로그인 페이지 (IdP 버튼)

    User->>Browser: Google/GitHub 클릭
    Browser->>Keycloak: GET /broker/{idp}/login
    Keycloak->>Browser: 302 → IdP 인증 URL

    Browser->>IdP: OAuth 인증 요청
    IdP->>Browser: 로그인 페이지
    User->>Browser: 자격증명 입력
    Browser->>IdP: 인증
    IdP->>Browser: 302 → callback?code=xxx

    Browser->>Keycloak: GET /broker/{idp}/endpoint?code=xxx
    Keycloak->>IdP: POST /token (code)
    IdP->>Keycloak: Access Token + User Info
    Keycloak->>Keycloak: 사용자 생성/매핑
    Keycloak->>Browser: 302 → 최종 리다이렉트
    Browser->>User: 로그인 완료
```

---

## Google 연동

### 1. Google Cloud Console 설정

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. 프로젝트 생성/선택
3. APIs & Services → Credentials
4. Create Credentials → OAuth client ID
5. Application type: `Web application`
6. Authorized redirect URIs:
   ```
   http://localhost:8080/realms/practice/broker/google/endpoint
   ```
7. Client ID, Client Secret 복사

### 2. Keycloak 설정

1. Realm: `practice` 선택
2. Identity Providers → Add provider → `Google`
3. 설정:

| 항목 | 값 |
|------|-----|
| Client ID | Google에서 복사한 값 |
| Client Secret | Google에서 복사한 값 |

4. Save

---

## GitHub 연동

### 1. GitHub OAuth App 설정

1. GitHub → Settings → Developer settings → OAuth Apps
2. New OAuth App
3. 설정:

| 항목 | 값 |
|------|-----|
| Application name | `keycloak-practice` |
| Homepage URL | `http://localhost:8080` |
| Authorization callback URL | `http://localhost:8080/realms/practice/broker/github/endpoint` |

4. Client ID, Client Secret 복사

### 2. Keycloak 설정

1. Identity Providers → Add provider → `GitHub`
2. 설정:

| 항목 | 값 |
|------|-----|
| Client ID | GitHub에서 복사한 값 |
| Client Secret | GitHub에서 복사한 값 |

3. Save

---

## 테스트

1. http://localhost:8080/realms/practice/account 접속
2. Google 또는 GitHub 로그인 버튼 확인
3. 로그인 후 사용자 자동 생성 확인
