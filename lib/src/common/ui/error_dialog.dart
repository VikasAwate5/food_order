import 'package:flutter/material.dart';
import 'package:food_order/src/common/constant/color_constant.dart';
import 'package:food_order/src/widget_factory.dart';

import '../constant/dimens_constant.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: ColorConstant.redAccent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(DimensConstant.size16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error,
                size: DimensConstant.size100,
                color: ColorConstant.redAccent,
              ),
              const SizedBox(height: DimensConstant.size20),
              const Text(
                'An error occurred',
                style: TextStyle(
                  fontSize: DimensConstant.size24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DimensConstant.size20),
              const Text(
                'Something went wrong',
                style: TextStyle(fontSize: DimensConstant.size16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DimensConstant.size50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.redAccent,
                  minimumSize: const Size(
                    DimensConstant.size200,
                    DimensConstant.size40,
                  ),
                ),
                onPressed: () {
                  final widgetFactory = WidgetFactory.instance;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => widgetFactory.getFoodOrderDetailsPage(),
                    ),
                  );
                },
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: DimensConstant.size16,
                    color: ColorConstant.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
