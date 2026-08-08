import 'package:grabby_app/src/featurs/cart-checkout/data/models/car_plate_model.dart';

import '../../../../src_export.dart';

class CarPlatesPage extends StatefulWidget {
  const CarPlatesPage({super.key});

  @override
  State<CarPlatesPage> createState() => _CarPlatesPageState();
}

class _AddCardBottomSheetState {} // Ignore this, just fixing the class structure

class _CarPlatesPageState extends State<CarPlatesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CarPlateBloc>().add(GetCarPlatesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarPlateBloc, CarPlateState>(
      listener: (context, state) {
        if (state is CarPlateOperationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is CarPlateError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStaticStrings.carPlates)),
        body: BlocBuilder<CarPlateBloc, CarPlateState>(
          builder: (context, state) {
            if (state is CarPlateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CarPlatesLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CarPlateBloc>().add(GetCarPlatesEvent());
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // padding: AppPadding.getPadding12(context),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: AppPadding.getPadding12(context),
                        child: Column(
                          spacing: 12,
                          children: [
                            // Add New Plate Button
                            ButtonTapWidget(
                              onTap: () =>
                                  context.pushNamed(RoutesPath.addCarPlatePath),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F2FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFA59BF9,
                                    ).withValues(alpha: 0.5),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8,
                                  children: [
                                    Icon(Icons.add, color: Color(0xFFA59BF9)),
                                    CustomText(
                                      AppStaticStrings.addNewPlate,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFA59BF9),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if (state.carPlates.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 100),
                                  child: CustomText("No car plates added yet."),
                                ),
                              ),

                            // Plate List
                            ...state.carPlates.map(
                              (plate) => ButtonTapWidget(
                                onTap: () => context.pop(plate),
                                child: _buildPlateCard(context, plate: plate),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is CarPlateError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(state.message),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: "Retry",
                      onPressed: () =>
                          context.read<CarPlateBloc>().add(GetCarPlatesEvent()),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildPlateCard(BuildContext context, {required CarPlateModel plate}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              ImagesConstant.kCarIcon,
              height: 30,
              colorFilter: const ColorFilter.mode(
                Color(0xFFA59BF9),
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    CustomText(
                      plate.plateCode,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    /*
                    if (isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA59BF9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const CustomText(
                          AppStaticStrings.defaultText,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    */
                  ],
                ),
                CustomText(
                  plate.carNumberSource,
                  fontSize: 14,
                  color: Colors.grey,
                ),
                /*
                if (!isDefault)
                  const CustomText(
                    AppStaticStrings.setAsDefault,
                    fontSize: 14,
                    color: Color(0xFFA59BF9),
                  ),
                */
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                context.read<CarPlateBloc>().add(DeleteCarPlateEvent(plate.id)),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
          ),
        ],
      ),
    );
  }
}
