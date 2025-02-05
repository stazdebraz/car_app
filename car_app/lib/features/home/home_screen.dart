import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_app/core/enum/car_filters.dart';
import 'package:car_app/core/extensions/context_extension.dart';
import 'package:car_app/core/extensions/int_extension.dart';
import 'package:car_app/core/resource/app_svg.dart';
import 'package:car_app/features/cart/cart_provider.dart';
import 'package:car_app/features/cart/cart_screen.dart';
import 'package:car_app/features/home/provider/cars_provider.dart';
import 'package:car_app/features/home/widgets/ad_widget.dart';
import 'package:car_app/features/home/widgets/car_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _activeCategory = ValueNotifier<CarFilters?>(null);

  @override
  void dispose() {
    _activeCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerW = context.watch<CarsProvider>();
    return Scaffold(
      drawer: Container(
        color: Colors.white,
        child: const Column(
          children: [Text('DRAWER')],
        ),
      ),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: SvgPicture.asset(AppSvg.drawerIcon));
        }),
        actions: [
          IconButton(
              onPressed: () {
                context.push(
                  const CartScreen(),
                );
              },
              icon: const Icon(
                Icons.add_shopping_cart,
                size: 30,
              ))
        ],
      ),
      body: Padding(
        padding: 15.symmetricHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AdWidget(),
            50.verticalSpace,
            SizedBox(
              height: 60,
              child: ListView.separated(
                itemCount: CarFilters.values.length,
                separatorBuilder: (context, index) => 20.horizontalSpace,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                      valueListenable: _activeCategory,
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () => _onItemTap(
                            type: CarFilters.values[index],
                          ),
                          child: CarChipWidget(
                            label: CarFilters.values[index].category,
                            isActive: CarFilters.values[index] == value,
                          ),
                        );
                      });
                },
              ),
            ),
            50.verticalSpace,
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 40.0,
                      crossAxisSpacing: 35.0,
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: providerW.currentList[index].type.getColor
                                .withOpacity(0.4),
                            borderRadius: 20.borderRadius,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        const SizedBox.shrink(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    imageUrl:
                                        providerW.currentList[index].image),
                              ),
                              Row(
                                children: [
                                  15.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                        '${providerW.currentList[index].brand} ${providerW.currentList[index].model}'),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<CartProvider>()
                                          .addItemToCart(
                                            providerW.currentList[index],
                                          );
                                    },
                                    icon: const Icon(Icons.add_shopping_cart),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      childCount: providerW.currentList.length,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onItemTap({required CarFilters type}) {
    final providerR = context.read<CarsProvider>();
    _activeCategory.value = type;
    switch (type) {
      case CarFilters.allCars:
        providerR.showAllCars();
      case CarFilters.popularCars:
        providerR.showPopularCars();
      case CarFilters.familyCars:
        providerR.showFamilyCars();
      case CarFilters.cheapCars:
        providerR.showCheapCars();
      case CarFilters.luxuryCars:
        providerR.showLuxuryCars();
      case CarFilters.sportCars:
        providerR.showSportCars();

      default:
    }
  }
}
