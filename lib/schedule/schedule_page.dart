import 'package:flutter/material.dart';
import 'package:isen_ouest_companion/schedule/schedule_week_table.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:isen_ouest_companion/aurion.dart';
import 'package:isen_ouest_companion/schedule/schedule_app_bar.dart';
import 'package:isen_ouest_companion/schedule/schedule_constants.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  late List<dynamic> schedule;
  CalendarFormat calendarFormat = CalendarFormat.week;
  bool isCalendarOpen = false;
  DateTime focusedDay = DateTime.now();
  StartingDayOfWeek startingDayOfWeek = StartingDayOfWeek.sunday;
  late DateTime selectedDay;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    selectedDay = focusedDay;
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void showCalendarState() async {
    isCalendarOpen = animationController.status == AnimationStatus.completed;
    if (isCalendarOpen) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    setState(() {
      calendarFormat =
          isCalendarOpen ? CalendarFormat.week : CalendarFormat.month;
    });
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(this.selectedDay, selectedDay)) {
      setState(() {
        this.selectedDay = selectedDay;
        this.focusedDay = focusedDay;
      });
    }
  }

  void onPageChanged(DateTime focusedDay) {
    setState(() {
      this.focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScheduleAppBar(
        animationController: animationController,
        showCalendarState: showCalendarState,
        focusedDay: focusedDay,
        locale: locale,
      ),
      body: Column(
        children: [
          ScheduleWeekTable(
            locale: locale,
            firstDay: Aurion.defaultStart,
            lastDay: Aurion.defaultEnd,
            selectedDay: selectedDay,
            focusedDay: focusedDay,
            startingDayOfWeek: startingDayOfWeek,
            calendarFormat: calendarFormat,
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged,
          )
        ],
      ),
    );
  }
}
