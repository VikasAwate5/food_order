import '../../repository/model/food_order_details.dart';

class FoodOrderDetailsState {
  final User user;
  final int monthlyFine;
  final List<Report> orderDetails;

  FoodOrderDetailsState({
    required this.user,
    required this.monthlyFine,
    required this.orderDetails,
  });

  FoodOrderDetailsState copyWith({
    List<Report>? orderDetails,
    int? monthlyFine,
    User? user,
  }) {
    return FoodOrderDetailsState(
      user: user ?? this.user,
      monthlyFine: monthlyFine ?? this.monthlyFine,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }

  @override
  String toString() {
    return 'FoodOrderDetailsState{user: $user, monthlyFine: $monthlyFine, orderDetails: $orderDetails}';
  }
}
