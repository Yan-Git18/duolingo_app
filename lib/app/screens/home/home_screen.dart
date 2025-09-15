import 'package:duolingo_app/app/screens/lessons/unit_1/saludos_screen.dart';
import 'package:duolingo_app/app/services/unidades_services.dart';
import 'package:duolingo_app/app/utils/constants.dart';
import 'package:flutter/material.dart';
import '../../models/unidad.dart';
import '../../models/leccion.dart';
import '../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Unidad> _unidades = [];
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _estadisticas;

  @override
  void initState() {
    super.initState();
    _cargarUnidades();
  }

  Future<void> _cargarUnidades() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final authService = AuthService();
      final userId = authService.currentUser?.uid ?? '';

      final unidades = await UnidadesService.obtenerUnidadesConProgreso(userId);
      final estadisticas = UnidadesService.obtenerEstadisticas(unidades);

      setState(() {
        _unidades = unidades;
        _estadisticas = estadisticas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar las unidades: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _completarLeccion(String leccionId) async {
    final authService = AuthService();
    final userId = authService.currentUser?.uid ?? '';

    final exito = await UnidadesService.completarLeccion(userId, leccionId);

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Lección completada! +10 puntos'),
          backgroundColor: AppColors.primary,
        ),
      );
      _cargarUnidades(); // Recargar datos
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al completar la lección'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const Text(
              "Mis Unidades",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            if (_estadisticas != null)
              Text(
                "${_estadisticas!['leccionesCompletadas']} de ${_estadisticas!['totalLecciones']} lecciones completadas",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
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
                          ? AppColors.primary
                          : Colors.red,
                    ),
                  );
                }
              } else if (value == 'refresh') {
                _cargarUnidades();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Mi Perfil'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Actualizar'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: AppColors.primary),
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

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text('Cargando unidades...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarUnidades,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Reintentar',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (_unidades.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay unidades disponibles',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarUnidades,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _unidades.length,
        itemBuilder: (context, index) {
          final unidad = _unidades[index];
          final estaDisponible = unidad.isAvailable(_unidades);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
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
                    colors: estaDisponible
                        ? [
                            unidad.colorSecundario,
                            unidad.colorSecundario.withValues(alpha: 0.7),
                          ]
                        : [Colors.grey[300]!, Colors.grey[200]!],
                  ),
                ),
                child: ExpansionTile(
                  enabled: estaDisponible,
                  tilePadding: const EdgeInsets.all(20),
                  childrenPadding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 16,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: estaDisponible
                          ? unidad.colorPrimario.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      estaDisponible ? unidad.icono : Icons.lock,
                      color: estaDisponible
                          ? unidad.colorPrimario
                          : Colors.grey,
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
                          color: estaDisponible
                              ? unidad.colorPrimario
                              : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        estaDisponible
                            ? unidad.descripcion
                            : "Completa la unidad anterior para desbloquear",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (estaDisponible) ...[
                        const SizedBox(height: 8),
                        // Barra de progreso
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: unidad.progreso,
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
                          "${unidad.porcentajeProgreso}% completado",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                  iconColor: estaDisponible
                      ? unidad.colorPrimario
                      : Colors.grey,
                  collapsedIconColor: estaDisponible
                      ? unidad.colorPrimario
                      : Colors.grey,
                  children: estaDisponible
                      ? unidad.lecciones.asMap().entries.map((entry) {
                          final leccion = entry.value;
                          final esUltima =
                              entry.key == unidad.lecciones.length - 1;
                          final leccionDisponible =
                              UnidadesService.esLeccionDisponible(
                                leccion,
                                _unidades,
                              );

                          return Container(
                            margin: EdgeInsets.only(bottom: esUltima ? 0 : 12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: leccionDisponible && !leccion.completada
                                    ? () => _mostrarDialogoLeccion(leccion)
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: leccion.completada
                                          ? unidad.colorPrimario.withValues(
                                              alpha: 0.3,
                                            )
                                          : leccionDisponible
                                          ? Colors.grey[300]!
                                          : Colors.grey[200]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: leccion.completada
                                              ? unidad.colorPrimario.withValues(
                                                  alpha: 0.1,
                                                )
                                              : leccionDisponible
                                              ? Colors.grey[100]
                                              : Colors.grey[50],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          leccion.completada
                                              ? leccion.icono
                                              : leccionDisponible
                                              ? leccion.icono
                                              : Icons.lock,
                                          color: leccion.completada
                                              ? unidad.colorPrimario
                                              : leccionDisponible
                                              ? Colors.grey[400]
                                              : Colors.grey[300],
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              leccion.titulo,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: leccion.completada
                                                    ? unidad.colorPrimario
                                                    : leccionDisponible
                                                    ? Colors.grey[700]
                                                    : Colors.grey[400],
                                              ),
                                            ),
                                            if (leccion.descripcion != null)
                                              Text(
                                                leccion.descripcion!,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (leccion.completada)
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: unidad.colorPrimario,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        )
                                      else if (leccionDisponible)
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[300]!,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.grey,
                                            size: 12,
                                          ),
                                        )
                                      else
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.lock,
                                            color: Colors.grey,
                                            size: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList()
                      : [],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _mostrarDialogoLeccion(Leccion leccion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(leccion.icono, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  leccion.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leccion.descripcion != null) ...[
                Text(
                  leccion.descripcion!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                '¿Estás listo para comenzar esta lección?',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //Navigator.of(context).pop();
                //_iniciarLeccion(leccion);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeccionSaludosScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Comenzar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _iniciarLeccion(Leccion leccion) {
    // Por ahora solo simula completar la lección
    // Aquí navegarías a la pantalla de la lección
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF58CC02)),
            const SizedBox(height: 16),
            Text('Simulando lección: ${leccion.titulo}'),
          ],
        ),
      ),
    );

    // Simular que la lección toma 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Cerrar dialog de loading
      _completarLeccion(leccion.id);
    });
  }
}
