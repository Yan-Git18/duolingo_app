import 'package:duolingo_app/app/models/leccion.dart';
import 'package:duolingo_app/app/models/unidad.dart';
import 'package:duolingo_app/app/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Unidad> get unidades => [
    Unidad(
      "Unidad 1: Fundamentos",
      "Aprende los conceptos básicos del idioma",
      [
        Leccion("Lección 1: Saludos", Icons.waving_hand, completada: true),
        Leccion(
          "Lección 2: Presentación",
          Icons.person_outline,
          completada: true,
        ),
        Leccion("Lección 3: Colores", Icons.palette),
      ],
      const Color(0xFF58CC02),
      const Color(0xFFE8F5E8),
      Icons.play_circle_outline,
    ),
    Unidad(
      "Unidad 2: Vida Cotidiana",
      "Vocabulario para el día a día",
      [
        Leccion("Lección 1: Animales", Icons.pets),
        Leccion("Lección 2: Comida", Icons.restaurant),
      ],
      const Color(0xFF1CB0F6),
      const Color(0xFFE3F2FD),
      Icons.home_outlined,
    ),
    Unidad(
      "Unidad 3: Comunicación",
      "Expresiones y conceptos avanzados",
      [
        Leccion("Lección 1: Verbos básicos", Icons.flash_on),
        Leccion("Lección 2: Familia", Icons.family_restroom),
        Leccion("Lección 3: Números", Icons.numbers),
        Leccion("Lección 4: Objetos", Icons.category),
      ],
      const Color(0xFFFF9600),
      const Color(0xFFFFF3E0),
      Icons.chat_bubble_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Mis Unidades",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color(0xFF58CC02),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Botón de perfil/configuración
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                final authService = AuthService();
                final result = await authService.signOut();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.message),
                      backgroundColor: result.success
                          ? const Color(0xFF58CC02)
                          : Colors.red,
                    ),
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF58CC02)),
                    SizedBox(width: 8),
                    Text('Mi Perfil'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFF58CC02)),
                    SizedBox(width: 8),
                    Text('Configuración'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: unidades.length,
        itemBuilder: (context, index) {
          final unidad = unidades[index];
          final progreso =
              unidad.lecciones.where((l) => l.completada).length /
              unidad.lecciones.length;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      unidad.colorSecundario,
                      unidad.colorSecundario.withOpacity(0.7),
                    ],
                  ),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(20),
                  childrenPadding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 16,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: unidad.colorPrimario.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      unidad.icono,
                      color: unidad.colorPrimario,
                      size: 28,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unidad.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: unidad.colorPrimario,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        unidad.descripcion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Barra de progreso
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: progreso,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: unidad.colorPrimario,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${(progreso * 100).round()}% completado",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  iconColor: unidad.colorPrimario,
                  collapsedIconColor: unidad.colorPrimario,
                  children: unidad.lecciones.asMap().entries.map((entry) {
                    final leccion = entry.value;
                    final esUltima = entry.key == unidad.lecciones.length - 1;

                    return Container(
                      margin: EdgeInsets.only(bottom: esUltima ? 0 : 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: leccion.completada
                              ? unidad.colorPrimario.withOpacity(0.3)
                              : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: leccion.completada
                                  ? unidad.colorPrimario.withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              leccion.icono,
                              color: leccion.completada
                                  ? unidad.colorPrimario
                                  : Colors.grey[400],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              leccion.titulo,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: leccion.completada
                                    ? unidad.colorPrimario
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                          if (leccion.completada)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: unidad.colorPrimario,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          else
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
