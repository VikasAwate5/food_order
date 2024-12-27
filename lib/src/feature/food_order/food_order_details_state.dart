import '../../repository/model/food_order_details.dart';

class FoodOrderDetailsState {
  final User user;
  final int monthlyFine;
  final String selectedMonth;
  final List<Report> orderDetails;

  FoodOrderDetailsState({
    required this.user,
    required this.monthlyFine,
    required this.orderDetails,
    required this.selectedMonth,
  });

  FoodOrderDetailsState copyWith({
    List<Report>? orderDetails,
    String? selectedMonth,
    int? monthlyFine,
    User? user,
  }) {
    return FoodOrderDetailsState(
      user: user ?? this.user,
      monthlyFine: monthlyFine ?? this.monthlyFine,
      orderDetails: orderDetails ?? this.orderDetails,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }

  @override
  String toString() {
    return 'FoodOrderDetailsState{user: $user, monthlyFine: $monthlyFine, selectedMonth: $selectedMonth, orderDetails: $orderDetails}';
  }
}
