import 'package:flutter/material.dart';

import 'package:isen_aurion_client/event.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:isen_companion/aurion.dart';
import 'package:isen_companion/schedule/schedule_app_bar.dart';
import 'package:isen_companion/schedule/schedule_constants.dart';
import 'package:isen_companion/schedule/schedule_week_table.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  var schedule = {};
  CalendarFormat calendarFormat = CalendarFormat.week;
  bool isCalendarOpen = false;
  DateTime focusedDay = DateTime.now();
  StartingDayOfWeek startingDayOfWeek = StartingDayOfWeek.sunday;
  late DateTime selectedDay;
  late final ValueNotifier<List<Event>> selectedEvents;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    selectedDay = focusedDay;
    selectedEvents = ValueNotifier(getDayEvents(selectedDay));
    Aurion.getUserSchedule().then((value) {
      setState((() => schedule = value));
      selectedEvents.value = getDayEvents(selectedDay);
    });
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
      selectedEvents.value = getDayEvents(selectedDay);
    }
  }

  void onPageChanged(DateTime focusedDay) {
    setState(() {
      this.focusedDay = focusedDay;
    });
  }

  List<Event> getDayEvents(DateTime day) {
    return schedule[day] ?? [];
  }

  Icon getEventIcon(Event event) {
    IconData iconData;
    switch (event.type) {
      case EventType.course:
        iconData = Icons.edit_note;
        break;
      case EventType.exam:
        iconData = Icons.school;
        break;
      case EventType.meeting:
        iconData = Icons.groups;
        break;
      case EventType.practicalWork:
        iconData = Icons.engineering;
        break;
      case EventType.supervisedWork:
        iconData = Icons.group;
        break;
      default:
        iconData = Icons.error;
    }
    return Icon(iconData);
  }

  String getEventType(Event event) {
    switch (event.type) {
      case EventType.course:
        return "Cours";
      case EventType.exam:
        return "Examen";
      case EventType.meeting:
        return "Réunion";
      case EventType.practicalWork:
        return "TP";
      case EventType.supervisedWork:
        return "TD";
      default:
        return "Erreur";
    }
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
            eventLoader: getDayEvents,
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: selectedEvents,
              builder: ((context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    Event event = value[index];

                    DateTime start = event.start.toLocal();
                    String startHour = start.hour.toString().padLeft(2, '0');
                    String startMinute =
                        start.minute.toString().padLeft(2, '0');

                    DateTime end = event.end.toLocal();
                    String endHour = end.hour.toString().padLeft(2, '0');
                    String endMinute = end.minute.toString().padLeft(2, '0');
                    String time =
                        "$startHour:$startMinute - $endHour:$endMinute";

                    List<Widget> description = [
                      Text(time),
                      Text(event.room),
                      Text(event.participants.join(', ')),
                    ];

                    if (event.chapter.isNotEmpty) {
                      description.insert(1, Text(event.chapter));
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      child: ListTile(
                        leading: Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          message: getEventType(event),
                          child: getEventIcon(event),
                        ),
                        title: Text(event.subject),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: description,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
