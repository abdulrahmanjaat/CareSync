import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/household_provider.dart';
import '../../../../core/providers/inventory_provider.dart';

/// Global Status Ticker - Shows household summary at the top
class GlobalStatusTicker extends ConsumerWidget {
  const GlobalStatusTicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final household = ref.watch(householdProvider);
    final inventory = ref.watch(inventoryProvider);

    final statusText = household.statusSummary;
    final hasAlerts =
        inventory.criticalAlerts.isNotEmpty ||
        inventory.lowStockAlerts.isNotEmpty;

    return BentoCard(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          backgroundColor: hasAlerts
              ? CareSyncDesignSystem.alertRed.withAlpha((0.1 * 255).round())
              : CareSyncDesignSystem.successEmerald.withAlpha(
                  (0.1 * 255).round(),
                ),
          child: Row(
            children: [
              // Status Icon
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasAlerts
                      ? CareSyncDesignSystem.alertRed
                      : CareSyncDesignSystem.successEmerald,
                ),
                child: Icon(
                  hasAlerts ? Icons.warning : Icons.check_circle,
                  color: CareSyncDesignSystem.surfaceWhite,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              // Status Text
              Expanded(
                child: Text(
                  statusText,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: hasAlerts
                        ? CareSyncDesignSystem.alertRed
                        : CareSyncDesignSystem.successEmerald,
                  ),
                ),
              ),
              // Alert Count Badge
              if (inventory.criticalAlerts.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: CareSyncDesignSystem.alertRed,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${inventory.criticalAlerts.length}',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: CareSyncDesignSystem.surfaceWhite,
                    ),
                  ),
                ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: -0.1, end: 0, duration: 300.ms);
  }
}
