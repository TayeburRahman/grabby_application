
import '../../../../src_export.dart';
import '../bloc/support_bloc.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SupportBloc>().add(GetTermsAndConditionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStaticStrings.termsAndConditions),
        centerTitle: true,
      ),
      body: BlocBuilder<SupportBloc, SupportState>(
        builder: (context, state) {
          if (state is SupportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SupportError) {
            return Center(child: CustomText(state.message));
          } else if (state is TermsAndConditionsLoaded) {
            if (state.data.isEmpty) {
              return const Center(child: CustomText("No terms and conditions found."));
            }
            // For simplicity, we assume there is at least one content entry
            final content = state.data.first.content;
            
            // Clean up basic HTML tags if necessary, or use a package like flutter_widget_from_html
            final cleanContent = content.replaceAll(RegExp(r'<[^>]*>'), '');

            return SingleChildScrollView(
              padding: AppPadding.getPadding16(context),
              child: CustomText(
                cleanContent,
                variant: TextVariant.bodyMedium,
                height: 1.5,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
