import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  final Health health = Health();
  bool _configurado = false;

  Future<void> _asegurarConfiguracion() async {
    if (_configurado) return;
    await health.configure();
    _configurado = true;
  }

  double peso = 78.4;
  double altura = 1.80;
  int edad = 25;
  String sexo = 'Masculino';

  int caloriasConsumidas = 0;
  int metaCalorias = 1957;

  int proteinasConsumidas = 0;
  int metaProteinas = 166;

  int carbsConsumidos = 0;
  int metaCarbs = 177;

  int grasasConsumidas = 0;
  int metaGrasas = 65;

  int pasos = 0;
  int aguaMl = 0;

  final int metaAguaMl = 2000;
  final int metaPasos = 6000;

  List<int> pasosPorHora = [
    0,
    0,
    0,
    0,
    20,
    0,
    40,
    120,
    280,
    350,
    410,
    300,
    260,
    180,
    90,
    70,
    130,
    220,
    540,
    620,
    430,
    300,
    120,
    80,
  ];

  Future<int> obtenerPasosHoy() async {
    await _asegurarConfiguracion();
    final permisoActividad = await Permission.activityRecognition.request();

    if (!permisoActividad.isGranted) {
      debugPrint('Permiso de actividad no concedido');
      return 0;
    }

    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];

    final now = DateTime.now();
    final inicioDia = DateTime(now.year, now.month, now.day);

    try {
      final autorizado = await health.requestAuthorization(
        types,
        permissions: permissions,
      );

      debugPrint('Autorizado Health Connect: $autorizado');

      if (!autorizado) {
        return 0;
      }

      final pasosTotales = await health.getTotalStepsInInterval(inicioDia, now);
      debugPrint('Pasos obtenidos: $pasosTotales');

      return pasosTotales ?? 0;
    } catch (e) {
      debugPrint('Error leyendo pasos: $e');
      return 0;
    }
  }

  Future<void> sincronizarPasosReales() async {
    pasos = await obtenerPasosHoy();
  }

  double get imc => peso / (altura * altura);

  double get progresoCalorias {
    final progreso = caloriasConsumidas / metaCalorias;
    return progreso > 1 ? 1 : progreso;
  }

  double get progresoProteinas {
    final progreso = proteinasConsumidas / metaProteinas;
    return progreso > 1 ? 1 : progreso;
  }

  double get progresoCarbs {
    final progreso = carbsConsumidos / metaCarbs;
    return progreso > 1 ? 1 : progreso;
  }

  double get progresoGrasas {
    final progreso = grasasConsumidas / metaGrasas;
    return progreso > 1 ? 1 : progreso;
  }

  double get progresoPasos {
    final progreso = pasos / metaPasos;
    return progreso > 1 ? 1 : progreso;
  }

  double get progresoAgua {
    final progreso = aguaMl / metaAguaMl;
    return progreso > 1 ? 1 : progreso;
  }

  int get vasosTomados {
    final vasos = (aguaMl / 250).floor();
    return vasos > 8 ? 8 : vasos;
  }

  String get resumenVasos => '$vasosTomados/8 vasos';

  String get porcentajeAgua =>
      '${(progresoAgua * 100).toStringAsFixed(0)}% hidratación';

  double get distanciaKm => pasos * 0.00075;

  int get caloriasPasos => (pasos * 0.04).round();

  int get pisosSubidos => (pasos / 2500).floor();

  void actualizarDatos() {
    if (aguaMl < metaAguaMl) {
      aguaMl += 250;
      if (aguaMl > metaAguaMl) {
        aguaMl = metaAguaMl;
      }
    }
  }

  void actualizarPerfil({
    required int edad,
    required double peso,
    required double altura,
  }) {
    this.edad = edad;
    this.peso = peso;
    this.altura = altura;
  }

  void agregarAgua(int cantidad) {
    aguaMl += cantidad;
    if (aguaMl > metaAguaMl) {
      aguaMl = metaAguaMl;
    }
  }

  void quitarAgua(int cantidad) {
    aguaMl -= cantidad;
    if (aguaMl < 0) {
      aguaMl = 0;
    }
  }

  void agregarAlimento({
    required int calorias,
    required int proteinas,
    required int carbs,
    required int grasas,
  }) {
    caloriasConsumidas += calorias;
    proteinasConsumidas += proteinas;
    carbsConsumidos += carbs;
    grasasConsumidas += grasas;
  }

  void reiniciarNutricion() {
    caloriasConsumidas = 0;
    proteinasConsumidas = 0;
    carbsConsumidos = 0;
    grasasConsumidas = 0;
  }

  String obtenerEstadoIMC() {
    if (imc < 18.5) return 'Bajo peso';
    if (imc < 25) return 'Normal';
    if (imc < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  String obtenerSubtituloAgua() {
    return '$aguaMl / $metaAguaMl ml';
  }
}