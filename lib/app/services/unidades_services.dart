import 'package:flutter/material.dart';
import '../models/leccion.dart';
import '../models/unidad.dart';

class UnidadesService {
  // Datos estáticos para desarrollo (luego migrarás a Firestore)
  static List<Unidad> obtenerUnidades() {
    return [
      Unidad(
        id: 'unidad_1',
        nombre: "Unidad 1: Fundamentos",
        descripcion: "Aprende los conceptos básicos del idioma",
        orden: 1,
        colorPrimario: const Color(0xFF58CC02),
        colorSecundario: const Color(0xFFE8F5E8),
        icono: Icons.play_circle_outline,
        lecciones: [
          Leccion(
            id: 'unidad_1_leccion_1',
            titulo: "Lección 1: Saludos",
            icono: Icons.waving_hand,
            completada: false,
            orden: 1,
            descripcion: "Aprende saludos básicos en el nuevo idioma",
          ),
          Leccion(
            id: 'unidad_1_leccion_2',
            titulo: "Lección 2: Presentación",
            icono: Icons.person_outline,
            completada: false,
            orden: 2,
            descripcion: "Cómo presentarte y hablar de ti mismo",
            prerequisitos: ['unidad_1_leccion_1'],
          ),
          Leccion(
            id: 'unidad_1_leccion_3',
            titulo: "Lección 3: Colores",
            icono: Icons.palette,
            completada: false,
            orden: 3,
            descripcion: "Vocabulario de colores básicos",
            prerequisitos: ['unidad_1_leccion_2'],
          ),
        ],
      ),
      Unidad(
        id: 'unidad_2',
        nombre: "Unidad 2: Vida Cotidiana",
        descripcion: "Vocabulario para el día a día",
        orden: 2,
        colorPrimario: const Color(0xFF1CB0F6),
        colorSecundario: const Color(0xFFE3F2FD),
        icono: Icons.home_outlined,
        lecciones: [
          Leccion(
            id: 'unidad_2_leccion_1',
            titulo: "Lección 1: Animales",
            icono: Icons.pets,
            completada: false,
            orden: 1,
            descripcion: "Nombres de animales comunes",
          ),
          Leccion(
            id: 'unidad_2_leccion_2',
            titulo: "Lección 2: Comida",
            icono: Icons.restaurant,
            completada: false,
            orden: 2,
            descripcion: "Vocabulario de alimentos y bebidas",
            prerequisitos: ['unidad_2_leccion_1'],
          ),
        ],
      ),
      Unidad(
        id: 'unidad_3',
        nombre: "Unidad 3: Comunicación",
        descripcion: "Expresiones y conceptos avanzados",
        orden: 3,
        colorPrimario: const Color(0xFFFF9600),
        colorSecundario: const Color(0xFFFFF3E0),
        icono: Icons.chat_bubble_outline,
        lecciones: [
          Leccion(
            id: 'unidad_3_leccion_1',
            titulo: "Lección 1: Verbos básicos",
            icono: Icons.flash_on,
            completada: false,
            orden: 1,
            descripcion: "Verbos de acción más comunes",
          ),
          Leccion(
            id: 'unidad_3_leccion_2',
            titulo: "Lección 2: Familia",
            icono: Icons.family_restroom,
            completada: false,
            orden: 2,
            descripcion: "Miembros de la familia",
            prerequisitos: ['unidad_3_leccion_1'],
          ),
          Leccion(
            id: 'unidad_3_leccion_3',
            titulo: "Lección 3: Números",
            icono: Icons.numbers,
            completada: false,
            orden: 3,
            descripcion: "Números del 1 al 100",
            prerequisitos: ['unidad_3_leccion_2'],
          ),
          Leccion(
            id: 'unidad_3_leccion_4',
            titulo: "Lección 4: Objetos",
            icono: Icons.category,
            completada: false,
            orden: 4,
            descripcion: "Objetos de uso diario",
            prerequisitos: ['unidad_3_leccion_3'],
          ),
        ],
      ),
    ];
  }

  // Simular obtener unidades con progreso del usuario
  static Future<List<Unidad>> obtenerUnidadesConProgreso(String userId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Por ahora retorna datos estáticos, pero aquí harías consulta a Firestore
    return obtenerUnidades();
  }

  // Marcar una lección como completada
  static Future<bool> completarLeccion(String userId, String leccionId) async {
    try {
      // Simular guardar en base de datos
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Aquí harías:
      // 1. Actualizar progreso en Firestore
      // 2. Actualizar puntos del usuario
      // 3. Verificar si se desbloquean nuevas lecciones
      
      print('Lección completada: $leccionId para usuario: $userId');
      return true;
    } catch (e) {
      print('Error al completar lección: $e');
      return false;
    }
  }

  // Obtener estadísticas del progreso
  static Map<String, dynamic> obtenerEstadisticas(List<Unidad> unidades) {
    int totalLecciones = 0;
    int leccionesCompletadas = 0;
    int unidadesCompletadas = 0;
    
    for (var unidad in unidades) {
      totalLecciones += unidad.lecciones.length;
      leccionesCompletadas += unidad.lecciones.where((l) => l.completada).length;
      if (unidad.estaCompletada) unidadesCompletadas++;
    }
    
    double progresoGeneral = totalLecciones > 0 ? leccionesCompletadas / totalLecciones : 0;
    
    return {
      'totalUnidades': unidades.length,
      'unidadesCompletadas': unidadesCompletadas,
      'totalLecciones': totalLecciones,
      'leccionesCompletadas': leccionesCompletadas,
      'progresoGeneral': progresoGeneral,
      'porcentajeGeneral': (progresoGeneral * 100).round(),
    };
  }

  // Verificar si una lección está disponible
  static bool esLeccionDisponible(Leccion leccion, List<Unidad> unidades) {
    // Obtener todas las lecciones para verificar prerequisitos
    List<Leccion> todasLasLecciones = [];
    for (var unidad in unidades) {
      todasLasLecciones.addAll(unidad.lecciones);
    }
    
    return leccion.isAvailable(todasLasLecciones);
  }

  // Obtener la próxima lección recomendada
  static Leccion? obtenerProximaLeccion(List<Unidad> unidades) {
    for (var unidad in unidades) {
      if (unidad.isAvailable(unidades)) {
        var proximaLeccion = unidad.proximaLeccion;
        if (proximaLeccion != null) {
          return proximaLeccion;
        }
      }
    }
    return null;
  }

  // Calcular puntos ganados por completar una lección
  static int calcularPuntos(Leccion leccion) {
    // Puntos base por lección
    int puntosBase = 10;
    
    // Bonificación por prerequisitos (lecciones más avanzadas dan más puntos)
    int bonificacion = (leccion.prerequisitos?.length ?? 0) * 2;
    
    return puntosBase + bonificacion;
  }

  // Verificar si se mantiene la racha
  static bool verificarRacha(DateTime ultimaLeccion, DateTime ahora) {
    final diferencia = ahora.difference(ultimaLeccion);
    return diferencia.inDays <= 1; // La racha se mantiene si estudió ayer o hoy
  }
}