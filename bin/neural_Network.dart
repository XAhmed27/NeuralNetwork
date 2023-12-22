import 'layer.dart';
import 'untitled1.dart';

class NeuralNetwork {
  late List<Layer> layers;
  int epochs = 1;
  double learning_rate = 0.3;

  NeuralNetwork(int inputs, int hidden, int outputs) {
    layers = [
      Layer(inputs),
      Layer(hidden),
      Layer(outputs),
    ];
  }

  void train(List<double> features, List<double> targets) {

    for(int i=0;i<epochs;i++){
      ForwardPropagtion(layers, features);
      backpropagation(layers, targets,learning_rate);
    }
    double error = MeanTimeSquareError(layers, targets);
    print("test error : $error");
  }

  double predict(List<double> features) {
    ForwardPropagtion(layers, features);
    return layers[2].neurons[0].value;
  }

  double testcase(List<double> features, List<double> targets) {
    ForwardPropagtion(layers, features);
    double error = MeanTimeSquareError(layers, targets);
    print("test error : $error");
    return error;
  }
}
