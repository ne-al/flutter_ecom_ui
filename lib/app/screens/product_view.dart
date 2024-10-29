import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom/app/components/buttons/add_to_cart.dart';
import 'package:ecom/app/components/loading/loading_animation.dart';
import 'package:ecom/core/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductView extends StatefulWidget {
  final int productId;

  const ProductView({
    super.key,
    required this.productId,
  });

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int pageIndex = 0;
  bool isLoading = false;
  Map productData = {};

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    setState(() {
      isLoading = true;
    });

    Uri url = Uri.parse('https://dummyjson.com/products/${widget.productId}');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      productData = json.decode(response.body);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Visibility(
            visible: !isLoading,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
                color: Theme.of(context).colorScheme.surfaceContainerLow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45,
                    child: AddToCartButton(
                      productId: widget.productId,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    "Delivered by ${DateTime.now().day + 2}th ${DateTime.now().month == 10 ? 'October' : 'November'}",
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: !isLoading
                ? NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        title: iconButton(
                          Iconsax.arrow_left_2,
                          () {
                            Navigator.pop(context);
                          },
                        ),
                        actions: [
                          ValueListenableBuilder(
                            valueListenable: Hive.box("FAVORITES").listenable(),
                            builder: (context, value, child) {
                              List products = value.get(
                                "products",
                                defaultValue: [],
                              );

                              bool isLiked =
                                  products.contains(widget.productId);
                              return iconButton(
                                isLiked ? Iconsax.heart5 : Iconsax.heart,
                                () async {
                                  await ProductService()
                                      .toggleFavorite(widget.productId);
                                },
                              );
                            },
                          ),
                          iconButton(
                            Icons.ios_share_rounded,
                            () {},
                          ),
                          const Gap(8),
                        ],
                        expandedHeight: constraints.maxHeight * 0.45,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: ProductCarouselView(
                            productData: productData,
                          ),
                        ),
                      ),
                    ],
                    body: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productData['title'],
                                maxLines: 2,
                                style: GoogleFonts.lato(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Iconsax.star1,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                            const Gap(4),
                                            Text(
                                              productData['rating'].toString(),
                                              style: GoogleFonts.lato(),
                                            ),
                                            const Text(" \u2022 "),
                                            Text(
                                              "6.74k Reviews",
                                              style: GoogleFonts.lato(),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const Gap(12),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Iconsax.like_15,
                                              color: Colors.green,
                                              size: 18,
                                            ),
                                            const Gap(6),
                                            Text(
                                              "93%",
                                              style: GoogleFonts.lato(),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const Gap(12),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Iconsax.message_question5,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            const Gap(6),
                                            Text(
                                              "2,127",
                                              style: GoogleFonts.lato(),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(18),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "\u20B9${productData['price']}/-",
                                      style: GoogleFonts.lato(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    const Gap(12),
                                    Text(
                                      "from \u20B9 179 per month",
                                      style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Iconsax.info_circle,
                                      size: 28,
                                      color: Colors.grey.shade400,
                                    ),
                                    const Gap(4),
                                  ],
                                ),
                              ),
                              const Gap(18),
                              Text(
                                productData['description'],
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Gap(18),
                              Text(
                                "Information",
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              const Gap(6),
                              Row(
                                children: [
                                  const Gap(10),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Brand: ${productData['brand']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Category: ${productData['category']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Serial No.: ${productData['sku']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Text(
                                        "Weight: ${productData['weight']} Kg",
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Text(
                                        "Stock: ${productData['availabilityStatus']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Text(
                                        "Return Policy: ${productData['returnPolicy']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Text(
                                        "Shipping: ${productData['shippingInformation']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Text(
                                        "Warranty: ${productData['warrantyInformation']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reviews",
                                    style: GoogleFonts.lato(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: productData['reviews'].length,
                                    itemBuilder: (context, index) {
                                      var data = productData['reviews'][index];
                                      return ListTile(
                                        leading: const CircleAvatar(
                                          child: Icon(Icons.person_2_rounded),
                                        ),
                                        title: Text(
                                          "${data["reviewerName"]} \u2022 ${timeago.format(DateTime.parse(data["date"]))}",
                                          style: GoogleFonts.lato(),
                                        ),
                                        subtitle: Text(
                                          data["comment"],
                                          style: GoogleFonts.lato(),
                                        ),
                                      );
                                    },
                                  ),
                                  const Gap(8),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Show more reviews",
                                        style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(40),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : loadingAnimation(),
          ),
        );
      },
    );
  }
}

Widget iconButton(IconData icon, Function() onPressed) {
  return Builder(
    builder: (context) {
      return IconButton.filled(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    },
  );
}

class ProductCarouselView extends StatefulWidget {
  final Map productData;
  const ProductCarouselView({
    super.key,
    required this.productData,
  });

  @override
  State<ProductCarouselView> createState() => _ProductCarouselViewState();
}

class _ProductCarouselViewState extends State<ProductCarouselView> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.productData['images'].length > 1
            ? CarouselSlider.builder(
                itemCount: widget.productData['images'].length,
                itemBuilder: (context, index, realIndex) => CachedNetworkImage(
                  imageUrl: widget.productData['images'][index],
                  fit: BoxFit.contain,
                  height: double.infinity,
                ),
                options: CarouselOptions(
                  animateToClosest: true,
                  disableCenter: true,
                  pageSnapping: true,
                  autoPlay: false,
                  initialPage: 0,
                  aspectRatio: 4 / 3,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                ),
              )
            : Expanded(
                child: CachedNetworkImage(
                  imageUrl: widget.productData['images'][0],
                  fit: BoxFit.contain,
                ),
              ),
        widget.productData['images'].length > 1
            ? Padding(
                padding: const EdgeInsets.only(top: 20),
                child: AnimatedSmoothIndicator(
                  activeIndex: pageIndex,
                  count: widget.productData['images'].length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.white.withOpacity(0.5),
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
