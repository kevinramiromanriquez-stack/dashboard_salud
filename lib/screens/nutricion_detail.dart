import 'package:flutter/material.dart';
import '../services/health_service.dart';
import '../models/metric_item.dart';

class NutricionDetail extends StatelessWidget {
  final HealthService healthService;
  final HealthData data;

  const NutricionDetail({
    super.key,
    required this.healthService,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        title: const Text('Nutrición'),
        backgroundColor: const Color(0xFF0B0F14),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department_outlined,
                          color: Colors.orange.shade300,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Hoy',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.78),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Text(
                      '${healthService.caloriasConsumidas} / ${healthService.metaCalorias}',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),

                    const SizedBox(height: 28),

                    _buildCaloriesBar(),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_caloriasMinimasEstimadas()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                        Text(
                          '${_caloriasMaximasEstimadas()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 34),

                    Wrap(
                      spacing: 14,
                      runSpacing: 18,
                      children: [
                        SizedBox(
                          width: 210,
                          child: _macroCard(
                            titulo: 'Proteínas',
                            valor: healthService.proteinasConsumidas,
                            meta: healthService.metaProteinas,
                            progreso: healthService.progresoProteinas,
                            color: const Color(0xFFF5C542),
                          ),
                        ),
                        SizedBox(
                          width: 210,
                          child: _macroCard(
                            titulo: 'Carbs',
                            valor: healthService.carbsConsumidos,
                            meta: healthService.metaCarbs,
                            progreso: healthService.progresoCarbs,
                            color: const Color(0xFFFFB84D),
                          ),
                        ),
                        SizedBox(
                          width: 210,
                          child: _macroCard(
                            titulo: 'Grasas',
                            valor: healthService.grasasConsumidas,
                            meta: healthService.metaGrasas,
                            progreso: healthService.progresoGrasas,
                            color: const Color(0xFF60D97B),
                          ),
                        ),
                      ],
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

  Widget _buildCaloriesBar() {
    final progreso = healthService.progresoCalorias.clamp(0.0, 1.0);
    final bool metaCumplida =
        healthService.caloriasConsumidas >= _caloriasMinimasEstimadas() &&
        healthService.caloriasConsumidas <= _caloriasMaximasEstimadas();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progreso,
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: metaCumplida
                      ? const Color(0xFF60D97B)
                      : const Color(0xFFF5C542),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          metaCumplida
              ? 'Dentro del rango recomendado'
              : 'Sigue acercándote a tu meta',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }

  Widget _macroCard({
    required String titulo,
    required int valor,
    required int meta,
    required double progreso,
    required Color color,
  }) {
    final progresoSeguro = progreso.clamp(0.0, 1.0);
    final bool excedido = valor > meta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.82),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          '$valor / $meta g',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progresoSeguro,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.10),
            valueColor: AlwaysStoppedAnimation<Color>(
              excedido ? Colors.redAccent : color,
            ),
          ),
        ),
      ],
    );
  }

  int _caloriasMinimasEstimadas() {
    return (healthService.metaCalorias * 0.90).round();
  }

  int _caloriasMaximasEstimadas() {
    return (healthService.metaCalorias * 1.10).round();
  }
}
