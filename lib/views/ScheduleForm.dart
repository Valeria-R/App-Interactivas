import 'package:animapp/widgets/InputWidget.dart';
import 'package:animapp/widgets/NavDrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animated_button/animated_button.dart';

class ScheduleForm extends StatefulWidget {
  final bool isIntoWidget;
  ScheduleForm({Key key, this.isIntoWidget = false}) : super(key: key);

  @override
  _ScheduleFormState createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  String dropdownValue = 'Perro';

  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerTime = TextEditingController();
  DateTime _dateTime = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  String getDate(DateTime date) => DateFormat('dd - MMMM - yyyy').format(date);
  String getTime(TimeOfDay time) => "${time.hour}:${time.minute}";

  Widget _buildPet() {
    return FormField(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Seleccione su tipo de mascota',
            icon: Icon(Icons.pets, color: Colors.grey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              isDense: true,
              onChanged: (value) => setState(() => dropdownValue = value),
              items: <String>['Perro', 'Gato']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _selectDate(context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        _controller.text = getDate(picked);
        _dateTime = picked;
      });
    }
  }

  _pickTime() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        _controllerTime.text = getTime(t);
        time = t;
      });
  }

  Widget _schedulingForm(context) {
    return ListView(
      children: <Widget>[
        Text(
          "Agenda tu cita",
          style: TextStyle(fontSize: 30.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Container(child: _buildPet(), width: MediaQuery.of(context).size.width),
        SizedBox(height: 30),
        TextFormField(
          controller: _controller,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            enabled: true,
            labelText: 'Fecha de la cita',
            icon: Icon(Icons.today, color: Colors.grey),
          ),
        ),
        SizedBox(height: 30),
        TextFormField(
          controller: _controllerTime,
          onTap: () => _pickTime(),
          decoration: InputDecoration(
            enabled: true,
            labelText: 'Hora de la cita',
            icon: Icon(Icons.access_time, color: Colors.grey),
          ),
        ),
        SizedBox(height: 30),
        Container(
            child: InputWidget(
                labelText: 'Número de contacto',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone),
            width: MediaQuery.of(context).size.width),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 15),
              child: AnimatedButton(
                color: Colors.green[300],
                onPressed: () {
                  var snackBar = SnackBar(
                    content: Text('Yay! se ha agendado tu cita!'),
                    action: SnackBarAction(
                      label: 'Cancelar',
                      onPressed: () {},
                    ),
                  );
                  // Navigator.pop(context);
                  Scaffold.of(context).showSnackBar(snackBar);
                },
                enabled: true,
                shadowDegree: ShadowDegree.dark,
                duration: 200,
                height: 64, // Button Height, default is 64
                width: 100,
                child: Container(
                  child: new Text("Agendar"),
                  width: MediaQuery.of(context).size.width / 7,
                ),
              ),
            ),
            AnimatedButton(
              onPressed: () => Navigator.pop(context),

              color: Colors.red[300],
              child: Container(
                child: new Text("Cancelar"),
                width: MediaQuery.of(context).size.width / 7,
              ),
              enabled: true,
              shadowDegree: ShadowDegree.dark,
              duration: 200,
              height: 64, // Button Height, default is 64
              width: 100,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    if (widget.isIntoWidget) {
      return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _schedulingForm(context),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimaApp'),
        backgroundColor: Colors.amber[700],
      ),
      backgroundColor: Colors.amberAccent[50],
      body: Builder(
        builder: (context) => Container(
          padding: EdgeInsets.symmetric(
              horizontal: phoneSize.width / 30,
              vertical: phoneSize.height / 50),
          child: _schedulingForm(context),
        ),
      ),
    );
  }
}
