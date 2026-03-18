import 'package:flutter/material.dart';
import '../models/metric_item.dart';
import '../services/health_service.dart';
import '../widgets/health_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final HealthService healthService = HealthService();

  Color obtenerColorProgreso(double progreso) {
    if (progreso < 0.5) return const Color(0xFF22C55E);
    if (progreso < 0.8) return const Color(0xFFFACC15);
    return const Color(0xFF38BDF8);
  }

  void refrescar() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorPasos = obtenerColorProgreso(healthService.progresoPasos);
    final colorAgua = const Color(0xFF60A5FA);

    final cards = [
      HealthData(
        titulo: 'Nutrición',
        valor:
            '${healthService.caloriasConsumidas} / ${healthService.metaCalorias}',
        unidad: 'kcal',
        icono: Icons.restaurant_menu_outlined,
        color: const Color(0xFFFFB74D),
        subtitulo:
            'P ${healthService.proteinasConsumidas}g • C ${healthService.carbsConsumidos}g • G ${healthService.grasasConsumidas}g',
        progreso: healthService.progresoCalorias,
        tag: 'nutricion_card',
      ),
      HealthData(
        titulo: 'Perfil',
        valor: healthService.imc.toStringAsFixed(1),
        unidad: healthService.obtenerEstadoIMC(),
        icono: Icons.person_outline,
        color: const Color(0xFFEF9A9A),
        subtitulo:
            '${healthService.edad} años • ${healthService.altura.toStringAsFixed(2)} m',
        tag: 'perfil_card',
      ),
      HealthData(
        titulo: 'Agua',
        valor: '${healthService.aguaMl} ml',
        unidad: '',
        icono: Icons.water_drop_outlined,
        color: colorAgua,
        subtitulo:
            '${healthService.resumenVasos}  •  ${healthService.porcentajeAgua}',
        progreso: healthService.progresoAgua,
        tag: 'agua_card',
      ),
      HealthData(
        titulo: 'Pasos',
        valor: healthService.pasos.toString(),
        unidad: 'de ${healthService.metaPasos}',
        icono: Icons.directions_walk_outlined,
        color: colorPasos,
        progreso: healthService.progresoPasos,
        subtitulo: 'Meta diaria',
        tag: 'pasos_card',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard de Salud',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                healthService.actualizarDatos();
              });
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: cards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.69,
          ),
          itemBuilder: (context, index) {
            return HealthCard(
              data: cards[index],
              healthService: healthService,
              onReturnFromDetail: refrescar,
            );
          },
        ),
      ),
    );
  }
}
