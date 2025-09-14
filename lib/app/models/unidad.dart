import 'package:flutter/material.dart';
import 'leccion.dart';

class Unidad {
  String nombre;
  String descripcion;
  List<Leccion> lecciones;
  Color colorPrimario;
  Color colorSecundario;
  IconData icono;
  
  Unidad(this.nombre, this.descripcion, this.lecciones, 
         this.colorPrimario, this.colorSecundario, this.icono);
}