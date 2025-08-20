import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/view/nav_bar/photographer/home/business_builder/business_builder.dart';
import 'package:zapxx/view/nav_bar/photographer/home/other_screen/custom_widgets/custom_button.dart';
import 'package:zapxx/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key, required this.discount});
  final String discount;
  @override
  State<DiscountScreen> createState() => _DiscountState();
}

class _DiscountState extends State<DiscountScreen> {
  String? _selectedDate;
  String? _selectedTime;
  String? _selectedEndDate;
  String? _selectedEndTime;
  String? _selectedDateLocal;
  String? _selectedTimeLocal;
  String? _selectedEndDateLocal;
  String? _selectedEndTimeLocal;
  late TextEditingController _percentController; // Declare controller here

  @override
  void initState() {
    super.initState();
    // Initialize controller with widget.discount (even if empty)
    _percentController = TextEditingController(text: widget.discount);
  }

  @override
  void dispose() {
    _percentController.dispose(); // Cleanup controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.950),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.950),
        centerTitle: true,
        title: const Text('Discount'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Discount percentage layer',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _percentController,
                decoration: InputDecoration(
                  hintText: 'Enter percentage',
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.grey.withOpacity(.1),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide(
                      width: 0.2,
                      color: Colors.grey.withOpacity(0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide(
                      width: 0.2,
                      color: Colors.grey.withOpacity(0),
                    ),
                  ),
                ),
              ),
              const Gap(20),
              const Text(
                'Start Date & Time',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Gap(20),
              _buildDateTimeRow(
                context: context,
                selectedDate: _selectedDate,
                onDatePicked: (value, localValue) {
                  setState(() {
                    _selectedDate = value;
                    _selectedDateLocal = localValue;
                  });
                },
                selectedTime: _selectedTime,
                onTimePicked: (value, localValue) {
                  setState(() {
                    _selectedTime = value;
                    _selectedTimeLocal = localValue;
                  });
                },
              ),
              const Gap(20),
              const Text(
                'End Date & Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(20),
              _buildDateTimeRow(
                context: context,
                selectedDate: _selectedEndDate,
                onDatePicked: (value, localValue) {
                  setState(() {
                    _selectedEndDate = value;
                    _selectedEndDateLocal = localValue;
                  });
                },
                selectedTime: _selectedEndTime,
                onTimePicked: (value, localValue) {
                  setState(() {
                    _selectedEndTime = value;
                    _selectedEndTimeLocal = localValue;
                  });
                },
              ),
              const Gap(160),
              CustomButton(
                width: 400.0,
                height: 50.0,
                text: 'Save',
                fontSize: 20.0,
                onPressed: () {
                  userProvider.setLoading(true);
                  Map data = {
                    "percentage": _percentController.text,
                    "startDate": _selectedDateLocal,
                    "endDate": _selectedEndDateLocal,
                    "startTime": _selectedTimeLocal,
                    "endTime": _selectedEndTimeLocal,
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const BusinessBuilder();
                      },
                    ),
                  );
                  userProvider
                      .discountSeller(data)
                      .then((value) {
                        userProvider.setLoading(false);
                        Utils.flushBarSuccessMessage(
                          'Discount added Successfully',
                          context,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const BusinessBuilder();
                            },
                          ),
                        );
                      })
                      .onError((error, stackTrace) {
                        Utils.flushBarErrorMessage(error.toString(), context);
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeRow({
    required BuildContext context,
    required String? selectedDate,
    required void Function(String, String) onDatePicked,
    required String? selectedTime,
    required void Function(String, String) onTimePicked,
  }) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                final localValue = pickedDate.toUtc().toIso8601String();
                onDatePicked(
                  "${pickedDate.toLocal()}".split(' ')[0],
                  localValue,
                );
              }
            },
            child: _buildPickerContainer(
              selectedValue: selectedDate ?? 'Select Date',
              icon: Icons.calendar_today_outlined,
            ),
          ),
          GestureDetector(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                final now = DateTime.now();
                final pickedDateTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
                final localValue = pickedDateTime.toUtc().toIso8601String();
                onTimePicked(pickedTime.format(context), localValue);
              }
            },
            child: _buildPickerContainer(
              selectedValue: selectedTime ?? 'Select Time',
              icon: Icons.access_time_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerContainer({
    required String selectedValue,
    required IconData icon,
  }) {
    return Container(
      height: 45,
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedValue,
              style: TextStyle(color: Colors.grey.withOpacity(0.99)),
            ),
            Icon(icon, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
