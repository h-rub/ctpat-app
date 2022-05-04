import 'package:ctpat/src/tokens/colors.dart';
import 'package:ctpat/src/tokens/typography.dart';
import 'package:ctpat/src/widgets/input_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class CreateFormScreeen extends StatefulWidget {
  @override
  _CreateFormScreeenState createState() => _CreateFormScreeenState();
}

class _CreateFormScreeenState extends State<CreateFormScreeen> {
  final _formKey = GlobalKey<FormState>();

  int _activeStepIndex = 0;

  // EMBARQUES
  String date = "";
  DateTime selectedDateForm = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDateForm,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDateForm)
      setState(() {
        selectedDateForm = selected;
        fechaForm.text =
            formatDate(selectedDateForm, [dd, '/', mm, '/', yyyy]).toString();
      });
  }

  String _setTime, _setDate;

  String _hour, _minute, _time;
  TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(DateTime.now().hour.toString()),
      minute: int.parse(DateTime.now().minute.toString()));

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        horaEnrampado.text = _time;
        horaEnrampado.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    horaEnrampado.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    fechaForm.text =
        formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]).toString();
    super.initState();
  }

  TextEditingController fechaForm = TextEditingController();
  TextEditingController horaEnrampado = TextEditingController();
  TextEditingController horaSalida = TextEditingController();
  TextEditingController lineaCaja = TextEditingController();
  TextEditingController marcaTractor = TextEditingController();
  TextEditingController placasTractor = TextEditingController();
  TextEditingController numeroEconomico = TextEditingController();

  // CAJA

  TextEditingController numeroCaja = TextEditingController();
  TextEditingController placasCaja = TextEditingController();

  // INGRESOS

  TextEditingController inAutorizadoPor = TextEditingController();
  TextEditingController inFactura = TextEditingController();
  TextEditingController inNumeroPallets = TextEditingController();
  TextEditingController inNumeroSello = TextEditingController();
  TextEditingController inSelloEntregadoA = TextEditingController();
  bool inTermsSello = false;
  TextEditingController inDestino = TextEditingController();
  bool inIsExportacion = false;
  TextEditingController inGuardiaEnTurno = TextEditingController();

  // CHECKLIST

  TextEditingController chFechaHoraLlegada = TextEditingController();

  bool _s1 = false, _s2 = false, _s3 = false;
  bool _n1 = false, _n2 = false, _n3 = false;

  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: Text('1', style: heading2Black),
          content: Container(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Embarques", style: heading2Primary),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: IgnorePointer(
                        child: DateInput(
                          controller: fechaForm,
                          hintText:
                              "${selectedDateForm.day}/${selectedDateForm.month}/${selectedDateForm.year}",
                          label: "Fecha",
                          inputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: InkWell(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: IgnorePointer(
                              child: Input(
                                controller: horaEnrampado,
                                hintText: "11:20",
                                label: "Hora de enrampado",
                                inputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: Input(
                            controller: horaSalida,
                            hintText: "11:30",
                            label: "Salida",
                            inputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Tractor", style: heading2Primary),
                    const SizedBox(
                      height: 10,
                    ),
                    Input(
                      controller: lineaCaja,
                      hintText: "",
                      label: "Linea de la caja",
                      inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: Input(
                            controller: marcaTractor,
                            hintText: "",
                            label: "Marca del tractor",
                            inputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: Input(
                            controller: placasTractor,
                            hintText: "",
                            label: "Placas del tractor",
                            inputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: Input(
                            controller: numeroEconomico,
                            hintText: "",
                            label: "Número económico",
                            inputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Caja", style: heading2Primary),
                    const SizedBox(
                      height: 10,
                    ),
                    Input(
                      controller: lineaCaja,
                      hintText: "",
                      label: "Línea de la caja",
                      inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: Input(
                            controller: numeroCaja,
                            hintText: "",
                            label: "Número caja",
                            inputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: Input(
                            controller: placasCaja,
                            hintText: "",
                            label: "Placas",
                            inputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Ingreso", style: heading2Primary),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(height: 8),
                    Input(
                      controller: inAutorizadoPor,
                      hintText: "",
                      label: "Autorizado por",
                      inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: Input(
                            controller: inFactura,
                            hintText: "",
                            label: "Factura",
                            inputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: Input(
                            controller: inNumeroPallets,
                            hintText: "",
                            label: "Número de pallets",
                            inputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Input(
                      controller: inNumeroSello,
                      hintText: "",
                      label: "Número de sello",
                      inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 8),
                    Input(
                      controller: inSelloEntregadoA,
                      hintText: "",
                      label: "Sello entregado a",
                      inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            activeColor: primaryClr,
                            checkColor: primaryLightClr,
                            value: inTermsSello,
                            onChanged: (bool value) {
                              print(value);
                              setState(() {
                                inTermsSello = value;
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text:
                                    "Acepta la resposabilidad de la adquisición del sello y lo que conlleva",
                                style: body,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Input(
                      controller: inDestino,
                      hintText: "",
                      label: "Destino",
                      inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            activeColor: primaryClr,
                            checkColor: primaryLightClr,
                            value: inIsExportacion,
                            onChanged: (bool value) {
                              print(value);
                              setState(() {
                                inIsExportacion = value;
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Es exportación a E.U",
                                style: body,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Input(
                      controller: inGuardiaEnTurno,
                      hintText: "",
                      label: "Guardia en turno",
                      inputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: Text('2', style: heading2Black),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("CheckList de Embarques", style: heading2Primary),
                  const SizedBox(
                    height: 10,
                  ),
                  Input(
                    controller: chFechaHoraLlegada,
                    hintText: "",
                    label: "Fecha y Hora de Llegada (Formato 24/hrs)",
                    inputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 8),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Documentación de Entrada", style: heading2Primary),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 40,
                                child: Text(
                                  'Sí',
                                  textAlign: TextAlign.center,
                                  style: subtitle,
                                ),
                              ),
                              Container(
                                width: 45,
                                child: Text(
                                  'No',
                                  textAlign: TextAlign.center,
                                  style: subtitle,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width - 130,
                          height: 50,
                          child: Text('Luces de enfrente',
                              textAlign: TextAlign.left,
                              style: subHeading2Black),
                        ),
                        Container(
                          child: Row(children: [
                            Container(
                                width: 40,
                                child: Checkbox(
                                  activeColor: primaryClr,
                                  value: _s1,
                                  onChanged: ((value) {
                                    print('Si ' + value.toString());
                                    print('Id item : 1');
                                    setState(() {
                                      _s1 = value;
                                      _n1 = !value;
                                    });
                                  }),
                                )),
                            Container(
                                width: 40,
                                child: Checkbox(
                                  activeColor: primaryClr,
                                  value: _n1,
                                  onChanged: ((value) {
                                    print('No ' + value.toString());
                                    print('Id item : 1');
                                    setState(() {
                                      _s1 = !value;
                                      _n1 = value;
                                    });
                                  }),
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Documentación de Salida", style: heading2Primary),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 8),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Incidencias", style: heading2Primary),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
        Step(
            state:
                _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: Text('3', style: heading2Black),
            content: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [],
            ))),
        Step(
            state:
                _activeStepIndex <= 3 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 3,
            title: Text('4', style: heading2Black),
            content: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [],
            ))),
        Step(
            state:
                _activeStepIndex <= 4 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 4,
            title: Text('5', style: heading2Black),
            content: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Email: ${horaEnrampado.text}'),
                const Text('Password: *****'),
                Text('Address : ${address.text}'),
                Text('PinCode : ${pincode.text}'),
              ],
            ))),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: primaryClr),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/nidec-embraco.png')),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/me');
                },
                child: Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("assets/default-profile.png"),
                          fit: BoxFit.cover)),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _activeStepIndex,
            steps: stepList(),
            onStepContinue: () {
              if (_activeStepIndex < (stepList().length - 1)) {
                setState(() {
                  _activeStepIndex += 1;
                });
              } else {
                print('Submited');
              }
            },
            onStepCancel: () {
              if (_activeStepIndex == 0) {
                return;
              }
              setState(() {
                _activeStepIndex -= 1;
              });
            },
            onStepTapped: (int index) {
              setState(() {
                _activeStepIndex = index;
              });
            },
            controlsBuilder: (context, {onStepContinue, onStepCancel}) {
              final isLastStep = _activeStepIndex == stepList().length - 1;
              return Container(
                child: Row(
                  children: [
                    if (_activeStepIndex > 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onStepCancel,
                          style: ElevatedButton.styleFrom(
                            primary: gray20,
                          ),
                          child: Text('Atrás', style: subHeading2Black),
                        ),
                      ),
                    if (_activeStepIndex > 0) SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryClr,
                        ),
                        onPressed: onStepContinue,
                        child: (isLastStep)
                            ? Text('Enviar', style: subHeading2White)
                            : Text('Siguiente', style: subHeading2White),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
