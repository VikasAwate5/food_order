import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'feature/food_order/food_order_details_bloc.dart';
import 'feature/food_order/food_order_details_page.dart';

class WidgetFactory {
  WidgetFactory._();

  static WidgetFactory instance = WidgetFactory._();

  Widget getFoodOrderDetailsPage() {
    return Provider<FoodOrderDetailsBloc>(
      create: (context) => FoodOrderDetailsBlocImpl(),
      child: const FoodOrderDetailsPage(),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }
}
