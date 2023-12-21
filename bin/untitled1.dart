import 'dart:math';
import 'package:args/args.dart';
import 'dart:io';

import 'package:excel/excel.dart';

import 'layer.dart';
import 'neural_Network.dart';

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
  for (int i = 1; i < layers.length; i++) {
    for (int j = 0; j < layers[i].neurons.length; j++) {
      double sum=0;
      for (int k = 0; k < layers[i - 1].neurons.length; k++) {
        sum += layers[i - 1].neurons[k].values[k] * layers[i-1].neurons[k].weights[j];
      }
      layers[i].neurons[j].values[j] = SigmoidFunction(sum);
    }
  }
}

void BackwardPropagation(List<Layer> layers, List<double> targets, double learning_rate) {

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
      NeuralNetwork(features.length,features.length,targets.length);

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
