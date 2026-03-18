class HealthService {
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

  int pasos = 5057;

  int aguaMl = 1250;
  final int metaAguaMl = 2000;
  final int metaPasos = 6000;

  double get imc => peso / (altura * altura);

  double get progresoCalorias => caloriasConsumidas / metaCalorias > 1
      ? 1
      : caloriasConsumidas / metaCalorias;

  double get progresoProteinas => proteinasConsumidas / metaProteinas > 1
      ? 1
      : proteinasConsumidas / metaProteinas;

  double get progresoCarbs =>
      carbsConsumidos / metaCarbs > 1 ? 1 : carbsConsumidos / metaCarbs;

  double get progresoGrasas =>
      grasasConsumidas / metaGrasas > 1 ? 1 : grasasConsumidas / metaGrasas;

  double get progresoPasos {
    double progreso = pasos / metaPasos;
    return progreso > 1 ? 1 : progreso;
  }

  double get progresoAgua {
    double progreso = aguaMl / metaAguaMl;
    return progreso > 1 ? 1 : progreso;
  }

  int get vasosTomados => (aguaMl / 250).floor();
  String get resumenVasos => '$vasosTomados/8 vasos';
  String get porcentajeAgua =>
      '${(progresoAgua * 100).toStringAsFixed(0)}% hidratación';

  void actualizarDatos() {
    pasos += 320;
    if (aguaMl < metaAguaMl) {
      aguaMl += 250;
      if (aguaMl > metaAguaMl) aguaMl = metaAguaMl;
    }
  }

  void agregarAgua(int cantidad) {
    aguaMl += cantidad;
    if (aguaMl > metaAguaMl) aguaMl = metaAguaMl;
  }

  void quitarAgua(int cantidad) {
    aguaMl -= cantidad;
    if (aguaMl < 0) aguaMl = 0;
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
