import 'package:flutter/material.dart';
import '../models/metric_item.dart';
import '../screens/detail_screen.dart';
import '../services/health_service.dart';
import '../screens/perfil_detail.dart';
class HealthCard extends StatelessWidget {
  final HealthData data;
  final HealthService healthService;
  final VoidCallback? onReturnFromDetail;

  const HealthCard({
    super.key,
    required this.data,
    required this.healthService,
    this.onReturnFromDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: data.tag,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () async {
            // 👉 Caso especial: Perfil
            if (data.titulo == 'Perfil') {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PerfilDetail(healthService: healthService, data: data),
                ),
              );

              if (result == true) {
                onReturnFromDetail?.call();
              }

              return; // 🔥 IMPORTANTE: evita que siga al DetailScreen
            }

            // 👉 Flujo normal para las demás tarjetas
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    DetailScreen(data: data, healthService: healthService),
              ),
            );

            onReturnFromDetail?.call();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF18202A), Color(0xFF121820)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  spreadRadius: 1,
                  color: data.color.withValues(alpha: 0.08),
                ),
              ],
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  child: Icon(data.icono, size: 26, color: Colors.white),
                ),
                const Spacer(),
                Text(
                  data.titulo,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.valor,
                  style: TextStyle(
                    fontSize: data.titulo == 'Nutrición' ? 22 : 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                if (data.unidad.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    data.unidad,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
                if (data.subtitulo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    data.subtitulo!,
                    style: TextStyle(
                      fontSize: data.titulo == 'Nutrición' ? 10 : 11,
                      color: Colors.white.withValues(alpha: 0.58),
                    ),
                  ),
                ],

                // Mini vasos solo para Agua
                if (data.titulo == 'Agua' && data.progreso != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(8, (index) {
                      final llenos = ((data.progreso! * 8).floor()).clamp(0, 8);
                      final lleno = index < llenos;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 10,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1,
                          ),
                          color: lleno
                              ? data.color.withValues(alpha: 0.9)
                              : Colors.white.withValues(alpha: 0.08),
                        ),
                      );
                    }),
                  ),
                ],

                // Barra solo para métricas que NO sean Agua
                if (data.progreso != null && data.titulo != 'Agua') ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: data.progreso,
                      minHeight: 9,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(data.color),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(data.progreso! * 100).toStringAsFixed(0)}% completado',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
