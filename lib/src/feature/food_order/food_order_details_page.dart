import 'package:flutter/material.dart';
import 'package:food_order/src/common/constant/color_constant.dart';
import 'package:food_order/src/feature/food_order/food_order_details_bloc.dart';
import 'package:food_order/src/feature/food_order/food_order_details_state.dart';
import 'package:provider/provider.dart';

import '../../common/constant/dimens_constant.dart';
import '../../common/months.dart';
import '../../common/ui/custom_shimmer.dart';
import '../../common/ui/error_dialog.dart';
import '../../common/ui/shimmer_placeholder.dart';
import '../../common/utils.dart';
import '../../repository/model/food_order_details.dart';
import '../user_details/user_details_page.dart';

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
            color: ColorConstant.black,
          ),
        ),
        backgroundColor: ColorConstant.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(DimensConstant.size10),
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
                const SizedBox(height: DimensConstant.size10),
                const Divider(
                  thickness: DimensConstant.size2,
                  color: ColorConstant.grey,
                ),
                buildMonthDropdown(),
                const Divider(
                  thickness: DimensConstant.size2,
                  color: ColorConstant.grey,
                ),
                const SizedBox(height: DimensConstant.size10),
                Expanded(child: buildOrderDetails(state.orderDetails)),
                const SizedBox(height: DimensConstant.size10),
                Center(
                  child: Text(
                    'Monthly Total Fine: Rs ${state.monthlyFine}',
                    style: const TextStyle(
                      fontSize: DimensConstant.size20,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.red,
                    ),
                  ),
                ),
              ],
            );
          },
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
          elevation: DimensConstant.size4,
          margin: const EdgeInsets.symmetric(vertical: DimensConstant.size8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensConstant.size10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(DimensConstant.size10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getFormattedDate(day.date),
                  style: const TextStyle(
                    fontSize: DimensConstant.size16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DimensConstant.size5),
                buildMealInfo('Breakfast', day.optIns.breakfast?.value),
                buildMealInfo('Lunch', day.optIns.lunch?.value),
                buildMealInfo('Dinner', day.optIns.dinner?.value),
                const SizedBox(height: DimensConstant.size5),
                Text(
                  'Daily Fine: Rs $dailyFine',
                  style: const TextStyle(color: ColorConstant.red),
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
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Select Month: ',
              style: TextStyle(
                fontSize: DimensConstant.size16,
                color: ColorConstant.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: DimensConstant.size10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DimensConstant.size12,
                  vertical: DimensConstant.size8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(DimensConstant.size10),
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstant.grey.withOpacity(0.2),
                      spreadRadius: DimensConstant.size2,
                      blurRadius: DimensConstant.size5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstant.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstant.black),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(DimensConstant.size10),
                  value: snapshot.data,
                  items: buildDropdownItems(),
                  onChanged: (String? month) {
                    final selectedMonth =
                        Months.values.firstWhere((e) => e.name == month).value;
                    bloc.fetchOrderDetails(month: selectedMonth);
                  },
                  style: const TextStyle(
                    fontSize: DimensConstant.size16,
                    color: ColorConstant.black,
                    fontWeight: FontWeight.w500,
                  ),
                  dropdownColor: ColorConstant.white,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: ColorConstant.black,
                  ),
                ),
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
          color: ColorConstant.orangeAccent,
        ),
        const SizedBox(width: DimensConstant.size10),
        Text(
          '$mealType: ${status ?? 'Not Ordered'}',
          style: const TextStyle(fontSize: DimensConstant.size16),
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
        elevation: DimensConstant.size4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensConstant.size10)),
        child: Padding(
          padding: const EdgeInsets.all(DimensConstant.size10),
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: DimensConstant.size20,
              backgroundColor: ColorConstant.orangeAccent,
              child: Text(
                user.fName[0].toUpperCase(),
                style: const TextStyle(
                  color: ColorConstant.white,
                  fontSize: DimensConstant.size20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              '${user.fName.toUpperCase()} ${user.lName.toUpperCase()}',
              style: const TextStyle(
                fontSize: DimensConstant.size20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: DimensConstant.size5),
                Text(
                  'Phone: ${user.phone}',
                  style: const TextStyle(
                    fontSize: DimensConstant.size16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DimensConstant.size5),
                Text(
                  'Employee ID: ${user.empId}',
                  style: const TextStyle(
                    fontSize: DimensConstant.size16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DimensConstant.size5),
                Text(
                  'Email: ${user.email}',
                  style: const TextStyle(
                    fontSize: DimensConstant.size16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: ColorConstant.black,
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
          padding: EdgeInsets.symmetric(
            vertical: DimensConstant.size10,
            horizontal: DimensConstant.size16,
          ),
          child: CustomShimmer(
            child: ShimmerPlaceholder(),
          ),
        );
      },
    );
  }
}
