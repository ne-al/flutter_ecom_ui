import 'dart:convert';

import 'package:ecom/app/components/loading/loading_animation.dart';
import 'package:ecom/app/widgets/product_tile.dart';
import 'package:ecom/core/api/product_api.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List laptopProduct;
  late List smartphoneProduct;
  late List mobileAccessoryProduct;

  List categories = [
    {
      "icon": Iconsax.camera5,
      "title": "Cameras",
    },
    {
      "icon": Iconsax.music_play5,
      "title": "Audio",
    },
    {
      "icon": Iconsax.mobile5,
      "title": "Phones",
    },
    {
      "icon": Iconsax.mirroring_screen,
      "title": "Displays",
    },
    {
      "icon": Iconsax.keyboard5,
      "title": "Accessories",
    }
  ];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    setState(() {
      isLoading = true;
    });

    laptopProduct = await ProductApi().getProductsByCategory("laptops");
    smartphoneProduct =
        await ProductApi().getProductsByCategory("mens-watches");
    mobileAccessoryProduct =
        await ProductApi().getProductsByCategory("mobile-accessories");

    setState(() {
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> getResponse(Uri url) async {
    List<Map<String, dynamic>> product = [];

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      product = List<Map<String, dynamic>>.from(data["products"]);
      product.shuffle();
    }

    return product;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  expandedHeight: constraints.maxHeight * 0.08,
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    centerTitle: false,
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    title: Row(
                      children: [
                        Center(
                          child: Icon(
                            Iconsax.menu_1,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 28,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerLow,
                              prefixIcon: const Icon(
                                Iconsax.search_normal_1,
                                size: 20,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              hintText: "Search for products",
                              hintStyle: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const Gap(12),
                        Stack(
                          children: [
                            Icon(
                              Iconsax.notification,
                              size: 28,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            const Positioned(
                              right: 1,
                              top: 0.5,
                              child: CircleAvatar(
                                radius: 3.5,
                                backgroundColor: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: !isLoading
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Categories",
                                  style: GoogleFonts.lato(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Iconsax.arrow_right_3,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(12),
                            SizedBox(
                              height: constraints.maxHeight * 0.1,
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Gap(12.5),
                                shrinkWrap: true,
                                itemCount: categories.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        child: Icon(categories[index]["icon"]),
                                      ),
                                      const Gap(6),
                                      Text(
                                        categories[index]["title"],
                                        style: GoogleFonts.lato(),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const Gap(20),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Get 10% off for orders above \u20B91,500",
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  Icon(
                                    Iconsax.receipt_15,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                            ProductTile(
                              categoryName: "Flash Sale",
                              productList: laptopProduct,
                            ),
                            ProductTile(
                              categoryName: "Accessories",
                              productList: mobileAccessoryProduct,
                            ),
                            ProductTile(
                              categoryName: "Men Watches",
                              productList: smartphoneProduct,
                            ),
                          ],
                        ),
                      ),
                    )
                  : loadingAnimation(),
            ),
          ),
        );
      },
    );
  }
}
