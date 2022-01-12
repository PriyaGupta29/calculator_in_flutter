import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: CalculatorApp(),
    );
  }
}

const Color colorDark = Color(0xFF374352);
const Color colorLight = Color(0xFFe6eeff);

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool darkMode = false;
  String _result = '';
  String _expression = '';

  bool isLastInputAnOperator() {
    return valueIsOperator(_expression[_expression.length-1]) && _expression[_expression.length-1] != '.';
  }

  bool valueIsOperator(String val) {
    return val == '+' || val == '-' || val == '*' || val == '/';
  }

  void numClick(String text) {
    if(_expression == '' && _result != '') {
      setState(() {
        _expression = _result += text;
        _result = '';
      });
    }
    if(_expression.length > 0 && valueIsOperator(text) && isLastInputAnOperator()) {
      setState(() {
        _expression = _expression.substring(0, _expression.length - 1) + text;
      });
    } else {
      setState(() => _expression += text);
    }
  }

  void allClear(String text) {
    setState(() {
      _result = '';
      _expression = '';
    });
  }

  void clearLast(String text) {
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1);
      _result = '';
    });
  }

  void calculate(String equation) {
    var result = '0';
    try {
      Parser p = Parser();
      Expression exp = p.parse(equation);
      ContextModel cm = ContextModel();
      result = '${exp.evaluate(EvaluationType.REAL, cm)}';
    } catch (e) {
      print(e);
    }
    setState(() {
      _result = result;
      _expression = '';
    });
  }

  void evaluate(String text) {
    var equation = _expression.replaceAll("%", "/100");
    calculate(equation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            darkMode ? darkMode = false : darkMode = true;
                          });
                        },
                        child: _switchMode()),
                    SizedBox(height: 80),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _result,
                        style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: darkMode ? Colors.white : Colors.red),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _expression,
                          style: TextStyle(
                              fontSize: 20,
                              color: darkMode ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              Container(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: 'C',
                          textColor: darkMode ? Colors.green : Colors.redAccent,
                          callback: allClear),
                      _buttonRounded(
                          icon: Icons.backspace_outlined,
                          iconColor: darkMode ? Colors.green : Colors.redAccent,
                          callback: clearLast),
                      _buttonRounded(
                          title: '%',
                          textColor: darkMode ? Colors.green : Colors.redAccent,
                          callback: numClick),
                      _buttonRounded(
                          title: '/',
                          textColor: darkMode ? Colors.green : Colors.redAccent,
                          callback: numClick)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(title: '7', callback: numClick),
                      _buttonRounded(title: '8', callback: numClick),
                      _buttonRounded(title: '9', callback: numClick),
                      _buttonRounded(
                          title: '*',
                          textColor: darkMode ? Colors.green : Colors.redAccent,
                          callback: numClick)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(title: '4', callback: numClick),
                      _buttonRounded(title: '5', callback: numClick),
                      _buttonRounded(title: '6', callback: numClick),
                      _buttonRounded(
                          title: '-',
                          textColor: darkMode ? Colors.green : Colors.redAccent,
                          callback: numClick)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(title: '1', callback: numClick),
                      _buttonRounded(title: '2', callback: numClick),
                      _buttonRounded(title: '3', callback: numClick),
                      _buttonRounded(
                          title: '+',
                          textColor: darkMode ? Colors.green : Colors.redAccent,
                          callback: numClick)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(title: '0', callback: numClick),
                      _buttonRounded(title: '.', callback: numClick),
                      _buttonRounded(
                          title: '=',
                          width: true,
                          textColor: darkMode ? Colors.green : Colors.redAccent,
                          callback: evaluate)
                    ],
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonRounded(
      {String title,
      double padding = 17,
      IconData icon,
      Color iconColor,
      Color textColor,
      Function callback,
      bool width = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: NeuContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(40),
        padding: EdgeInsets.all(padding),
        child: Container(
            width: width ? padding * 7 : padding * 2,
            height: padding * 2,
            child: Center(
                child: title != null
                    ? GestureDetector(
                        onTap: () {
                          callback(title);
                        },
                        child: new Text(
                          '$title',
                          style: TextStyle(
                              color: textColor != null
                                  ? textColor
                                  : darkMode
                                      ? Colors.white
                                      : Colors.black,
                              fontSize: 30),
                        ))
                    : GestureDetector(
                        onTap: () {
                          callback(title);
                        },
                        child: new Icon(
                          icon,
                          color: iconColor,
                          size: 30,
                        ),
                      ))),
      ),
    );
  }

  Widget _switchMode() {
    return NeuContainer(
      darkMode: darkMode,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 70,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(
            Icons.wb_sunny,
            color: darkMode ? Colors.grey : Colors.redAccent,
          ),
          Icon(
            Icons.nightlight_round,
            color: darkMode ? Colors.green : Colors.grey,
          ),
        ]),
      ),
    );
  }
}

class NeuContainer extends StatefulWidget {
  final bool darkMode;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  NeuContainer(
      {this.darkMode = false, this.child, this.borderRadius, this.padding});

  @override
  _NeuContainerState createState() => _NeuContainerState();
}

class _NeuContainerState extends State<NeuContainer> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = widget.darkMode;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
            color: darkMode ? colorDark : colorLight,
            borderRadius: widget.borderRadius,
            boxShadow: _isPressed
                ? null
                : [
                    BoxShadow(
                      color:
                          darkMode ? Colors.black54 : Colors.blueGrey.shade200,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                        color:
                            darkMode ? Colors.blueGrey.shade700 : Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0)
                  ]),
        child: widget.child,
      ),
    );
  }
}
