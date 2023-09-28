import 'package:flutter/material.dart';

class GridShimmerFirstPage extends StatelessWidget {
  final SliverGridDelegate gridDelegate;
  final Widget item;
  final int itemCount;
  final ScrollPhysics? physics;

  const GridShimmerFirstPage({
    Key? key,
    required this.gridDelegate,
    required this.item,
    required this.itemCount,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: physics,
      gridDelegate: gridDelegate,
      children: List.generate(itemCount, (index) => item),
    );
  }
}
