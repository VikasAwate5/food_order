import 'package:flutter/material.dart';
import 'package:food_order/src/common/constant/color_constant.dart';
import 'package:food_order/src/common/constant/dimens_constant.dart';

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DimensConstant.size100,
      decoration: BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(DimensConstant.size10),
      ),
    );
  }
}
