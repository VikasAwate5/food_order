import 'package:flutter/material.dart';
import 'package:food_order/src/feature/food_order/food_order_details_bloc.dart';
import 'package:food_order/src/feature/food_order/food_order_details_state.dart';
import 'package:provider/provider.dart';

import '../../common/ui/custom_shimmer.dart';
import '../../common/ui/error_dialog.dart';
import '../../common/ui/shimmer_placeholder.dart';
import '../../common/utils.dart';
import '../../repository/model/food_order_details.dart';
import '../user_details/user_details_page.dart';
import 'months.dart';

class FoodOrderDetailsPage extends StatefulWidget {
  const FoodOrderDetailsPage({super.key});

  @override
  State<FoodOrderDetailsPage> createState() => _FoodOrderDetailsPageState();
}

class _FoodOrderDetailsPageState extends State<FoodOrderDetailsPage> {
  late final FoodOrderDetailsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<FoodOrderDetailsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Order Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMonthDropdown(),
            const SizedBox(height: 10.0),
            Expanded(
              child: StreamBuilder<FoodOrderDetailsState>(
                stream: bloc.stateStream.distinct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildShimmerEffect();
                  }
                  if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showErrorDialog();
                    });
                    return const SizedBox.shrink();
                  }

                  final state = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildUserInfo(state.user),
                      const SizedBox(height: 10.0),
                      const Divider(
                        thickness: 2.0,
                        color: Colors.grey,
                      ),
                      Expanded(child: buildOrderDetails(state.orderDetails)),
                      const SizedBox(height: 10.0),
                      Center(
                        child: Text(
                          'Monthly Total Fine: Rs ${state.monthlyFine}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderDetails(List<Report> reports) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final day = reports[index];
        final dailyFine = bloc.calculateDailyFine(day.optIns);

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getFormattedDate(day.date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                buildMealInfo('Breakfast', day.optIns.breakfast?.value),
                buildMealInfo('Lunch', day.optIns.lunch?.value),
                buildMealInfo('Dinner', day.optIns.dinner?.value),
                const SizedBox(height: 5.0),
                Text(
                  'Daily Fine: Rs $dailyFine',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMonthDropdown() {
    return StreamBuilder<String>(
      stream: bloc.stateStream.map((state) => state.selectedMonth).distinct(),
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Select Month: ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                value: snapshot.data ?? Months.january.name,
                items: buildDropdownItems(),
                onChanged: (newValue) {
                  bloc.fetchOrderDetails(
                    month: Months.values
                        .firstWhere((element) => element.name == newValue)
                        .value,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<String>> buildDropdownItems() {
    return Months.getMonthsNames()
        .map((month) => DropdownMenuItem(value: month, child: Text(month)))
        .toList();
  }

  Widget buildMealInfo(String mealType, String? status) {
    return Row(
      children: [
        Icon(
          getMealIcon(mealType),
          color: Colors.orangeAccent,
        ),
        const SizedBox(width: 10.0),
        Text(
          '$mealType: ${status ?? 'Not Ordered'}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  IconData getMealIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.breakfast_dining;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      default:
        return Icons.error;
    }
  }

  void showErrorDialog() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ErrorDialog()),
    );
  }

  Widget buildUserInfo(User user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserDetailsPage(user: user)),
        );
      },
      child: Card(
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.orangeAccent,
              child: Text(
                user.fName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              '${user.fName.toUpperCase()} ${user.lName.toUpperCase()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0),
                Text(
                  'Phone: ${user.phone}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Employee ID: ${user.empId}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Email: ${user.email}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShimmerEffect() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: CustomShimmer(
            child: ShimmerPlaceholder(),
          ),
        );
      },
    );
  }
}
