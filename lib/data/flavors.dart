class Flavor {
  final String name;
  final String desc;
  const Flavor({required this.name, required this.desc});
}

const kFlavors = <String, List<Flavor>>{
  "회복_고요": [
    Flavor(name:"조용한 골목길",     desc:"사람 적은 동네 안쪽, 발걸음만 들리는 길로"),
    Flavor(name:"천변 한 바퀴",      desc:"물길 옆 잔잔한 풍경을 따라 한 바퀴"),
    Flavor(name:"공원 한 바퀴",      desc:"가까운 공원을 끼고 천천히 돌아오기"),
    Flavor(name:"깊은 골목 안쪽",    desc:"인적 없는 안쪽 골목, 잠잠한 길로"),
  ],
  "회복_활기": [
    Flavor(name:"볕 좋은 큰길",      desc:"햇볕 잘 드는 길에서 따뜻한 풍경 안기"),
    Flavor(name:"카페 거리 한 바퀴", desc:"북적이는 거리 곁, 사람 사이의 위안"),
    Flavor(name:"광장 가장자리",     desc:"트인 광장을 끼고 공기 마시며 걷기"),
    Flavor(name:"노을 산책",         desc:"노을 비치는 거리에서 빛에 몸 맡기기"),
  ],
  "회복_즉흥": [
    Flavor(name:"발길 닿는 대로",    desc:"마음 가는 방향, 돌아올 길만 챙기고"),
    Flavor(name:"바람 따라",         desc:"불어오는 쪽으로 가볍게 한 바퀴"),
    Flavor(name:"신호등에 맡기고",   desc:"잠깐 길을 놓아두고, 가는 데까지"),
    Flavor(name:"빈 페이지처럼",     desc:"계획 없이, 노트 한 장 비워두듯"),
  ],
  "환기_고요": [
    Flavor(name:"한적한 길",         desc:"차도 곁 이면도로에서 머리 식히기"),
    Flavor(name:"새벽 같은 길",      desc:"인적 드문 길, 정적 속을 한 바퀴"),
    Flavor(name:"쉬는 골목",         desc:"잠깐 비어 있는 골목, 가만한 호흡으로"),
    Flavor(name:"비어 있는 공원",    desc:"한산한 공원 안에서 깊게 한 호흡"),
  ],
  "환기_활기": [
    Flavor(name:"시장 한 바퀴",      desc:"오가는 사람과 풍경에 답답함 풀기"),
    Flavor(name:"사거리 풍경",       desc:"사람 많은 사거리, 흐름에 떠밀려 가기"),
    Flavor(name:"광장 끝자락",       desc:"분주한 광장 끝에서 기분 풀기"),
    Flavor(name:"분주한 카페 거리",  desc:"카페 줄지은 거리에서 공기 흐름 따라"),
  ],
  "환기_즉흥": [
    Flavor(name:"신호등 따라",       desc:"신호가 바뀌는 대로, 가벼운 즉흥"),
    Flavor(name:"느려졌다 빨라졌다", desc:"속도 정하지 않고, 그때그때 다르게"),
    Flavor(name:"한 호흡씩 멈추며",  desc:"멈추는 곳마다 한 호흡씩 두고"),
    Flavor(name:"기분 풀리는 쪽으로",desc:"기분이 풀리는 방향, 그때그때 정하며"),
  ],
  "사색_고요": [
    Flavor(name:"물길 따라 천천히",  desc:"흐르는 물 옆에서 생각도 흐르도록"),
    Flavor(name:"다리 위에서",       desc:"다리 한가운데, 흘러가는 물을 보며"),
    Flavor(name:"호숫가 한 바퀴",    desc:"잔잔한 수면 옆을 한 바퀴 돌고"),
    Flavor(name:"공원 가장 안쪽",    desc:"공원 가장 안쪽, 가장 조용한 길로"),
  ],
  "사색_활기": [
    Flavor(name:"골목 카페 옆",      desc:"카페 골목 사이로, 풍경에 생각 얹기"),
    Flavor(name:"책방 동네 한 바퀴", desc:"책방 줄지은 골목, 머리 채우며"),
    Flavor(name:"미술관 골목",       desc:"미술관 둘레 골목에서 전시 떠올리며"),
    Flavor(name:"오래된 학교 담장",  desc:"학교 담장을 따라, 옛 기억과 함께"),
  ],
  "사색_즉흥": [
    Flavor(name:"정처 없이",         desc:"어디로 갈지 정하지 않고, 생각만 따라가며"),
    Flavor(name:"길에 맡기고",       desc:"길이 정해주는 대로, 생각이 따라옴"),
    Flavor(name:"갈래마다 한 생각",  desc:"여러 갈래에서 한 줄기씩 떠올리기"),
    Flavor(name:"멈추고 싶은 곳",    desc:"멈추고 싶은 자리에서 그대로 잠시"),
  ],
  "탐험_고요": [
    Flavor(name:"처음 보는 이면도로",desc:"한 번도 안 가본 골목을 천천히"),
    Flavor(name:"시간이 멈춘 골목",  desc:"오래된 동네 한 바퀴, 결을 따라"),
    Flavor(name:"낯선 동네 천천히",  desc:"낯선 길을 서두르지 않고 한 바퀴"),
    Flavor(name:"막다른 길 끝까지",  desc:"막다른 골목 끝까지 갔다 돌아오기"),
  ],
  "탐험_활기": [
    Flavor(name:"분주한 새 동네",    desc:"사람 많은 새 동네 한 바퀴 깊이"),
    Flavor(name:"처음 가는 큰길",    desc:"처음 가는 길로 깊숙이 들어가 보기"),
    Flavor(name:"시장 안쪽까지",     desc:"시장 골목 안쪽, 메뉴 다 읽으며"),
    Flavor(name:"새 카페 줄지은 길", desc:"새로 생긴 카페 거리, 간판 살피며"),
  ],
  "탐험_즉흥": [
    Flavor(name:"신호등이 정한 길",  desc:"신호로 방향 정하고, 끝까지 미지로"),
    Flavor(name:"끝까지 미지로",     desc:"돌아올 길도 신호등에 맡기고"),
    Flavor(name:"발 가는 방향",      desc:"발 닿는 쪽으로 그저 따라가기"),
    Flavor(name:"우연이 주는 길",    desc:"우연이 정해주는 길을 신뢰하며"),
  ],
};

// 의도별 일러스트 매핑
const kIllustByPurp = <String, String>{
  '회복': 'healing',
  '환기': 'breeze',
  '사색': 'reflection',
  '탐험': 'explore',
};

// Backward-compatible alias used by existing callers and tests.
// Maps English purpose_mood keys to the first Flavor in the Korean list.
final flavors = <String, Flavor>{
  'recovery_quiet':        kFlavors['회복_고요']![0],
  'recovery_lively':       kFlavors['회복_활기']![0],
  'recovery_spontaneous':  kFlavors['회복_즉흥']![0],
  'clearing_quiet':        kFlavors['환기_고요']![0],
  'clearing_lively':       kFlavors['환기_활기']![0],
  'clearing_spontaneous':  kFlavors['환기_즉흥']![0],
  'reflection_quiet':      kFlavors['사색_고요']![0],
  'reflection_lively':     kFlavors['사색_활기']![0],
  'reflection_spontaneous':kFlavors['사색_즉흥']![0],
  'exploration_quiet':     kFlavors['탐험_고요']![0],
  'exploration_lively':    kFlavors['탐험_활기']![0],
  'exploration_spontaneous':kFlavors['탐험_즉흥']![0],
};
