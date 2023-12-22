import 'layer.dart';
import 'untitled1.dart';

class NeuralNetwork {
  late List<Layer> layers;
  int epochs = 3;
  static const learning_rate = 0.3;

  NeuralNetwork(int inputs, int hidden, int outputs) {
    layers = [
      Layer(inputs),
      Layer(hidden),
      Layer(outputs),
    ];
  }

  void train(List<double>features, List<double>targets) {
      ForwardPropagtion(layers, features);
      backpropagation(layers, targets);

  }


}
