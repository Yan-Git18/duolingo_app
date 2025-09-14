import 'package:flutter/material.dart';

class Leccion {
  String titulo;
  IconData icono;
  bool completada;
  
  Leccion(this.titulo, this.icono, {this.completada = false});
}