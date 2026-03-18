import 'package:flutter/material.dart';
import '../models/metric_item.dart';
import '../services/health_service.dart';
import 'nutricion_detail.dart';

class DetailScreen extends StatefulWidget {
  final HealthData data;
  final HealthService healthService;

  const DetailScreen({
    super.key,
    required this.data,
    required this.healthService,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final int metaAguaMl = 2000;

  void agregarAgua() {
    setState(() {
      widget.healthService.agregarAgua(250);
    });
  }

  void quitarAgua() {
    setState(() {
      widget.healthService.quitarAgua(250);
    });
  }

  int get vasosLlenos => (widget.healthService.aguaMl / 250).floor();

  @override
  Widget build(BuildContext context) {
    final bool esAgua = widget.data.titulo == 'Agua';
    final double progresoAgua = widget.healthService.progresoAgua;
    if (widget.data.titulo == 'Nutrición') {
      return NutricionDetail(
        healthService: widget.healthService,
        data: widget.data,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        title: Text(widget.data.titulo),
        backgroundColor: const Color(0xFF0B0F14),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Hero(
          tag: widget.data.tag,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    widget.data.color.withValues(alpha: 0.85),
                    widget.data.color.withValues(alpha: 0.35),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white.withValues(alpha: 0.14),
                      child: Icon(
                        widget.data.icono,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      widget.data.titulo,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (esAgua) ...[
                      Text(
                        '${widget.healthService.aguaMl}',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '/ $metaAguaMl ml',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: progresoAgua,
                          minHeight: 16,
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.data.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '${(progresoAgua * 100).toStringAsFixed(0)}% de hidratación',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Vasos del día',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(8, (index) {
                          final bool lleno = index < vasosLlenos;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: 42,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                              ),
                              color: lleno
                                  ? widget.data.color.withValues(alpha: 0.85)
                                  : Colors.white.withValues(alpha: 0.08),
                            ),
                            child: Icon(
                              Icons.local_drink_outlined,
                              color: lleno
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.35),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: quitarAgua,
                              icon: const Icon(Icons.remove),
                              label: const Text('250 ml'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                                  widget.healthService.aguaMl >= metaAguaMl
                                  ? null
                                  : agregarAgua,
                              icon: const Icon(Icons.add),
                              label: const Text('250 ml'),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        widget.data.valor,
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.data.unidad,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                      if (widget.data.subtitulo != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.data.subtitulo!,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.68),
                          ),
                        ),
                      ],
                      if (widget.data.progreso != null) ...[
                        const SizedBox(height: 28),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: widget.data.progreso,
                            minHeight: 14,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.18,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${(widget.data.progreso! * 100).toStringAsFixed(0)}% de progreso',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
