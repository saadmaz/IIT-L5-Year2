// // File: frontend/lib/features/ehpr/widgets/dashboard_stats.dart

// import 'package:flutter/material.dart';
// import '../../../config/constants.dart';

// class DashboardStats extends StatelessWidget {
//   const DashboardStats({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: AppDimensions.paddingMedium,
//       mainAxisSpacing: AppDimensions.paddingMedium,
//       childAspectRatio: 1.5,
//       children: [
//         _buildStatCard(
//           context,
//           icon: Icons.folder,
//           value: '128',
//           label: 'Total Records',
//           color: AppColors.midnightTeal,
//         ),
//         _buildStatCard(
//           context,
//           icon: Icons.people,
//           value: '42',
//           label: 'Active Patients',
//           color: Colors.blue,
//         ),
//         _buildStatCard(
//           context,
//           icon: Icons.assignment_turned_in,
//           value: '24',
//           label: 'Assessments',
//           color: Colors.orange,
//         ),
//         _buildStatCard(
//           context,
//           icon: Icons.healing,
//           value: '18',
//           label: 'Treatment Plans',
//           color: Colors.green,
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//     BuildContext context, {
//     required IconData icon,
//     required String value,
//     required String label,
//     required Color color,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(AppDimensions.paddingMedium),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Icon(
//                   icon,
//                   size: 24,
//                   color: color,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../config/constants.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppDimensions.paddingMedium,
      mainAxisSpacing: AppDimensions.paddingMedium,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          icon: Icons.folder,
          value: '128',
          label: 'Total Records',
          color: AppColors.midnightTeal,
        ),
        _buildStatCard(
          context,
          icon: Icons.people,
          value: '42',
          label: 'Active Patients',
          color: Colors.blue,
        ),
        _buildStatCard(
          context,
          icon: Icons.assignment_turned_in,
          value: '24',
          label: 'Assessments',
          color: Colors.orange,
        ),
        _buildStatCard(
          context,
          icon: Icons.healing,
          value: '18',
          label: 'Treatment Plans',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
