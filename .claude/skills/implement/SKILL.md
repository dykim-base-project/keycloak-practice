# Implement Skill

구현 워크플로우 오케스트레이션

## 트리거

- "구현", "implement", "build"

## 전제조건

- 설계 문서 존재
- 사용자 승인 완료

## 워크플로우

1. 설계 문서 확인
2. 구현 범위 확정
3. 서브에이전트 호출:
   ```
   Task(subagent_type="general-purpose",
        model="sonnet",
        prompt="[implementer.md 내용 + 설계문서 + 작업 지시]")
   ```
4. 결과 검토
5. 문서-코드 동기화 검증

## 서브에이전트

- **implementer** (.claude/agents/implementer.md)
  - 컨텍스트 분리 실행
  - 결과만 반환

## 규칙

- 설계 문서 기준으로 구현
- 구현 중 설계 변경 필요 시 문서 먼저 수정
- 커밋/푸시는 사용자 요청 시에만
