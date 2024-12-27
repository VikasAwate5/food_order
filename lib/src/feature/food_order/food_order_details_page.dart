import 'package:flutter/material.dart';
import 'package:food_order/src/feature/food_order/food_order_details_bloc.dart';
import 'package:food_order/src/feature/food_order/food_order_details_state.dart';
import 'package:provider/provider.dart';

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
        title: const Text('Food Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<FoodOrderDetailsState>(
            stream: bloc.stateStream.distinct(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              final state = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.orderDetails.length,
                      itemBuilder: (context, index) {
                        final day = state.orderDetails[index];
                        final dailyFine = bloc.calculateDailyFine(day.optIns);

                        return Card(
                          child: ListTile(
                            title: Text(day.date),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Breakfast: ${day.optIns.breakfast?.value ?? 'Not Ordered'}',
                                ),
                                Text(
                                  'Lunch: ${day.optIns.lunch?.value ?? 'Not Ordered'}',
                                ),
                                Text(
                                  'Dinner: ${day.optIns.dinner?.value ?? 'Not Ordered'}',
                                ),
                                Text(
                                  'Daily Fine: Rs $dailyFine',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    'Monthly Total Fine: Rs ${state.monthlyFine}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
