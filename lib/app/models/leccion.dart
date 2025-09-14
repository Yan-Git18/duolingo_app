import 'package:flutter/material.dart';

class Leccion {
  final String id;
  final String titulo;
  final IconData icono;
  final bool completada;
  final int orden;
  final String? descripcion;
  final List<String>? prerequisitos; // IDs de lecciones que deben completarse primero
  
  Leccion({
    required this.id,
    required this.titulo,
    required this.icono,
    this.completada = false,
    required this.orden,
    this.descripcion,
    this.prerequisitos,
  });

  // Constructor para crear desde datos de Firestore
  factory Leccion.fromFirestore(String id, Map<String, dynamic> data) {
    return Leccion(
      id: id,
      titulo: data['titulo'] ?? '',
      icono: _getIconFromString(data['icono'] ?? 'help_outline'),
      completada: data['completada'] ?? false,
      orden: data['orden'] ?? 0,
      descripcion: data['descripcion'],
      prerequisitos: List<String>.from(data['prerequisitos'] ?? []),
    );
  }

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'icono': _getStringFromIcon(icono),
      'completada': completada,
      'orden': orden,
      'descripcion': descripcion,
      'prerequisitos': prerequisitos ?? [],
    };
  }

  // Crear una copia con campos modificados
  Leccion copyWith({
    String? id,
    String? titulo,
    IconData? icono,
    bool? completada,
    int? orden,
    String? descripcion,
    List<String>? prerequisitos,
  }) {
    return Leccion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      icono: icono ?? this.icono,
      completada: completada ?? this.completada,
      orden: orden ?? this.orden,
      descripcion: descripcion ?? this.descripcion,
      prerequisitos: prerequisitos ?? this.prerequisitos,
    );
  }

  // Verificar si la lección está disponible basado en prerequisitos
  bool isAvailable(List<Leccion> leccionesCompletadas) {
    if (prerequisitos == null || prerequisitos!.isEmpty) {
      return true;
    }
    
    final idsCompletadas = leccionesCompletadas
        .where((l) => l.completada)
        .map((l) => l.id)
        .toSet();
    
    return prerequisitos!.every((prereq) => idsCompletadas.contains(prereq));
  }

  @override
  String toString() {
    return 'Leccion{id: $id, titulo: $titulo, completada: $completada}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Leccion && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Mapeo de strings a iconos (para Firestore)
  static IconData _getIconFromString(String iconName) {
    const iconMap = {
      'waving_hand': Icons.waving_hand,
      'person_outline': Icons.person_outline,
      'palette': Icons.palette,
      'pets': Icons.pets,
      'restaurant': Icons.restaurant,
      'flash_on': Icons.flash_on,
      'family_restroom': Icons.family_restroom,
      'numbers': Icons.numbers,
      'category': Icons.category,
      'school': Icons.school,
      'book': Icons.book,
      'quiz': Icons.quiz,
      'mic': Icons.mic,
      'headset': Icons.headset,
      'translate': Icons.translate,
    };
    return iconMap[iconName] ?? Icons.help_outline;
  }

  static String _getStringFromIcon(IconData icon) {
    final iconMap = {
      Icons.waving_hand: 'waving_hand',
      Icons.person_outline: 'person_outline',
      Icons.palette: 'palette',
      Icons.pets: 'pets',
      Icons.restaurant: 'restaurant',
      Icons.flash_on: 'flash_on',
      Icons.family_restroom: 'family_restroom',
      Icons.numbers: 'numbers',
      Icons.category: 'category',
      Icons.school: 'school',
      Icons.book: 'book',
      Icons.quiz: 'quiz',
      Icons.mic: 'mic',
      Icons.headset: 'headset',
      Icons.translate: 'translate',
    };
    return iconMap[icon] ?? 'help_outline';
  }
}