import 'package:flutter/material.dart';
import '../../../logic/route_engine.dart';
import '../../../theme/t.dart';
import '../../../theme/app_text_styles.dart';
import 'pen_illustration.dart';
import 'illustrated_map.dart';

class CourseCard extends StatelessWidget {
  final RouteResult route;
  final int duration;
  final String mood; // 고요 | 활기 | 즉흥

  const CourseCard({
    super.key,
    required this.route,
    required this.duration,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, t, _) {
        final isImprov = mood == '즉흥';

        return Container(
          decoration: BoxDecoration(
            color: t.paper2,
            border: Border.all(color: t.ruleSoft),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2D3A33).withValues(alpha: 0.22),
                blurRadius: 40,
                offset: const Offset(0, 18),
                spreadRadius: -24,
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Illustration area
              _IllustArea(
                illust: route.illust,
                mood: mood,
                isImprov: isImprov,
                t: t,
              ),
              // Text block
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isImprov ? '발길 닿는 모퉁이' : route.flavorName,
                      style: Ts.serif(26, FontWeight.w700, t.ink),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isImprov
                          ? '어느 모퉁이일지는 출발할 때 정합니다.'
                          : route.flavorDesc,
                      style: Ts.sans(14, FontWeight.w400, t.ink2,
                          height: 1.6),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${route.duration}분 · 약 ${route.distanceKm.toStringAsFixed(1)}km · 발견 ${route.quests.length} 가지',
                      style: Ts.sans(12, FontWeight.w400, t.ink3),
                    ),
                  ],
                ),
              ),
              // Map area
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: t.ruleSoft,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                child: isImprov
                    ? _ImprovMapPlaceholder(t: t)
                    : IllustratedMap(
                        duration: duration,
                        mood: mood,
                        height: 156,
                        withBorders: false,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IllustArea extends StatelessWidget {
  final String illust;
  final String mood;
  final bool isImprov;
  final AppThemeTokens t;

  const _IllustArea({
    required this.illust,
    required this.mood,
    required this.isImprov,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 178,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: t.paper3,
            child: PenIllustration(kind: illust, mood: mood),
          ),
          if (isImprov) ...[
            // Blur overlay
            Container(
              color: t.paper3.withValues(alpha: 0.55),
            ),
            // "?" overlay
            Center(
              child: Text(
                '?',
                style: Ts.serif(64, FontWeight.w700,
                    t.ink.withValues(alpha: 0.35)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ImprovMapPlaceholder extends StatelessWidget {
  final AppThemeTokens t;

  const _ImprovMapPlaceholder({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      color: t.paper3,
      child: Center(
        child: Text(
          '?',
          style: Ts.serif(64, FontWeight.w700,
              t.ink.withValues(alpha: 0.25)),
        ),
      ),
    );
  }
}
