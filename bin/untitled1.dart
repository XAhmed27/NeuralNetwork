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

double MeanTimeSquareError(List<double> targets, List<double> outputs) {
  double sum = 0;
  for (int i = 0; i < targets.length; i++) {
    sum += 0.5* pow(targets[i] - outputs[i], 2);
  }
  return sum;
}

double SumOfProducts(double value,double weight) {
  double total = 0;
  total=value*weight;
  return total;
}
void ForwardPropagtion(List<Layer> layers, List<double> features) {
  for(int y=0;y<4;y++){
    Neuron neuron=Neuron();
    neuron.value=features[y];
    layers[0].neurons.add(neuron);
    for(int i=0;i<4;i++){
      layers[0].neurons[y].weights.add(0.1 + Random().nextDouble() * 0.9);
    }
  }
  for (int i = 1; i < layers.length; i++) {
    for (int j = 0; j < 4; j++) {
      double sum=0;
      for (int k = 0; k < layers[i - 1].neurons.length; k++) {
        sum +=SumOfProducts(layers[i - 1].neurons[k].value,layers[i-1].neurons[k].weights[j]);
      }
      Neuron neuron=Neuron();
      neuron.value=SigmoidFunction(sum);
      layers[i].neurons.add(neuron);
      layers[1].neurons[j].weights.add(0.1 + Random().nextDouble() * 0.9);

    }
  }
}

void backpropagation(List<Layer> layers,List<double> targets) {

  double deltaY=0;
  for (int i = 0; i < layers[2].neurons.length; i++) {
    deltaY=dsigmoid(layers[2].neurons[i].value) * (targets[i] - layers[2].neurons.first.value);
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
      layers[0].neurons[i].weights[j] += 0.5 * hiddenLayerError[j] * layers[0].neurons[i].value;
    }

  }

  for (int i = 0; i < layers[1].neurons.length; i++) {
    for (int j = 0; j < layers[2].neurons.length; j++) {
      layers[1].neurons[i].weights[j] += 0.5 * deltaY * layers[1].neurons[i].value;
    }

  }
}

void main() async {
  var file = 'assets/concrete_data.xlsx';
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  List<double> features = [];
  List<double> targets = [];
  bool firstRow = true;

  for (var table in excel.tables.keys) {

    for (var row in excel.tables[table]!.rows) {
      if (firstRow) {
        firstRow = false;
        continue;
      }
      for(int i=0;i<=4;i++){
        if(i==4){
          targets.add(double.parse(row[i]!.value.toString()));
          break;
        }
        features.add(double.parse(row[i]!.value.toString()));
      }
      NeuralNetwork neuralNetwork=NeuralNetwork(features.length,features.length,targets.length);
      /*neuralNetwork.layers[0].neurons[0].value=features[0];
      neuralNetwork.layers[0].neurons[1].value=features[1];
      neuralNetwork.layers[0].neurons[2].value=features[2];
      neuralNetwork.layers[0].neurons[3].value=features[3];*/




      neuralNetwork.train(features, targets);
        for(int j=0;j<neuralNetwork.layers[1].neurons.length;j++){
          print(neuralNetwork.layers[1].neurons[j].value);
      }
    }
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
