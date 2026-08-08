import '../../../../src_export.dart';

class AddCarPlatePage extends StatefulWidget {
  const AddCarPlatePage({super.key});

  @override
  State<AddCarPlatePage> createState() => _AddCarPlatePageState();
}

class _AddCarPlatePageState extends State<AddCarPlatePage> {
  final TextEditingController _plateController = TextEditingController();
  String? selectedSource;

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  List<String> carNumberSource = [
    "Abu dhabi",
    "Dubai",
    "Sharjah",
    "Ajman",
    "Umm al quwain",
    "Ras al khaimah",
    "Fujairah",
  ];

  void _submit() {
    if (selectedSource == null || _plateController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final data = {
      "carNumberSource": selectedSource,
      "plateCode": _plateController.text,
    };

    context.read<CarPlateBloc>().add(AddCarPlateEvent(data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarPlateBloc, CarPlateState>(
      listener: (context, state) {
        if (state is CarPlateOperationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.pop();
        } else if (state is CarPlateError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStaticStrings.addNewPlate)),
        body: Padding(
          padding: AppPadding.getPadding12(context),
          child: Column(
            spacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  const CustomText(
                    AppStaticStrings.carNumberSource,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 8,
                      children: List.generate(
                        carNumberSource.length,
                        (index) {
                          final source = carNumberSource[index];
                          final isSelected = selectedSource == source;
                          return ButtonTapWidget(
                            onTap: () {
                              setState(() {
                                selectedSource = source;
                              });
                            },
                            child: Container(
                              padding: AppPadding.getPadding8(context),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFFF3F2FF)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? const Color(0xFFA59BF9)
                                          : Colors.grey.withValues(alpha: 0.3),
                                ),
                              ),
                              child: CustomText(
                                source,
                                color:
                                    isSelected
                                        ? const Color(0xFFA59BF9)
                                        : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const CustomText(
                    AppStaticStrings.enterPlateNumber,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  TextField(
                    controller: _plateController,
                    decoration: InputDecoration(
                      hintText: "e.g. ABC 1234",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              BlocBuilder<CarPlateBloc, CarPlateState>(
                builder: (context, state) {
                  return CustomButton(
                    text: AppStaticStrings.addNewPlate,
                    onPressed: () {
                      state is CarPlateLoading ? null : _submit();
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

