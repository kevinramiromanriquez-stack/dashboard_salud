import 'package:flutter/material.dart';
import '../models/metric_item.dart';
import '../services/health_service.dart';

class PasosDetail extends StatelessWidget {
  final HealthService healthService;
  final HealthData data;

  const PasosDetail({
    super.key,
    required this.healthService,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final pasos = healthService.pasos;
    final meta = healthService.metaPasos;
    final progreso = healthService.progresoPasos.clamp(0.0, 1.0);
    final maxValor = healthService.pasosPorHora.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        title: const Text('Pasos'),
        backgroundColor: const Color(0xFF0B0F14),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Hero(
            tag: data.tag,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF12151C), Color(0xFF0E1117)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 1,
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen del día',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 22),

                    Center(
                      child: Column(
                        children: [
                          Text(
                            '$pasos',
                            style: const TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'pasos',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: LinearProgressIndicator(
                        value: progreso,
                        minHeight: 18,
                        backgroundColor: Colors.white.withValues(alpha: 0.10),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF22C55E),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                        Text(
                          'Objetivo: $meta',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: _datoExtra(
                            '${healthService.distanciaKm.toStringAsFixed(2)} km',
                            'Distancia',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _datoExtra(
                            '${healthService.caloriasPasos} kcal',
                            'Calorías',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _datoExtra(
                            '${healthService.pisosSubidos}',
                            'Pisos',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Pasos por hora del día',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 230,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(24, (index) {
                          final valor = healthService.pasosPorHora[index];
                          final horaActual = DateTime.now().hour;
                          final esActual = index == horaActual;

                          final altura = maxValor == 0
                              ? 6.0
                              : (valor / maxValor) * 150 + 6;

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                    width: 8,
                                    height: altura,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: esActual
                                          ? const Color(0xFF38BDF8)
                                          : const Color(0xFF22C55E),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    index % 6 == 0 ? '${index}h' : '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white.withValues(
                                        alpha: 0.58,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _datoExtra(String valor, String titulo) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.62),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
