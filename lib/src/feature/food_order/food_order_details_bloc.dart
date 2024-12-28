import 'package:food_order/src/common/months.dart';
import 'package:rxdart/rxdart.dart';

import '../../repository/food_order_details_repository.dart';
import '../../repository/model/food_order_details.dart';
import 'food_order_details_state.dart';

abstract class FoodOrderDetailsBloc {
  ValueStream<FoodOrderDetailsState> get stateStream;

  int calculateDailyFine(OptIns optIns);

  Future<void> fetchOrderDetails({int month});

  void dispose();
}

class FoodOrderDetailsBlocImpl extends FoodOrderDetailsBloc {
  FoodOrderDetailsBlocImpl() {
    init();
  }

  late final FoodOrderDetailsRepository foodOrderDetailsRepository;

  final BehaviorSubject<FoodOrderDetailsState> _state =
      BehaviorSubject<FoodOrderDetailsState>();

  Future<void> init() async {
    foodOrderDetailsRepository = FoodOrderDetailsRepositoryImpl();
    fetchOrderDetails();
  }

  @override
  ValueStream<FoodOrderDetailsState> get stateStream => _state.stream;

  int calculateMonthlyFine(List<Report> reports) {
    int totalFine = 0;
    for (final report in reports) {
      totalFine += calculateDailyFine(report.optIns);
    }
    return totalFine;
  }

  @override
  int calculateDailyFine(OptIns optIns) {
    int fine = 0;
    if (optIns.breakfast == OptInType.pending) fine += 100;
    if (optIns.lunch == OptInType.pending) fine += 100;
    if (optIns.dinner == OptInType.pending) fine += 100;
    return fine;
  }

  @override
  Future<void> fetchOrderDetails({int month = 1}) async {
    try {
      final foodOrderDetails =
          await foodOrderDetailsRepository.fetchOrderDetails(month: month);
      final monthlyFine = calculateMonthlyFine(foodOrderDetails.reports);

      final state = FoodOrderDetailsState(
        monthlyFine: monthlyFine,
        user: foodOrderDetails.user,
        orderDetails: foodOrderDetails.reports,
        selectedMonth: Months.values.firstWhere((e) => e.value == month).name,
      );
      _state.add(state);
    } catch (error) {
      _state.addError(error);
    }
  }

  @override
  void dispose() {
    _state.close();
  }
}
