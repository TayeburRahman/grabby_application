import '../../../../src_export.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final UserRole role;

  const RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<OnboardingSplashBloc>().add(RoleSelected(role));
      },
      child: Container(
        padding: AppPadding.getPadding12(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          spacing: 12,
          children: [
            SvgPicture.asset(icon),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    variant: TextVariant.headlineSmall,
                    color: Colors.black,
                  ),
                  CustomText(
                    subtitle,
                    variant: TextVariant.labelSmall,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
