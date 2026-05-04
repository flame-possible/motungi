import 'dart:math';

double seededRand(int seed, int n) {
  final x = (sin(seed * 9301.0 + n * 49297.0) * 233280.0);
  return x - x.floor();
}

// Alias for backward-compatible callers
double seededRandom(int seed, int n) => seededRand(seed, n);
