import '../../../../src_export.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStaticStrings.accountSettings),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.kTextColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppPadding.getPadding12(context),
        child: Column(
          spacing: 12,
          children: [
            ProfileMenuTile(
              isBackground: true,
              icon: ImagesConstant.kPasswordIcon,
              title: AppStaticStrings.changePassword,
              onTap: () => context.pushNamed(RoutesPath.changePasswordPath),
            ),
            ProfileMenuTile(
              isBackground: true,
              icon: ImagesConstant.kDeleteAccIcon,
              title: AppStaticStrings.deleteAccount,
              onTap: () {
                // Handle delete account
              },
            ),
          ],
        ),
      ),
    );
  }
}
