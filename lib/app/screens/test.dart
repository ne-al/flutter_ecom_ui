import 'package:flutter/material.dart';

class CustomScrollScreen extends StatefulWidget {
  const CustomScrollScreen({super.key});

  @override
  _CustomScrollScreenState createState() => _CustomScrollScreenState();
}

class _CustomScrollScreenState extends State<CustomScrollScreen> {
  bool isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            setState(() {
              isScrolled = scrollNotification.metrics.pixels > 50;
            });
            return true;
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 180.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      // Check if app bar is collapsed
                      bool collapsed =
                          constraints.biggest.height <= kToolbarHeight + 50;

                      return FlexibleSpaceBar(
                        titlePadding:
                            const EdgeInsets.only(left: 16, bottom: 16),
                        centerTitle: false,
                        title: collapsed
                            ? Row(
                                children: [
                                  // Logo on the left when collapsed
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.greenAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.discount,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    // Search bar on the right when collapsed
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search the entire shop',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                        background: Padding(
                          padding:
                              const EdgeInsets.only(top: kToolbarHeight + 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Delivery address',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '92 High Street, London',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Discount message or any other content
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        "Delivery is ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "50% cheaper",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(Icons.local_shipping,
                                          color: Colors.blue),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Show the search bar only in the expanded state
                if (!isScrolled)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SearchBarDelegate(),
                  ),
              ];
            },
            body: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                title: Text("Item $index"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60.0;
  @override
  double get maxExtent => 60.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search the entire shop',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

/**
 *
 * [] = List
 * {} = map
 */

