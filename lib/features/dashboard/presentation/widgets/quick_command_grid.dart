import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/inventory_provider.dart';

/// Quick Command Grid - Manager actions
class QuickCommandGrid extends ConsumerWidget {
  const QuickCommandGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: CareSyncDesignSystem.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _CommandButton(
                    icon: Icons.shopping_cart,
                    label: 'Restock All',
                    color: CareSyncDesignSystem.primaryTeal,
                    onTap: () {
                      ref
                          .read(inventoryProvider.notifier)
                          .generateRestockList();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Restock list generated'),
                          backgroundColor: CareSyncDesignSystem.successEmerald,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _CommandButton(
                    icon: Icons.video_call,
                    label: 'Telehealth',
                    color: CareSyncDesignSystem.primaryTeal,
                    onTap: () {
                      // TODO: Launch telehealth provider
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Telehealth feature coming soon'),
                          backgroundColor: CareSyncDesignSystem.primaryTeal,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _CommandButton(
                    icon: Icons.broadcast_on_personal,
                    label: 'Broadcast',
                    color: CareSyncDesignSystem.softCoral,
                    onTap: () {
                      // TODO: Send broadcast message to caregivers
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Broadcast message sent'),
                          backgroundColor: CareSyncDesignSystem.primaryTeal,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 200.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, delay: 200.ms);
  }
}

class _CommandButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CommandButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      height: 100.h,
      onTap: onTap,
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withAlpha((0.7 * 255).round())],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha((0.3 * 255).round()),
                  blurRadius: 8.r,
                  spreadRadius: 1.r,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: CareSyncDesignSystem.surfaceWhite,
              size: 20.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: CareSyncDesignSystem.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
