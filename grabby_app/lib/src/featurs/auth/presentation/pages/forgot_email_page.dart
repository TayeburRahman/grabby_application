import '../../../../src_export.dart';

class ForgotEmailPage extends StatelessWidget {
  const ForgotEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStaticStrings.forgetEmail)),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.getPadding12(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(AppStaticStrings.enterYourEmail, variant: TextVariant.titleSmall),
              space12H,
              CustomTextField(
                title: AppStaticStrings.email,
                hintText: AppStaticStrings.enterYourEmailHint,
              ),
              space12H,
              CustomButton(
                text: AppStaticStrings.sendCode,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
