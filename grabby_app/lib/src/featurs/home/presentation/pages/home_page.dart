import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../../../src_export.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late final CustomerBranchBloc _branchBloc;

  @override
  void initState() {
    super.initState();
    _branchBloc = sl<CustomerBranchBloc>();
    _fetchBranches();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PromotedShopsSheet.show(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchBranches({String? query}) async {
    final position = await sl<LocationService>().getCurrentPosition();
    _branchBloc.add(
      GetCustomerBranchesEvent(
        query: query,
        lat: position?.latitude,
        lng: position?.longitude,
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchBranches(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider.value(value: _branchBloc),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          bool isMapView = false;
          if (state is HomeInitial) {
            isMapView = state.isMapView;
          } else if (state is ToggleViewState) {
            isMapView = state.isMapView;
          }
          return RefreshIndicator(
            onRefresh: () async {
              _fetchBranches();
            },
            child: CustomScrollView(
              physics: isMapView
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppPadding.getPadding12(context),
                    child: CustomTextField(
                      textEditingController: _searchController,
                      onChanged: _onSearchChanged,
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: AppColors.kSecondaryTextColor.withValues(
                          alpha: .5,
                        ),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.kSecondaryTextColor,
                      ),
                      hintText: AppStaticStrings.searchCafes,
                      borderColor: AppColors.kSecondaryTextColor.withValues(
                        alpha: .5,
                      ),
                      borderRadius: 22,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppPadding.getPadding12(context).copyWith(top: 0),
                    child: Row(
                      spacing: 8,
                      children: [
                        TabWidget(
                          img: ImagesConstant.kListIcon,
                          title: AppStaticStrings.listView,
                          isSelected: !isMapView,
                          onTap: () {
                            context.read<HomeBloc>().add(
                              ToggleThemeEvent(isMapView: false),
                            );
                          },
                        ),
                        TabWidget(
                          title: AppStaticStrings.mapView,
                          img: ImagesConstant.kMapIcon,
                          isSelected: isMapView,
                          onTap: () {
                            context.read<HomeBloc>().add(
                              ToggleThemeEvent(isMapView: true),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                isMapView ? const HomeMapView() : const HomeListView(),
              ],
            ),
          );
        },
      ),
    );
  }
}
