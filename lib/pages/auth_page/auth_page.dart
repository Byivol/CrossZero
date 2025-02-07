import 'package:flutter/material.dart';

import 'formauth_widget.dart';

class StartAuthPage extends StatelessWidget {
  const StartAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawerEnableOpenDragGesture: false,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600 || constraints.maxHeight < 600) {
              return SingleChildScrollView(
                  child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(19, 0, 0, 0),
                              blurRadius: 10,
                              spreadRadius: 0.5,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FormAuth(),
                      ),
                    ),
                  ),
                  Center(
                    child: IntrinsicHeight(
                      child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(19, 0, 0, 0),
                                blurRadius: 10,
                                spreadRadius: 0.5,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Инструкция',
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: '\nСоздание лобби',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text:
                                              '\n1. Введите свой ник или ФИО.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: '\n2. Нажмите "Войти".',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ]),
                                  TextSpan(
                                      text:
                                          '\n\nПодключение к существующему \nлобби',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text:
                                              '\n1. Введите свой ник или ФИО.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              '\n2. Введите ID лобби \n     из существующего лобби.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: '\n3. Нажмите "Войти".',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ));
            } else {
              return SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: IntrinsicHeight(
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(19, 0, 0, 0),
                                blurRadius: 10,
                                spreadRadius: 0.5,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FormAuth(),
                        ),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(19, 0, 0, 0),
                                blurRadius: 10,
                                spreadRadius: 0.5,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Инструкция',
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nСоздание лобби',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '\n1. Введите свой ник или ФИО.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '\n2. Нажмите "Войти".',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text:
                                        '\n\nПодключение к существующему \nлобби',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '\n1. Введите свой ник или ФИО.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text:
                                        '\n2. Введите ID лобби \n     из существующего лобби.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '\n3. Нажмите "Войти".',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
