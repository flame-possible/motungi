class Flavor {
  final String name;
  final String desc;
  const Flavor({required this.name, required this.desc});
}

const flavors = <String, Flavor>{
  'recovery_quiet':       Flavor(name:'조용한 회복 산책',  desc:'소음 없는 골목, 천천히 숨 고르기'),
  'recovery_lively':      Flavor(name:'활기찬 회복 산책',  desc:'사람 사는 냄새, 가볍게 기운 충전'),
  'recovery_spontaneous': Flavor(name:'즉흥 회복 산책',    desc:'발 닿는 대로, 부담 없이'),
  'clearing_quiet':       Flavor(name:'조용한 환기 산책',  desc:'머릿속을 비우는 고요한 걸음'),
  'clearing_lively':      Flavor(name:'활기찬 환기 산책',  desc:'소란한 일상 속으로 뛰어들기'),
  'clearing_spontaneous': Flavor(name:'즉흥 환기 산책',    desc:'생각 없이 몸이 이끄는 대로'),
  'reflection_quiet':     Flavor(name:'조용한 사색 산책',  desc:'골목 끝에서 생각을 정리합니다'),
  'reflection_lively':    Flavor(name:'활기찬 사색 산책',  desc:'사람들 틈에서 나를 들여다보기'),
  'reflection_spontaneous':Flavor(name:'즉흥 사색 산책',   desc:'떠오르는 대로, 걷는 대로'),
  'exploration_quiet':    Flavor(name:'조용한 탐험 산책',  desc:'아무도 모르는 골목을 찾아서'),
  'exploration_lively':   Flavor(name:'활기찬 탐험 산책',  desc:'새로운 가게, 새로운 얼굴'),
  'exploration_spontaneous':Flavor(name:'즉흥 탐험 산책',  desc:'지도 없이, 본능대로'),
};
