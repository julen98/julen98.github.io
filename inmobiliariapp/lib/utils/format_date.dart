import 'package:intl/intl.dart';

String formatDate(DateTime fecha) {
  return DateFormat('dd-MM-yyyy').format(fecha);
}

DateTime get yesterday => DateTime.now().subtract(const Duration(days: 1));
DateTime get tomorrow => DateTime.now().add(const Duration(days: 1));

DateTime getFirstDayMonth(DateTime hoy) {
  late DateTime diaUno;
  var ultimoDia = getLastDayMonth(hoy);

  diaUno = DateTime(
      ultimoDia.year, ultimoDia.month, ultimoDia.day - (ultimoDia.day - 1));

  return diaUno;
}

DateTime getLastDayMonth(DateTime hoy) {
  var ultimoDia = (hoy.month < 12)
      ? DateTime(hoy.year, hoy.month + 1, 0)
      : DateTime(hoy.year + 1, 1, 0);

  return ultimoDia;
}

DateTime getMonday(DateTime hoy) {
  late DateTime lunes;
  switch (hoy.weekday) {
    case DateTime.monday:
      lunes = DateTime(hoy.year, hoy.month, hoy.day);
      break;
    case DateTime.tuesday:
      lunes = DateTime(hoy.year, hoy.month, hoy.day - 1);
      break;
    case DateTime.wednesday:
      lunes = DateTime(hoy.year, hoy.month, hoy.day - 2);
      break;
    case DateTime.thursday:
      lunes = DateTime(hoy.year, hoy.month, hoy.day - 3);
      break;
    case DateTime.friday:
      lunes = DateTime(hoy.year, hoy.month, hoy.day - 4);
      break;
    case DateTime.saturday:
      lunes = DateTime(hoy.year, hoy.month, hoy.day - 5);
      break;
    case DateTime.sunday:
      lunes = DateTime(hoy.year, hoy.month, hoy.day - 6);
      break;
    default:
  }
  return lunes;
}

String dayFormat(DateTime fecha) {
  switch (fecha.weekday) {
    case 1:
      return 'Lunes';
    case 2:
      return 'Martes';
    case 3:
      return 'Miércoles';
    case 4:
      return 'Jueves';
    case 5:
      return 'Viernes';
    case 6:
      return 'Sábado';
    case 7 | 0:
      return 'Domingo';
    default:
  }
  return DateFormat('EEEE').format(fecha);
}

String dayFormatOneLetter(DateTime fecha) {
  switch (fecha.weekday) {
    case 1:
      return 'L';
    case 2:
      return 'M';
    case 3:
      return 'X';
    case 4:
      return 'J';
    case 5:
      return 'V';
    case 6:
      return 'S';
    case 7 | 0:
      return 'D';
    default:
  }
  return DateFormat('EEEE').format(fecha);
}

String monthFormat(DateTime fecha) {
  switch (fecha.month) {
    case 1:
      return 'Enero';
    case 2:
      return 'Febrero';
    case 3:
      return 'Marzo';
    case 4:
      return 'Abril';
    case 5:
      return 'Mayo';
    case 6:
      return 'Junio';
    case 7:
      return 'Julio';
    case 8:
      return 'Agosto';
    case 9:
      return 'Septiembre';
    case 10:
      return 'Octubre';
    case 11:
      return 'Noviembre';
    case 12:
      return 'Diciembre';
    default:
  }
  return DateFormat('EEEE').format(fecha);
}

String monthFormatOneLetter(DateTime fecha) {
  switch (fecha.month) {
    case 1:
      return 'E';
    case 2:
      return 'F';
    case 3:
      return 'Ma';
    case 4:
      return 'Ab';
    case 5:
      return 'My';
    case 6:
      return 'Jn';
    case 7:
      return 'Jl';
    case 8:
      return 'Ag';
    case 9:
      return 'S';
    case 10:
      return 'O';
    case 11:
      return 'N';
    case 12:
      return 'D';
    default:
  }
  return DateFormat('EEEE').format(fecha);
}

String completeDateString(DateTime fecha) {
  return '${dayFormat(fecha)}, ${fecha.day} de ${monthFormat(fecha).toLowerCase()} de ${fecha.year}';
}
