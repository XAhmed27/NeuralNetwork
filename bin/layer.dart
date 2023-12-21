import 'neuron.dart';

class Layer{
  late List<Neuron> neurons;
  Layer(int size) {
    neurons.length=size;
  }
}