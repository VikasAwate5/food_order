import 'package:rxdart/rxdart.dart';

import '../../repository/food_order_details_repository.dart';
import '../../repository/model/food_order_details.dart';
import 'food_order_details_state.dart';

abstract class FoodOrderDetailsBloc {
  ValueStream<FoodOrderDetailsState> get stateStream;

  int calculateDailyFine(OptIns optIns);

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
      if (report.optIns.breakfast == OptInType.pending) {
        totalFine += 100;
      }
      if (report.optIns.lunch == OptInType.pending) {
        totalFine += 100;
      }
      if (report.optIns.dinner == OptInType.pending) {
        totalFine += 100;
      }
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

  Future<void> fetchOrderDetails() async {
    try {
      final foodOrderDetails =
          await foodOrderDetailsRepository.fetchOrderDetails();
      final monthlyFine = calculateMonthlyFine(foodOrderDetails.reports);

      final state = FoodOrderDetailsState(
        monthlyFine: monthlyFine,
        user: foodOrderDetails.user,
        orderDetails: foodOrderDetails.reports,
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
