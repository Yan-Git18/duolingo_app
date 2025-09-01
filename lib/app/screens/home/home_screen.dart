import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Unidad> unidades = [
    Unidad("Unidad 1", [
      Leccion("Lección 1: Saludos"),
      Leccion("Lección 2: Presentaciones"),
      Leccion("Lección 3: Colores"),
    ]),
    Unidad("Unidad 2", [
      Leccion("Lección 1: Animales"),
      Leccion("Lección 2: Comida"),
    ]),
    Unidad("Unidad 3", [
      Leccion("Lección 1: Verbos básicos"),
      Leccion("Lección 2: Familia"),
      Leccion("Lección 3: Números"),
      Leccion("Lección 4: Objetos"),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Unidades"),
        backgroundColor: const Color(0xFF58CC02), // Verde Duolingo
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: unidades.length,
        itemBuilder: (context, index) {
          final unidad = unidades[index];
          return Card(
            color: const Color.fromARGB(255, 232, 245, 255),
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ExpansionTile(
              title: Text(
                unidad.nombre,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF58CC02), // Verde Duolingo
                ),
              ),
              children: unidad.lecciones.map((leccion) {
                return Align(
                  alignment:
                      Alignment.centerLeft, // 👈 Pega todo a la izquierda
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Text(
                      leccion.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 1, 30, 16), // Texto negro
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class Leccion {
  String titulo;
  Leccion(this.titulo);
}

class Unidad {
  String nombre;
  List<Leccion> lecciones;
  Unidad(this.nombre, this.lecciones);
}