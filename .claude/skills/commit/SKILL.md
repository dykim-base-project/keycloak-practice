# Commit Skill

커밋 워크플로우 오케스트레이션

## 트리거

- "커밋", "commit"

## 워크플로우

1. 변경사항 수집 (git status, git diff)
2. 서브에이전트 호출:
   ```
   Task(subagent_type="general-purpose",
        model="sonnet",
        prompt="[reviewer.md 내용 + diff + 명세문서 경로]")
   ```
3. 리뷰 결과 정리
4. CLAUDE.md 커밋 컨벤션에 따라 커밋 메시지 제안
5. 사용자 확인 후 커밋

## 서브에이전트

- **reviewer** (.claude/agents/reviewer.md)
  - 컨텍스트 분리 실행
  - 결과만 반환

## 커밋 메시지 형식

CLAUDE.md 커밋 컨벤션 참조 (git log 불필요):
```
타입: 수정내용 요약

* 상세 내용 1
* 상세 내용 2
```

타입: init, feat, fix, docs, refactor, chore

## 체크리스트

- [ ] 명세 문서와 구현 일치
- [ ] 테스트 통과
- [ ] 컨벤션 준수
- [ ] 불필요한 변경 없음

## 규칙

- 커밋은 사용자 승인 후에만
- 리뷰 결과와 커밋 메시지 함께 제시
- git log 읽지 않음 (CLAUDE.md 컨벤션 사용)
