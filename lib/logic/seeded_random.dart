import 'dart:math';

double seededRandom(int seed, int n) {
  final x = sin(seed * 9301 + n * 49297) * 233280;
  return x - x.floor();
}
