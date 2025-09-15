import 'package:duolingo_app/app/utils/constants.dart';
import 'package:flutter/material.dart';

class LeccionSaludosScreen extends StatefulWidget {
  const LeccionSaludosScreen({super.key});

  @override
  State<LeccionSaludosScreen> createState() => _LeccionSaludosScreenState();
}

class _LeccionSaludosScreenState extends State<LeccionSaludosScreen> {
  int preguntaActual = 0;
  int puntos = 0;
  bool respuestaVerificada = false;
  bool respuestaCorrecta = false;
  String? respuestaSeleccionada;
  final TextEditingController _textController = TextEditingController();

  final List<Map<String, dynamic>> preguntas = [
    {
      'tipo': 'seleccion',
      'pregunta': '¿Cómo se dice "Hola" en inglés?',
      'opciones': ['Goodbye', 'Hello', 'Please', 'Thank you'],
      'respuesta_correcta': 'Hello',
      'puntos': 10,
    }, /*
    {
      'tipo': 'completar',
      'pregunta': 'Completa la frase: "Good _______" (Buenos días)',
      'respuesta_correcta': 'morning',
      //'pista': 'Piensa en la primera parte del día',
      'puntos': 15,
    },
    {
      'tipo': 'seleccion',
      'pregunta': '¿Cuál es la respuesta correcta a "How are you?"',
      'opciones': ['Hello', 'Goodbye', 'I am fine', 'Please'],
      'respuesta_correcta': 'I am fine',
      'puntos': 10,
    },
    {
      'tipo': 'completar',
      'pregunta': 'Completa la frase: "Good ___" (Adios)',
      'respuesta_correcta': 'bye',
      //'pista': 'Piensa en la primera parte del día',
      'puntos': 15,
    }, */
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void verificarRespuesta() {
    setState(() {
      respuestaVerificada = true;
      
      if (preguntas[preguntaActual]['tipo'] == 'seleccion') {
        respuestaCorrecta = respuestaSeleccionada == preguntas[preguntaActual]['respuesta_correcta'];
      } else {
        respuestaCorrecta = _textController.text.toLowerCase().trim() == 
                           preguntas[preguntaActual]['respuesta_correcta'].toLowerCase();
      }

      if (respuestaCorrecta) {
        puntos += preguntas[preguntaActual]['puntos'] as int;
        _mostrarSnackBar('¡Correcto! +${preguntas[preguntaActual]['puntos']} puntos', true);
      } else {
        _mostrarSnackBar('Respuesta incorrecta. La respuesta correcta es: ${preguntas[preguntaActual]['respuesta_correcta']}', false);
      }
    });
  }

  void continuarSiguientePregunta() {
    if (preguntaActual < preguntas.length - 1) {
      setState(() {
        preguntaActual++;
        respuestaVerificada = false;
        respuestaCorrecta = false;
        respuestaSeleccionada = null;
        _textController.clear();
      });
    } else {
      // Terminar lección
      _mostrarPantallaCompletado();
    }
  }

  void _mostrarSnackBar(String mensaje, bool esExito) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esExito ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _mostrarPantallaCompletado() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LeccionCompletadaScreen(puntos: puntos),
      ),
    );
  }

  Widget _construirPreguntaSeleccion(Map<String, dynamic> pregunta) {
    return Column(
      children: [
        ...pregunta['opciones'].map<Widget>((opcion) {
          bool esSeleccionada = respuestaSeleccionada == opcion;
          bool esCorrecta = opcion == pregunta['respuesta_correcta'];
          
          // Colores por defecto
          Color colorBoton = esSeleccionada ? Colors.blue.shade100 : Colors.grey.shade200;
          Color colorTexto = esSeleccionada ? Colors.blue.shade700 : Colors.black87;
          Color colorBorde = Colors.grey.shade400;
          
          // Solo cambiar colores después de verificar
          if (respuestaVerificada) {
            if (esCorrecta) {
              colorBoton = Colors.green.shade100;
              colorTexto = Colors.green.shade700;
              colorBorde = Colors.green;
            } else if (esSeleccionada && !esCorrecta) {
              colorBoton = Colors.red.shade100;
              colorTexto = Colors.red.shade700;
              colorBorde = Colors.red;
            } else {
              colorBorde = Colors.grey.shade300;
            }
          }

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              onPressed: respuestaVerificada ? null : () {
                setState(() {
                  respuestaSeleccionada = opcion;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorBoton,
                foregroundColor: colorTexto,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colorBorde,
                    width: 2,
                  ),
                ),
                elevation: 0,
              ),
              child: Text(
                opcion,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _construirPreguntaCompletar(Map<String, dynamic> pregunta) {
    return Column(
      children: [
        TextField(
          controller: _textController,
          enabled: !respuestaVerificada,
          onChanged: (value) {
            setState(() {}); // Actualizar para habilitar el botón
          },
          style: const TextStyle(
            fontSize: 18, 
            color: Colors.black87, // Texto negro visible
          ),
          decoration: InputDecoration(
            hintText: 'Escribe tu respuesta aquí',
            helperText: pregunta['pista'],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  bool _puedeUsarBoton() {
    if (preguntas[preguntaActual]['tipo'] == 'seleccion') {
      return respuestaSeleccionada != null;
    } else {
      return _textController.text.trim().isNotEmpty;
    }
  }

  String _obtenerTextoBoton() {
    if (respuestaVerificada) {
      if (preguntaActual == preguntas.length - 1) {
        return 'TERMINAR';
      } else {
        return 'CONTINUAR';
      }
    } else {
      return 'COMPROBAR';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = preguntas[preguntaActual];
    final progreso = (preguntaActual + 1) / preguntas.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: LinearProgressIndicator(
          value: progreso,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  puntos.toString(),
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contador de pregunta
            Text(
              'Pregunta ${preguntaActual + 1} de ${preguntas.length}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            
            // Pregunta
            Text(
              pregunta['pregunta'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            
            // Opciones o campo de texto
            Expanded(
              child: pregunta['tipo'] == 'seleccion'
                  ? _construirPreguntaSeleccion(pregunta)
                  : _construirPreguntaCompletar(pregunta),
            ),
            
            // Botón de acción
            Container(
              width: double.infinity,
              height: 56,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: _puedeUsarBoton() ? (respuestaVerificada ? continuarSiguientePregunta : verificarRespuesta) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: respuestaVerificada
                      ? (respuestaCorrecta ? const Color(0xFF58CC02) : Colors.orange)
                      : const Color(0xFF58CC02),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  _obtenerTextoBoton(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de lección completada
class LeccionCompletadaScreen extends StatelessWidget {
  final int puntos;

  const LeccionCompletadaScreen({
    super.key,
    required this.puntos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen de celebración
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: AppImages.celebracion
                ),
              
              const SizedBox(height: 40),
              
              // Título
              const Text(
                '¡Terminaste la lección!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Puntos ganados
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '+$puntos puntos',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Mensaje de felicitación
              Text(
                'Excelente trabajo aprendiendo saludos básicos.\n¡Sigue practicando!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              // Botón continuar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navegar de vuelta al home
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF58CC02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'CONTINUAR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}