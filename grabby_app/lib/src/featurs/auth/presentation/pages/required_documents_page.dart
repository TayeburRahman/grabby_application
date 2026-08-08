import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../../../src_export.dart';

class RequiredDocumentsPage extends StatefulWidget {
  const RequiredDocumentsPage({super.key});

  @override
  State<RequiredDocumentsPage> createState() => _RequiredDocumentsPageState();
}

class _RequiredDocumentsPageState extends State<RequiredDocumentsPage> {
  File? _businessLicense;
  File? _shopLogo;

  Future<void> _pickFile(bool isLicense) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();

        if (fileSize > 5 * 1024 * 1024) {
          if (mounted) {
            CustomSnackbar.show(
              context,
              'File size must be less than 5MB',
              isError: true,
            );
          }
          return;
        }

        setState(() {
          if (isLicense) {
            _businessLicense = file;
          } else {
            _shopLogo = file;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(context, 'Failed to pick file', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SaveBusinessDocumentsSuccess) {
            CustomSnackbar.show(context, state.message, isError: false);
            context.goNamed(RoutesPath.loginPath);
          } else if (state is AuthFailure) {
            CustomSnackbar.show(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const CustomText(
                AppStaticStrings.requiredDocuments,
                variant: TextVariant.titleLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const OnboardingProgressBar(currentStep: 3),
                  Padding(
                    padding: AppPadding.getPadding12(context),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          AppStaticStrings.requiredDocuments,
                          variant: TextVariant.titleMedium,
                          fontWeight: FontWeight.bold,
                        ),
                        DocumentUploadCard(
                          title: AppStaticStrings.businessLicense,
                          subtitle: _businessLicense != null
                              ? _businessLicense!.path.split('/').last
                              : AppStaticStrings.pdfJpgPngMax5MB,
                          onUpload: () => _pickFile(true),
                        ),
                        DocumentUploadCard(
                          title: AppStaticStrings.shopLogo,
                          subtitle: _shopLogo != null
                              ? _shopLogo!.path.split('/').last
                              : AppStaticStrings.pdfJpgPngMax5MB,
                          onUpload: () => _pickFile(false),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: AppStaticStrings.continueText,
                          isLoading: state is AuthLoading,
                          onPressed:
                              (_businessLicense != null && _shopLogo != null)
                              ? () {
                                  context.read<AuthBloc>().add(
                                    SaveBusinessDocumentsEvent(
                                      businessLicense: _businessLicense!,
                                      shopLogo: _shopLogo!,
                                    ),
                                  );
                                }
                              : () {},
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
