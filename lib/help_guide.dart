// help_guide.dart
import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Image.asset(
              'assets/logoCDB.png', // Asegúrate de que esta ruta de imagen sea correcta
              width: 150,
              height: 150,
            ),
            Text(
              'Guía de Uso',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 140, 93, 194),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              buildHelpSection('Bienvenido',
                  'Esta aplicación está diseñada para ayudarte a identificar colores de manera sencilla y precisa, ideal para personas con daltonismo.'),
              Divider(
                  color: const Color.fromARGB(255, 140, 93, 194),
                  thickness: 1), // Separador
              buildHelpSection('Permiso de Cámara',
                  'Al abrir la app por primera vez, necesitarás conceder permiso para acceder a la cámara de tu dispositivo.'),
              buildHelpSection('Uso de la Cámara',
                  'La cámara se activará mostrando un círculo central que es tu guía para detectar colores.'),
              buildHelpSection('Detección de Colores',
                  'Apunta la cámara al objeto deseado. El color dentro del círculo será analizado para darte su nombre y código hexadecimal.'),
              buildHelpSection('Ayuda y Soporte',
                  'Si necesitas asistencia adicional o tienes preguntas, no dudes en contactarnos.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white, // Color del texto del botón
              backgroundColor:
              Color.fromARGB(255, 140, 93, 194), // Fondo del botón
            ),
            child: Text('Entendido'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget buildHelpSection(String title, String content) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(
                  255, 113, 89, 141), // Color del título de la sección
              fontSize: 18, // Tamaño del título de la sección
            ),
          ),
          TextSpan(
            text: content,
            style: TextStyle(
              color: Colors.black87, // Color del contenido
              fontSize: 16, // Tamaño del contenido
            ),
          ),
        ],
      ),
    ),
  );
}