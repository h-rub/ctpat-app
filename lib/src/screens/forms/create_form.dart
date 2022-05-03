import 'package:ctpat/src/tokens/colors.dart';
import 'package:ctpat/src/tokens/typography.dart';
import 'package:ctpat/src/widgets/input_model.dart';
import 'package:flutter/material.dart';

class CreateFormScreeen extends StatefulWidget {
  @override
  _CreateFormScreeenState createState() => _CreateFormScreeenState();
}

class _CreateFormScreeenState extends State<CreateFormScreeen> {
  final _formKey = GlobalKey<FormState>();

  int _activeStepIndex = 0;

  // EMBARQUES
  TextEditingController fecha = TextEditingController();
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

  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: Text('1', style: heading2Black),
          content: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Embarques", style: heading2Black),
                const SizedBox(
                  height: 10,
                ),
                Input(
                  controller: fecha,
                  hintText: "12/06/2022",
                  label: "Fecha",
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
                        controller: horaEnrampado,
                        hintText: "11:20",
                        label: "Hora de enrampado",
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.7,
                      child: Input(
                        controller: horaSalida,
                        hintText: "11:30",
                        label: "Salida",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Tractor", style: heading2Black),
                const SizedBox(
                  height: 10,
                ),
                Input(
                  controller: lineaCaja,
                  hintText: "",
                  label: "Linea de la caja",
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
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.7,
                      child: Input(
                        controller: placasTractor,
                        hintText: "",
                        label: "Placas del tractor",
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Caja", style: heading2Black),
                const SizedBox(
                  height: 10,
                ),
                Input(
                  controller: lineaCaja,
                  hintText: "",
                  label: "Línea de la caja",
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
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.7,
                      child: Input(
                        controller: placasCaja,
                        hintText: "",
                        label: "Placas",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                const SizedBox(
                  height: 10,
                ),
                Text("Ingreso", style: heading2Black),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(height: 8),
                Input(
                  controller: inAutorizadoPor,
                  hintText: "",
                  label: "Autorizado por",
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
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.7,
                      child: Input(
                        controller: inNumeroPallets,
                        hintText: "",
                        label: "Número de pallets",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Input(
                  controller: inNumeroSello,
                  hintText: "",
                  label: "Número de sello",
                ),
                SizedBox(height: 8),
                Input(
                  controller: inSelloEntregadoA,
                  hintText: "",
                  label: "Sello entregado a",
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
                ),
                SizedBox(height: 8),
              ],
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
                children: [
                  Text("CheckList de Embarques", style: heading2Black),
                  const SizedBox(
                    height: 10,
                  ),
                  Input(
                    controller: chFechaHoraLlegada,
                    hintText: "",
                    label: "Fecha y Hora de Llegada (Formato 24/hrs)",
                  ),
                  SizedBox(height: 8),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Documentación de Entrada", style: heading2Black),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 8),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Documentación de Salida", style: heading2Black),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 8),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Incidencias", style: heading2Black),
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
                Text('Name: ${fecha.text}'),
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
