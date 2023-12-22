import 'dart:math';
import 'package:args/args.dart';
import 'dart:io';

import 'package:excel/excel.dart';

import 'layer.dart';
import 'neural_Network.dart';
import 'neuron.dart';

double SigmoidFunction(double x) {
  return 1.0 / (1.0 + exp(-x));
}

double dsigmoid(double x) {
  return x * (1 - x);
}

double MeanTimeSquareError(List<Layer> layers, List<double> targets) {
  double error = 0;
  error += 0.5 * pow(targets[0] / 100 - layers[2].neurons[0].value, 2);
  return error;
}

double SumOfProducts(double value, double weight) {
  double total = 0;
  total = value * weight;
  return total;
}

void ForwardPropagtion(List<Layer> layers, List<double> features) {
  for (int y = 0; y < 4; y++) {
    //4
    Neuron neuron = Neuron();
    neuron.value = features[y];
    layers[0].neurons.add(neuron);
    for (int i = 0; i < 4; i++) {
      // 4
      layers[0].neurons[y].weights.add(0.1 + Random().nextDouble() * 0.9);
    }
  }
  for (int i = 1; i < layers.length; i++) {
    for (int j = 0; j < 4; j++) {
      //4
      if (i == 2 && j == 1) {
        break;
      }
      double sum = 0;
      for (int k = 0; k < layers[i - 1].neurons.length; k++) {
        sum += SumOfProducts(layers[i - 1].neurons[k].value,
            layers[i - 1].neurons[k].weights[j]);
      }
      Neuron neuron = Neuron();
      neuron.value = SigmoidFunction(sum);
      layers[i].neurons.add(neuron);
      layers[i].neurons[j].weights.add(0.1 + Random().nextDouble() * 0.9);
    }
  }
  print("actual value:${layers[2].neurons[0].value}");
}

void backpropagation(List<Layer> layers, List<double> targets,double learning_rate) {
  print("target:${(targets[0] / 100)}");
  double deltaY = 0;
  for (int i = 0; i < layers[2].neurons.length; i++) {
    deltaY = dsigmoid(layers[2].neurons[i].value) *
        (targets[i] / 10 - layers[2].neurons[i].value);
  }

  List<double> hiddenLayerError = [];
  for (int i = 0; i < layers[1].neurons.length; i++) {
    double sum = 0;
    for (int j = 0; j < layers[2].neurons.length; j++) {
      sum += deltaY * layers[1].neurons[i].weights[j];
    }
    hiddenLayerError.add(dsigmoid(layers[1].neurons[i].value) * sum);
  }

  for (int i = 0; i < layers[0].neurons.length; i++) {
    for (int j = 0; j < layers[1].neurons.length; j++) {
      layers[0].neurons[i].weights[j] +=
          (learning_rate * hiddenLayerError[j] * layers[0].neurons[i].value);
    }
  }

  for (int i = 0; i < layers[1].neurons.length; i++) {
    for (int j = 0; j < layers[2].neurons.length; j++) {
      layers[1].neurons[i].weights[j] +=
          learning_rate * deltaY * layers[1].neurons[i].value;
    }
  }
}

void main() async {
  var file = 'assets/concrete_data.xlsx';
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  List<double> features = [];
  List<double> nfeatures = [];

  List<double> targets = [0];
  bool firstRow = true;

  for (var table in excel.tables.keys) {
    print('----------------------------------------');
    int len = 525;
    // int i = 0;
    for (int i = 0; i < len; i++) {
      print('----------------------------------------');
      print('test $i');
      if (i == 0) continue;

      var row = excel.tables[table]!.rows[i];
      for (int i = 0; i <= 4; i++) {
        if (i == 4) {
          targets[0] = (double.parse(row[i]!.value.toString()));
          break;
        }
        features.add(double.parse(row[i]!.value.toString()));
      }

      NeuralNetwork neuralNetwork =
          NeuralNetwork(features.length, features.length, targets.length);

      neuralNetwork.train(features, targets);
      print('----------------------------------------');
    }
    for (int i = len; i < 700; i++) {
      print('----------------------------------------');
      print('test $i');
      var row = excel.tables[table]!.rows[i];
      for (int i = 0; i <= 4; i++) {
        if (i == 4) {
          targets.add(double.parse(row[i]!.value.toString()));
          break;
        }
        features.add(double.parse(row[i]!.value.toString()));
      }

      NeuralNetwork neuralNetwork =
          NeuralNetwork(features.length, features.length, targets.length);

      neuralNetwork.testcase(features, targets);
      print('----------------------------------------');
    }

    double testsize = double.parse(stdin.readLineSync().toString());
    for(int i=0;i<testsize;i++){
      double x = double.parse(stdin.readLineSync().toString());
      nfeatures.add(x);
    }
    NeuralNetwork n=NeuralNetwork(nfeatures.length, nfeatures.length,1 );
    n.predict(features);
    print('----------------------------------------');
    // for (var row in excel.tables[table]!.rows) {
    //   List<double> features = [];
    //
    //   List<double> targets = [];
    //
    //   if (firstRow) {
    //     firstRow = false;
    //     continue;
    //   }
    //
    //   for (int i = 0; i <= 4; i++) {
    //     if (i == 4) {
    //       targets.add(double.parse(row[i]!.value.toString()));
    //       break;
    //     }
    //     features.add(double.parse(row[i]!.value.toString()));
    //   }
    //
    //   NeuralNetwork neuralNetwork =
    //       NeuralNetwork(features.length, features.length, targets.length);
    //
    //   neuralNetwork.train(features, targets);
    // }
  }

}
/*  for(int i=0;i<=4;i++){
        if(i==4){
          print(targets[0]);
          break;
        }
        print(features[i]);
      }*/

/* print(double.parse(row[0]!.value.toString()));
      print(double.parse(row[1]!.value.toString()));
      print(double.parse(row[2]!.value.toString()));
      print(double.parse(row[3]!.value.toString()));*/
