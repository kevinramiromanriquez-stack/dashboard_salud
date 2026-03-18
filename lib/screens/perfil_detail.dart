import 'package:flutter/material.dart';
import '../services/health_service.dart';
import '../models/metric_item.dart';

class PerfilDetail extends StatefulWidget {
  final HealthService healthService;
  final HealthData data;

  const PerfilDetail({
    super.key,
    required this.healthService,
    required this.data,
  });

  @override
  State<PerfilDetail> createState() => _PerfilDetailState();
}

class _PerfilDetailState extends State<PerfilDetail> {
  late TextEditingController edadController;
  late TextEditingController pesoController;
  late TextEditingController alturaController;

  @override
  void initState() {
    super.initState();

    edadController = TextEditingController(
      text: widget.healthService.edad.toString(),
    );
    pesoController = TextEditingController(
      text: widget.healthService.peso.toString(),
    );
    alturaController = TextEditingController(
      text: widget.healthService.altura.toString(),
    );
  }

  void guardar() {
    final edad = int.tryParse(edadController.text) ?? widget.healthService.edad;
    final peso =
        double.tryParse(pesoController.text) ?? widget.healthService.peso;
    final altura =
        double.tryParse(alturaController.text) ?? widget.healthService.altura;

    setState(() {
      widget.healthService.actualizarPerfil(
        edad: edad,
        peso: peso,
        altura: altura,
      );
    });

    Navigator.pop(context, true);
  }

  Widget input({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imc = widget.healthService.imc;
    final estado = widget.healthService.obtenerEstadoIMC();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF0B0F14),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Hero(
                tag: widget.data.tag,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFF12151C),
                    ),
                    child: Column(
                      children: [
                        Text(
                          imc.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          estado,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              input(label: 'Edad', controller: edadController),
              const SizedBox(height: 15),
              input(label: 'Peso (kg)', controller: pesoController),
              const SizedBox(height: 15),
              input(label: 'Altura (m)', controller: alturaController),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
