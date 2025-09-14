import 'package:flutter/material.dart';
import 'leccion.dart';

class Unidad {
  final String id;
  final String nombre;
  final String descripcion;
  final List<Leccion> lecciones;
  final Color colorPrimario;
  final Color colorSecundario;
  final IconData icono;
  final int orden;
  final bool bloqueada;
  final String? imagenUrl;

  Unidad({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.lecciones,
    required this.colorPrimario,
    required this.colorSecundario,
    required this.icono,
    required this.orden,
    this.bloqueada = false,
    this.imagenUrl,
  });

  // Constructor para crear desde datos de Firestore
  factory Unidad.fromFirestore(String id, Map<String, dynamic> data, List<Leccion> lecciones) {
    return Unidad(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      lecciones: lecciones,
      colorPrimario: _getColorFromString(data['colorPrimario'] ?? 'green'),
      colorSecundario: _getColorFromString(data['colorSecundario'] ?? 'lightGreen'),
      icono: _getIconFromString(data['icono'] ?? 'school'),
      orden: data['orden'] ?? 0,
      bloqueada: data['bloqueada'] ?? false,
      imagenUrl: data['imagenUrl'],
    );
  }

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'colorPrimario': _getStringFromColor(colorPrimario),
      'colorSecundario': _getStringFromColor(colorSecundario),
      'icono': _getStringFromIcon(icono),
      'orden': orden,
      'bloqueada': bloqueada,
      'imagenUrl': imagenUrl,
    };
  }

  // Calcular progreso de la unidad
  double get progreso {
    if (lecciones.isEmpty) return 0.0;
    final completadas = lecciones.where((l) => l.completada).length;
    return completadas / lecciones.length;
  }

  // Obtener porcentaje de progreso
  int get porcentajeProgreso => (progreso * 100).round();

  // Verificar si la unidad está completada
  bool get estaCompletada => lecciones.isNotEmpty && lecciones.every((l) => l.completada);

  // Obtener próxima lección disponible
  Leccion? get proximaLeccion {
    return lecciones
        .where((l) => !l.completada && l.isAvailable(lecciones))
        .cast<Leccion?>()
        .firstWhere((l) => l != null, orElse: () => null);
  }

  // Verificar si la unidad está disponible
  bool isAvailable(List<Unidad> unidadesAnteriores) {
    if (bloqueada) return false;
    if (orden <= 1) return true; // Primera unidad siempre disponible
    
    // Verificar que la unidad anterior esté completada
    final unidadAnterior = unidadesAnteriores
        .cast<Unidad?>()
        .firstWhere(
          (u) => u != null && u.orden == orden - 1, 
          orElse: () => null,
        );
    
    return unidadAnterior?.estaCompletada ?? false;
  }

  // Crear una copia con campos modificados
  Unidad copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    List<Leccion>? lecciones,
    Color? colorPrimario,
    Color? colorSecundario,
    IconData? icono,
    int? orden,
    bool? bloqueada,
    String? imagenUrl,
  }) {
    return Unidad(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      lecciones: lecciones ?? this.lecciones,
      colorPrimario: colorPrimario ?? this.colorPrimario,
      colorSecundario: colorSecundario ?? this.colorSecundario,
      icono: icono ?? this.icono,
      orden: orden ?? this.orden,
      bloqueada: bloqueada ?? this.bloqueada,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }

  @override
  String toString() {
    return 'Unidad{id: $id, nombre: $nombre, progreso: $porcentajeProgreso %}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Unidad && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Mapeo de strings a colores
  static Color _getColorFromString(String colorName) {
    const colorMap = {
      'green': Color(0xFF58CC02),
      'lightGreen': Color(0xFFE8F5E8),
      'blue': Color(0xFF1CB0F6),
      'lightBlue': Color(0xFFE3F2FD),
      'orange': Color(0xFFFF9600),
      'lightOrange': Color(0xFFFFF3E0),
      'red': Color(0xFFFF4B4B),
      'lightRed': Color(0xFFFFE5E5),
      'purple': Color(0xFF9C27B0),
      'lightPurple': Color(0xFFF3E5F5),
    };
    return colorMap[colorName] ?? const Color(0xFF58CC02);
  }

  static String _getStringFromColor(Color color) {
    final colorMap = {
      Color(0xFF58CC02): 'green',
      Color(0xFFE8F5E8): 'lightGreen',
      Color(0xFF1CB0F6): 'blue',
      Color(0xFFE3F2FD): 'lightBlue',
      Color(0xFFFF9600): 'orange',
      Color(0xFFFFF3E0): 'lightOrange',
      Color(0xFFFF4B4B): 'red',
      Color(0xFFFFE5E5): 'lightRed',
      Color(0xFF9C27B0): 'purple',
      Color(0xFFF3E5F5): 'lightPurple',
    };
    return colorMap[color] ?? 'green';
  }

  // Mapeo de strings a iconos
  static IconData _getIconFromString(String iconName) {
    const iconMap = {
      'play_circle_outline': Icons.play_circle_outline,
      'home_outlined': Icons.home_outlined,
      'chat_bubble_outline': Icons.chat_bubble_outline,
      'school': Icons.school,
      'translate': Icons.translate,
      'public': Icons.public,
      'psychology': Icons.psychology,
      'business': Icons.business,
      'sports_soccer': Icons.sports_soccer,
      'music_note': Icons.music_note,
    };
    return iconMap[iconName] ?? Icons.school;
  }

  static String _getStringFromIcon(IconData icon) {
    final iconMap = {
      Icons.play_circle_outline: 'play_circle_outline',
      Icons.home_outlined: 'home_outlined',
      Icons.chat_bubble_outline: 'chat_bubble_outline',
      Icons.school: 'school',
      Icons.translate: 'translate',
      Icons.public: 'public',
      Icons.psychology: 'psychology',
      Icons.business: 'business',
      Icons.sports_soccer: 'sports_soccer',
      Icons.music_note: 'music_note',
    };
    return iconMap[icon] ?? 'school';
  }
}