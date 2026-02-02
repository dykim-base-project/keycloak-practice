/**
 * CodeRabbit 테스트용 파일
 * PR 리뷰 동작 확인 후 삭제 예정
 */

// 의도적으로 리뷰 포인트를 포함한 코드
function processUserData(data: any) {
  // TODO: 타입 정의 필요
  console.log(data.password); // 보안 이슈: 패스워드 로깅

  if (data.name == null) {
    // == 대신 === 권장
    return null;
  }

  return {
    name: data.name,
    email: data.email,
  };
}

export { processUserData };
