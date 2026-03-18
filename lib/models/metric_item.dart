import 'package:flutter/material.dart';

class HealthData {
  final String titulo;
  final String valor;
  final String unidad;
  final IconData icono;
  final Color color;
  final double? progreso;
  final String? subtitulo;
  final String tag;

  HealthData({
    required this.titulo,
    required this.valor,
    required this.unidad,
    required this.icono,
    required this.color,
    required this.tag,
    this.progreso,
    this.subtitulo,
  });
}