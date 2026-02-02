# Spec Skill

명세 워크플로우 오케스트레이션

## 트리거

- "스펙", "spec", "명세"

## 워크플로우

1. 요구사항 파악 (사용자에게 질문)
2. 서브에이전트 호출:
   ```
   Task(subagent_type="general-purpose",
        model="sonnet",
        prompt="[designer.md 내용 + 작업 지시]")
   ```
3. 결과 검토 및 사용자 확인
4. 승인 시 문서 저장

## 서브에이전트

- **designer** (.claude/agents/designer.md)
  - 컨텍스트 분리 실행
  - 결과만 반환

## 규칙

- 코드 작성 전 명세 먼저
- 사용자 승인 후 다음 단계 진행
- 명세 결과는 `docs/` 또는 해당 모듈에 저장
