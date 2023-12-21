import 'dart:math';

class Neuron{
  late List<double>weights;
  late List<double>values;
  Neuron(double v) {
    values.add(v);
    weights.add( 0.1 + Random().nextDouble() * 0.9);
  }
}