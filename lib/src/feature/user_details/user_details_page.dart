import 'package:flutter/material.dart';

import '../../common/constant/color_constant.dart';
import '../../common/constant/dimens_constant.dart';
import '../../repository/model/food_order_details.dart'; // Import the User model

class UserDetailsPage extends StatelessWidget {
  final User user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double baseFontSize = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: ColorConstant.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(DimensConstant.size16),
        child: Card(
          elevation: DimensConstant.size4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensConstant.size10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(DimensConstant.size16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ColorConstant.orangeAccent,
                    child: Text(
                      user.fName[0].toUpperCase(),
                      style: TextStyle(
                        color: ColorConstant.white,
                        fontSize: baseFontSize * 1.5,
                      ),
                    ),
                  ),
                  title: Text(
                    '${user.fName.toUpperCase()} ${user.lName.toUpperCase()}',
                    style: TextStyle(fontSize: baseFontSize * 1.2),
                  ),
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.check_circle,
                  'Status: ${user.status == 1 ? 'Active' : 'Inactive'}',
                  baseFontSize,
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.phone,
                  'Phone: ${user.phone}',
                  baseFontSize,
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.email,
                  'Email: ${user.email}',
                  baseFontSize,
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.badge,
                  'Employee ID: ${user.empId}',
                  baseFontSize,
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.account_balance,
                  'Department ID: ${user.departmentId}',
                  baseFontSize,
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.restaurant,
                  'Is Vegetarian: ${user.isVeg == 1 ? 'Yes' : 'No'}',
                  baseFontSize,
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.calendar_today,
                  'Is Saturday Opted: ${user.isSatOpted == 1 ? 'Yes' : 'No'}',
                  baseFontSize,
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.breakfast_dining,
                  'Breakfast Opted: ${user.isBreakfast == 1 ? 'Yes' : 'No'}',
                  baseFontSize,
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.lunch_dining,
                  'Lunch Opted: ${user.isLunch == 1 ? 'Yes' : 'No'}',
                  baseFontSize,
                ),
                const SizedBox(height: DimensConstant.size10),
                buildInfoRow(
                  Icons.dinner_dining,
                  'Dinner Opted: ${user.isDinner == 1 ? 'Yes' : 'No'}',
                  baseFontSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String text, double fontSize) {
    return Row(
      children: [
        Icon(icon, color: ColorConstant.orangeAccent),
        const SizedBox(width: DimensConstant.size10),
        Text(text, style: TextStyle(fontSize: fontSize)),
      ],
    );
  }
}
