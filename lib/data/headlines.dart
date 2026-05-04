class HeadlineParts {
  final String l1, a, l2;
  const HeadlineParts({required this.l1, required this.a, required this.l2});
}

const kHeadlinePools = <String, List<HeadlineParts>>{
  'again': [
    HeadlineParts(l1:"오늘 한 번 더,", a:"다른 모퉁이", l2:"어떠세요"),
    HeadlineParts(l1:"한 바퀴 더,", a:"가볍게", l2:"어떠세요"),
    HeadlineParts(l1:"오늘 두 번째,", a:"천천히", l2:"걸어볼까요"),
    HeadlineParts(l1:"또 한 번,", a:"잠깐만", l2:"나가볼까요"),
  ],
  'lateNight': [
    HeadlineParts(l1:"늦은 밤,", a:"고요한", l2:"모퉁이"),
    HeadlineParts(l1:"잠 안 오는 밤,", a:"한 바퀴", l2:"돌아볼까요"),
    HeadlineParts(l1:"이 시간엔,", a:"조용히", l2:"걸어볼까요"),
    HeadlineParts(l1:"늦은 밤,", a:"천천히", l2:"숨 고르기"),
  ],
  'morning': [
    HeadlineParts(l1:"오늘 아침,", a:"산뜻한", l2:"모퉁이"),
    HeadlineParts(l1:"하루의 시작,", a:"가볍게", l2:"걸어볼까요"),
    HeadlineParts(l1:"맑은 아침,", a:"천천히", l2:"한 바퀴"),
    HeadlineParts(l1:"이른 아침,", a:"조용한", l2:"발걸음"),
  ],
  'noon': [
    HeadlineParts(l1:"점심 사이,", a:"잠깐만", l2:"걸을까요"),
    HeadlineParts(l1:"한낮의 틈,", a:"가벼운", l2:"모퉁이"),
    HeadlineParts(l1:"점심 후,", a:"느긋한", l2:"산책"),
    HeadlineParts(l1:"점심 무렵,", a:"잠깐", l2:"비워볼까요"),
  ],
  'afternoon': [
    HeadlineParts(l1:"오후의", a:"느긋한", l2:"발걸음"),
    HeadlineParts(l1:"한가한 오후,", a:"천천히", l2:"걸어볼까요"),
    HeadlineParts(l1:"오후 햇살에,", a:"한 모퉁이", l2:"어떠세요"),
    HeadlineParts(l1:"오후의 틈,", a:"잠깐", l2:"걸을까요"),
  ],
  'goldenHour': [
    HeadlineParts(l1:"해 지기 전,", a:"한 모퉁이", l2:"돌아볼까요"),
    HeadlineParts(l1:"노을 무렵,", a:"천천히", l2:"걸어볼까요"),
    HeadlineParts(l1:"하늘이 물들 때,", a:"가만히", l2:"걷기"),
    HeadlineParts(l1:"저녁 빛에,", a:"잠깐", l2:"발 맡기기"),
  ],
  'evening': [
    HeadlineParts(l1:"오늘 저녁,", a:"가만히", l2:"걸어볼까요"),
    HeadlineParts(l1:"하루 끝에,", a:"가벼운", l2:"모퉁이"),
    HeadlineParts(l1:"저녁 공기,", a:"천천히", l2:"마시며"),
    HeadlineParts(l1:"퇴근 길에,", a:"한 바퀴", l2:"돌아볼까요"),
  ],
  'night': [
    HeadlineParts(l1:"늦은 밤,", a:"천천히", l2:"걸을까요"),
    HeadlineParts(l1:"고요한 밤,", a:"가만히", l2:"걸어볼까요"),
    HeadlineParts(l1:"잠 들기 전,", a:"잠깐", l2:"나가볼까요"),
    HeadlineParts(l1:"오늘 마무리,", a:"한 모퉁이", l2:"돌기"),
  ],
};

HeadlineParts getHeadline(bool hasWalkedToday) {
  final now = DateTime.now();
  final doy = now.difference(DateTime(now.year, 1, 1)).inDays;
  List<HeadlineParts> pick(String key) {
    final pool = kHeadlinePools[key]!;
    return [pool[doy % pool.length]];
  }
  if (hasWalkedToday) return pick('again').first;
  final h = now.hour;
  if (h < 6)  return pick('lateNight').first;
  if (h < 11) return pick('morning').first;
  if (h < 14) return pick('noon').first;
  if (h < 17) return pick('afternoon').first;
  if (h < 19) return pick('goldenHour').first;
  if (h < 22) return pick('evening').first;
  return pick('night').first;
}

const kNumKor = ['', '한', '두', '세', '네', '다섯'];
const kDayKor = ['일', '월', '화', '수', '목', '금', '토'];
