import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/components/custom_dialog.dart';
import 'package:inmobiliariapp/components/custom_list_view_objetivos.dart';
import 'package:inmobiliariapp/components/side_menu.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/model/objetivo.dart';
import 'package:inmobiliariapp/providers/objetivos_provider.dart';
import 'package:inmobiliariapp/utils/format_date.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

bool onTap = false;
List<Accion> acciones = [];
DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();
CalendarFormat _calendarFormat = CalendarFormat.month;

Map<CalendarFormat, String> _availableCalendarFormats = {
  CalendarFormat.week: 'Semana',
  CalendarFormat.twoWeeks: '2 Semanas',
  CalendarFormat.month: 'Mes',
};

TextEditingController objetivoController = TextEditingController();

class _CalendarioPageState extends State<CalendarioPage> {
  GlobalKey<ScaffoldState> calendarioKey = GlobalKey<ScaffoldState>();
  List<Objetivo> objetivos = [];
  final Database _db = Database();

  Future<void> getObjetivos() async {
    objetivos = await _db.getObjetivos(_selectedDay);
    debugPrint(objetivos.toString());
    setState(() {});
  }

  Future<void> getAcciones() async {
    acciones = await Database().getAcciones();
  }

  @override
  void initState() {
    super.initState();
    getObjetivos();
    getAcciones();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var objetivosProvider = Provider.of<ObjetivosProvider>(context);

    return Scaffold(
      key: calendarioKey,
      appBar: Responsive.isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                splashRadius: 25,
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                onPressed: () => calendarioKey.currentState!.openDrawer(),
              ),
            ),
      drawer: Responsive.isDesktop(context) ? null : const SideMenu(),
      drawerScrimColor: Colors.black.withOpacity(0.6),
      body: StreamBuilder<QuerySnapshot>(
        stream: objetivosProvider.fetchObjetivosStream(_selectedDay),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return SpinKitRing(color: colorAzul, lineWidth: 4);
          } else {
            objetivos = snapshot.data!.docs
                .map((doc) => Objetivo.fromDoc(doc))
                .toList();
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Responsive.isDesktop(context)) const SideMenu(),
                    Expanded(
                      child: Column(
                        children: [
                          titulo(),
                          calendario(),
                          const SizedBox(height: 20),
                          Expanded(child: objetivosDelDia()),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Padding titulo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 15),
      child: Text('Calendario', style: Theme.of(context).textTheme.headline2),
    );
  }

  Widget calendario() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
              colors: [colorAzul, colorRosa.withOpacity(0.6)],
              begin: Alignment(-2, -1),
              end: Alignment(1, 1))),
      child: TableCalendar(
        calendarStyle: _calendarStyle(context),
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
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: Theme.of(context).textTheme.bodyText1!),
        startingDayOfWeek: StartingDayOfWeek.monday,
        firstDay: DateTime.now().toUtc(),
        lastDay: DateTime.utc(2100, 1, 1),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          _onDaySelected(selectedDay, focusedDay);
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
      ),
    );
  }

  CalendarStyle _calendarStyle(context) {
    return CalendarStyle(
      cellMargin: const EdgeInsets.all(10),
      selectedDecoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [colorBlanco, colorBlanco],
          begin: Alignment(-2, -1),
          end: Alignment(1, 1),
        ),
      ),
      selectedTextStyle: TextStyle(
        color: masOscuro,
        fontWeight: FontWeight.w600,
      ),
      tableBorder: TableBorder.all(
          color: colorBlanco,
          width: 1.5,
          borderRadius: BorderRadius.circular(25)),
      outsideTextStyle: TextStyle(color: colorGrisMasClaro),
      disabledTextStyle: TextStyle(color: colorGrisMasClaro),
      defaultTextStyle: TextStyle(
        color: colorGrisMasClaro,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
      });
    }
  }

  // void getObjetivosDiarios(List<Objetivo> objetivos) {
  //   for (Objetivo obj in this.objetivos) {
  //     // debugPrint('${formatDate(obj.fecha)} == ${formatDate(_selectedDay)}');
  //     if (formatDate(obj.fecha) == formatDate(_selectedDay)) {
  //       objetivos.add(obj);
  //       // debugPrint(obj.toString());
  //     }
  //   }
  // }

  Widget objetivosDelDia() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [colorAzul, colorRosa.withOpacity(0.6)],
            begin: Alignment(-1.5, -1),
            end: Alignment(1, 1)),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? colorGrisOscuro
              : colorGrisMasClaro,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Objetivos del ${completeDateString(_selectedDay).toLowerCase()}',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.builder(
              itemCount: objetivos.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                //debugPrint(objetivos[i].fecha.toString());
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Row(
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: colorBlanco, width: 1.5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(objetivos[i].nombre)),
                          const SizedBox(width: 15),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: colorBlanco, width: 1.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text('${objetivos[i].cantidad}'),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            splashRadius: 25,
                            onPressed: () => _db.deleteObjetivo(objetivos[i]),
                            icon: const Icon(FontAwesomeIcons.xmark, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colorBlanco),
              onPressed: () => showDialog(
                context: context,
                builder: (context) =>
                    CustomListViewObjetivos(_selectedDay, acciones),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Añadir objetivo'),
              ),
            ),
          ),
          const SizedBox(height: 15),
          /*SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colorBlanco),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(_selectedDay, acciones),
                );
                onTap = !onTap;
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Vaciar mes'),
              ),
            ),
          ),*/
          const SizedBox(height: 0),
        ],
      ),
    );
  }
}
