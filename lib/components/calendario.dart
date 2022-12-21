import 'package:flutter/material.dart';
import 'package:inmobiliariapp/utils/format_date.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendario extends StatefulWidget {
  const Calendario({Key? key}) : super(key: key);

  @override
  State<Calendario> createState() => _CalendarioState();
}

DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();
CalendarFormat _calendarFormat = CalendarFormat.month;

Map<CalendarFormat, String> _availableCalendarFormats = {
  CalendarFormat.week: 'Semana',
  CalendarFormat.twoWeeks: '2 Semanas',
  CalendarFormat.month: 'Mes',
};

class _CalendarioState extends State<Calendario> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarStyle: _calendarStyle(),
      calendarBuilders: CalendarBuilders<dynamic>(
        // Formato header dias
        dowBuilder: (context, day) {
          final text = Responsive.isDesktop(context)
              ? dayFormat(day)
              : dayFormatOneLetter(day);
          return Center(
            child: Text(text, style: Theme.of(context).textTheme.bodyText1!),
          );
        },
      ),
      daysOfWeekHeight: 40,
      rowHeight: 60,
      availableGestures: AvailableGestures.all,
      locale: 'es_ES',
      daysOfWeekStyle:
          DaysOfWeekStyle(weekdayStyle: Theme.of(context).textTheme.bodyText1!),
      startingDayOfWeek: StartingDayOfWeek.monday,
      firstDay: DateTime.now().toUtc(),
      lastDay: DateTime.utc(2100, 1, 1),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarFormat: _calendarFormat,
      availableCalendarFormats: _availableCalendarFormats,
      pageAnimationCurve: Curves.easeIn,
      pageAnimationDuration: const Duration(milliseconds: 300),
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
    );
  }

  CalendarStyle _calendarStyle() {
    Color colorBorde = Theme.of(context).brightness == Brightness.dark
        ? colorGrisOscuro
        : colorGrisMasClaro;
    return CalendarStyle(
      cellMargin: const EdgeInsets.all(10),
      defaultTextStyle: TextStyle(
        color: colorBlanco,
        fontWeight: FontWeight.w500,
      ),
      holidayTextStyle: TextStyle(
        color: colorBlanco,
        fontWeight: FontWeight.w500,
      ),
      disabledTextStyle: TextStyle(
        color: colorBlanco,
        fontWeight: FontWeight.w500,
      ),
      weekendTextStyle: TextStyle(
        color: colorBlanco,
        fontWeight: FontWeight.w500,
      ),
      todayDecoration: BoxDecoration(
        color: colorBlanco,
        shape: BoxShape.circle,
      ),
      todayTextStyle: TextStyle(
        color: Theme.of(context).backgroundColor,
        fontWeight: FontWeight.w500,
      ),
      selectedDecoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [colorBlanco],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      selectedTextStyle: TextStyle(
        color: colorNegro,
        fontWeight: FontWeight.w500,
      ),
      tableBorder: TableBorder.all(
        color: colorBorde,
        width: 1.5,
        borderRadius: BorderRadius.circular(25),
      ),
      isTodayHighlighted: true,
    );
  }
}
