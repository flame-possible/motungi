class Quest {
  final int id;
  final String text;
  final String cat;    // 관찰|감각|경로|발견|사진
  final List<String> tags;
  final bool easy;
  const Quest({required this.id, required this.text, required this.cat, required this.tags, this.easy = true});
}

String catGlyph(String cat) {
  return {'관찰': '◉', '감각': '❋', '경로': '↣', '발견': '✦', '사진': '▣'}[cat] ?? '·';
}

const kQuests = [
  // 관찰
  Quest(id:1,  text:"파란 간판 셋을 찾아보세요",            cat:"관찰", tags:["관찰"],         easy:true),
  Quest(id:2,  text:"가장 오래돼 보이는 가게의 사진 한 장",  cat:"관찰", tags:["관찰","사진"],   easy:true),
  Quest(id:7,  text:"구십 년대 같은 장소를 찾아봅니다",      cat:"관찰", tags:["관찰"],         easy:false),
  Quest(id:12, text:"하늘색을 닮은 물건을 찾아보세요",       cat:"관찰", tags:["관찰"],         easy:true),
  Quest(id:21, text:"가장 오래된 건물을 찾아봅니다",         cat:"관찰", tags:["관찰"],         easy:false),
  Quest(id:25, text:"손글씨로 쓴 간판 둘을 찾아봅니다",      cat:"관찰", tags:["관찰"],         easy:true),
  Quest(id:26, text:"창문 너머 화분 다섯을 세어보세요",      cat:"관찰", tags:["관찰"],         easy:true),
  Quest(id:27, text:"같은 이름의 가게가 있는지 살펴봅니다",  cat:"관찰", tags:["관찰"],         easy:false),
  Quest(id:28, text:"숫자가 들어간 간판을 찾아보세요",       cat:"관찰", tags:["관찰"],         easy:true),
  Quest(id:29, text:"오늘 본 가장 진한 빨강을 기억해 둡니다",cat:"관찰", tags:["관찰"],         easy:true),
  Quest(id:30, text:"같은 색 우편함 둘을 찾아봅니다",        cat:"관찰", tags:["관찰"],         easy:true),
  // 감각
  Quest(id:4,  text:"벤치에 삼 분, 하늘을 봅니다",          cat:"감각", tags:["감각"],         easy:true),
  Quest(id:9,  text:"발밑 바닥 무늬 셋을 관찰합니다",        cat:"감각", tags:["감각"],         easy:true),
  Quest(id:11, text:"가장 조용한 골목을 골라 걷습니다",      cat:"감각", tags:["감각","경로"],   easy:true),
  Quest(id:13, text:"낯선 향기가 나는 곳에서 멈춰보기",      cat:"감각", tags:["감각"],         easy:true),
  Quest(id:17, text:"동네 나무 셋을 자세히 봅니다",          cat:"감각", tags:["감각"],         easy:true),
  Quest(id:19, text:"아무도 없는 골목에서 일 분 서 있기",    cat:"감각", tags:["감각"],         easy:true),
  Quest(id:22, text:"바람이 가장 잘 느껴지는 곳",            cat:"감각", tags:["감각"],         easy:true),
  Quest(id:31, text:"눈 감고 십 초, 들리는 소리를 헤어봅니다",cat:"감각", tags:["감각"],        easy:true),
  Quest(id:32, text:"가장 따뜻해 보이는 빛을 받으며 걷기",   cat:"감각", tags:["감각"],         easy:true),
  Quest(id:33, text:"바닥의 결을 손으로 한 번 만져보기",     cat:"감각", tags:["감각"],         easy:true),
  Quest(id:34, text:"공기가 바뀌는 지점을 찾아봅니다",       cat:"감각", tags:["감각"],         easy:false),
  Quest(id:35, text:"발걸음을 절반 속도로 늦춰 봅니다",      cat:"감각", tags:["감각"],         easy:true),
  Quest(id:36, text:"가장 시원한 그늘에서 한 호흡",          cat:"감각", tags:["감각"],         easy:true),
  // 경로
  Quest(id:3,  text:"오늘 처음 본 골목으로 들어가 봅니다",   cat:"경로", tags:["경로"],         easy:false),
  Quest(id:8,  text:"집까지 다른 길로 돌아옵니다",           cat:"경로", tags:["경로"],         easy:false),
  Quest(id:16, text:"한 번도 안 가본 골목을 걷습니다",       cat:"경로", tags:["경로"],         easy:false),
  Quest(id:23, text:"어제 걷지 않은 방향으로",               cat:"경로", tags:["경로"],         easy:false),
  Quest(id:37, text:"왼쪽으로만 세 번 꺾어봅니다",           cat:"경로", tags:["경로"],         easy:true),
  Quest(id:38, text:"가장 좁아 보이는 길을 골라 걷기",       cat:"경로", tags:["경로"],         easy:false),
  Quest(id:39, text:"오르막이 시작되면 끝까지 가봅니다",     cat:"경로", tags:["경로"],         easy:false),
  Quest(id:40, text:"평소 안 들르는 블록 한 바퀴",           cat:"경로", tags:["경로"],         easy:false),
  // 발견
  Quest(id:5,  text:"가장 이상한 가게 이름을 적어둡니다",    cat:"발견", tags:["발견"],         easy:true),
  Quest(id:6,  text:"메뉴판에서 처음 보는 단어를 만나기",    cat:"발견", tags:["발견"],         easy:false),
  Quest(id:14, text:"고양이나 강아지를 만나봅니다",          cat:"발견", tags:["발견"],         easy:true),
  Quest(id:24, text:"처음 보는 메뉴가 있는 식당",            cat:"발견", tags:["발견"],         easy:false),
  Quest(id:41, text:"이번에 처음 발견한 가게 한 곳",         cat:"발견", tags:["발견"],         easy:false),
  Quest(id:42, text:"오늘 영업 중인 작은 작업실 찾아보기",   cat:"발견", tags:["발견"],         easy:false),
  Quest(id:43, text:"문 앞에 의자 둔 가게를 찾아봅니다",     cat:"발견", tags:["발견"],         easy:true),
  Quest(id:44, text:"동네 게시판에서 한 줄을 읽어보기",      cat:"발견", tags:["발견"],         easy:true),
  Quest(id:45, text:"길 위의 작은 글귀 하나 적어두기",       cat:"발견", tags:["발견"],         easy:true),
  // 사진
  Quest(id:10, text:"오늘 본 가장 예쁜 것 한 장",            cat:"사진", tags:["사진"],         easy:true),
  Quest(id:15, text:"벽화 또는 그라피티 한 장",              cat:"사진", tags:["사진"],         easy:false),
  Quest(id:18, text:"이름이 귀여운 가게를 한 장",            cat:"사진", tags:["사진","발견"],   easy:true),
  Quest(id:20, text:"그림자가 재미있는 것 한 장",            cat:"사진", tags:["사진","관찰"],   easy:true),
  Quest(id:46, text:"가장 평범한 풍경 한 장 — 흐리지 않게",  cat:"사진", tags:["사진"],         easy:true),
  Quest(id:47, text:"같은 자리, 다른 두 시간을 찍어 보기",   cat:"사진", tags:["사진"],         easy:false),
  Quest(id:48, text:"발끝이 가장 좋아하는 바닥 한 장",       cat:"사진", tags:["사진","감각"],   easy:true),
  Quest(id:49, text:"하늘만 보이는 한 장",                   cat:"사진", tags:["사진"],         easy:true),
  Quest(id:50, text:"오늘의 색을 대표하는 한 장",            cat:"사진", tags:["사진"],         easy:true),
];

// Alias for backward-compatible callers
const quests = kQuests;
