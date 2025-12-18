import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/providers/ai_insight_provider.dart';
import '../../../../core/widgets/bento_card.dart';

class HelloHeader extends ConsumerWidget {
  final String userName;

  const HelloHeader({super.key, this.userName = 'Patient'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(aiInsightProvider);
    final activeInsight = insights.firstWhere(
      (insight) => !insight.isDismissed,
      orElse: () => AIInsight(id: '', message: '', type: ''),
    );

    final hasActiveInsight = activeInsight.id.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: CareSyncDesignSystem.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  userName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: CareSyncDesignSystem.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: CareSyncDesignSystem.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: CareSyncDesignSystem.primaryTeal.withAlpha(
                      (0.3 * 255).round(),
                    ),
                    blurRadius: 15.r,
                    spreadRadius: 2.r,
                  ),
                ],
              ),
              child: Icon(
                Icons.person,
                color: CareSyncDesignSystem.surfaceWhite,
                size: 24.sp,
              ),
            ),
          ],
        ),
        if (hasActiveInsight) ...[
          SizedBox(height: 16.h),
          _AIInsightPill(
            insight: activeInsight,
            onDismiss: () {
              ref
                  .read(aiInsightProvider.notifier)
                  .dismissInsight(activeInsight.id);
            },
          ),
        ],
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}

class _AIInsightPill extends StatelessWidget {
  final AIInsight insight;
  final VoidCallback onDismiss;

  const _AIInsightPill({required this.insight, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return BentoCard(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          backgroundColor: CareSyncDesignSystem.primaryTeal.withAlpha(
            (0.1 * 255).round(),
          ),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CareSyncDesignSystem.primaryTeal,
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 18.sp,
                  color: CareSyncDesignSystem.surfaceWhite,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  insight.message,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: CareSyncDesignSystem.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 18.sp,
                  color: CareSyncDesignSystem.textSecondary,
                ),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: -0.2, end: 0, duration: 300.ms);
  }
}
