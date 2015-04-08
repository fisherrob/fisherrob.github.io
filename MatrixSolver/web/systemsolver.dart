// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:html';
import 'dart:math';
var numEquation = document.getElementById("equationNum") as SelectElement;
var letters = ['a', 'b', 'c', 'd'];
List<int> minors = new List<int>();
void main() {
  querySelector('#equationNum').onChange.listen(updateSystem);
  querySelector('#submit').onClick.listen(pressSubmit);
}

void pressHere(Event e){
  List<List<int>> matrix = new List<List<int>>();
  for(int i = 0; i < int.parse(numEquation.value); i++){
    List<int> list = new List<int>();
    for(int j = 0; j < int.parse(numEquation.value); j++){
      var coeff = querySelector('#' + letters[i] + (j+1).toString()) as TextInputElement;
      if (coeff.value.length > 0){
        list.add(int.parse(coeff.value));
      }
      else{
        list.add(0);
      }
    }
    var C = querySelector('#C' + (i+1).toString()) as TextInputElement;
    if (C.value.length > 0){
         list.add(int.parse(C.value));
    }
    else{
         list.add(0);
    }
    matrix.add(list);
  }
  cramersRule(matrix);
}

void rowEchelon(List<List<int>> matrix){
  for(int i = 0; i < matrix.length-1; i++){
    for(int j = i+1; j < matrix.length; j++){
      if(matrix[j][i] != 0){
        int index = 0;
        double nonZero = 0.0;
        for(int k = i; k < matrix.length; k++){
          if(matrix[k][i] != 0){
            nonZero = matrix[k][i].toDouble();
            index = k;
            break;
          }
        }
        if(nonZero == 0.0){
          List<int> switchList = new List<int>();
          for(int l = 0; l < matrix[j].length; l++){
            switchList.add(matrix[j][l]);
          }
          for(int m = 0; m < matrix[j].length; m++){
            matrix[i][m] = matrix[j][m];
            matrix[j][m] = switchList[m];
          }
        }
        else{
          nonZero = matrix[j][i].toDouble()/nonZero;
          for(int n = 0; n < matrix[j].length; n++){
            matrix[j][n] -= (matrix[index][n].toDouble() * nonZero).toInt();
          }
        }
      }
    }
  }
  var system = querySelector('#system');
  system.innerHtml = '';
  for(int o = 0; o < matrix.length; o++){
    for(int p = 0; p < matrix[o].length; p++){
      system.appendText(matrix[o][p].toString());
      system.appendText(" ");
    }
    system.appendHtml("<br>");
  }
}

void cramersRule(List<List<int>> matrix){
  double D = findDeterminant(matrix).toDouble();
  if(D!=0){
    var system = querySelector('#system');
    system.innerHtml = '';
    for(int i = 0; i < matrix.length; i++){
      double Dn = 0.0;
      double determinant = 0.0;
      List<List<int>> tempMatrix = new List<List<int>>();
      for(int j = 0; j < matrix.length; j++){
        List<int> list = new List<int>();
        for(int k = 0; k < matrix[j].length; k++){
          if(i == k){
            list.add(matrix[j][matrix[j].length - 1]);
          }
          else{
            list.add(matrix[j][k]);
          }
        }
        tempMatrix.add(list);
      }
      Dn = findDeterminant(tempMatrix).toDouble();
      if(Dn != 0){
        system.appendText("x");
        var subscript = document.createElement("sub");
        subscript.appendText((i+1).toString());
        system.append(subscript);
        determinant = Dn/D;
        system.appendText(" = " + determinant.toString());
        system.appendHtml("<br>");
      }
      else{
        rowEchelon(matrix);
      }
    }
  }
  else{
    rowEchelon(matrix);
  }
}

int findDeterminant(List<List<int>> matrix){
  int currentDeterminant = 0;
  if(matrix.length != 2){
    for(int i = 0; i < matrix.length; i++){
    List<List<int>> newMatrix = new List<List<int>>();
    bool first = true;
      for(int j = 0; j < matrix.length; j++){
        if(i!=j){
          List<int> list = new List<int>();
          for(int k = 0; k < matrix.length-1; k++){
            if(first == true){
              int entry = matrix[i][0] * pow(-1, i) * matrix[j][k+1];
              list.add(entry);
            }
            else{
              list.add(matrix[j][k+1]);
            }
          }
          first = false;
          newMatrix.add(list);
        }
      }
      currentDeterminant += findDeterminant(newMatrix);            
    }
    return currentDeterminant;
  }
  else{
    return ((matrix[0][0]*matrix[1][1]) - (matrix[0][1]*matrix[1][0]));
  }
}

void pressSubmit(Event e){
  if(int.parse(numEquation.value)!=0){
    querySelector('#equationNum').setAttribute("disabled", "true");
    querySelector('#submit').hidden = true;
    formRealSystem(numEquation.value);
    querySelector('#check').hidden = true;
    var here = document.createElement("button"); here.id = "here"; here.text = "here";
    querySelector('#system').appendText("Enter the values of your system then click ");
    querySelector('#system').append(here);
    querySelector('#here').onClick.listen(pressHere);
  }
}

void updateSystem(Event e) {
  if (int.parse(numEquation.value)!= 0){
    querySelector('#equations').hidden = false;
    formSampleSystem(numEquation.value);
    querySelector('#submit').hidden = false;
  }
}

void formSampleSystem(var equations){
  var equationList = querySelector('#system');
  equationList.innerHtml = '';
  for(int i = 1; i <= int.parse(equations); i++){
    var equation = document.createElement("p");
    for(int j = 1; j <= int.parse(equations); j++){
      var subscriptA = document.createElement("sub");
      var subscriptX = document.createElement("sub");
      var subscriptC = document.createElement("sub");
      equation.appendText(letters[i-1]);
      subscriptA.appendText(j.toString());
      equation.append(subscriptA);
      equation.appendText("x");
      subscriptX.appendText(j.toString());
      equation.append(subscriptX);
      if(j < int.parse(equations)){
        equation.appendText(" + ");
      }
      else{
        equation.appendText(" = C");
        subscriptC.appendText(i.toString());
        equation.append(subscriptC);
      }
    }
    equationList.append(equation);
  }
}

void formRealSystem(var equations){
  var equationList = querySelector('#system');
  equationList.innerHtml = '';
  for(int i = 1; i <= int.parse(equations); i++){
    var equation = document.createElement("p");
    for(int j = 1; j <= int.parse(equations); j++){
      var subscriptX = document.createElement("sub");
      var coeff = document.createElement("input"); coeff.type = "text";
        coeff.id = letters[i-1] + j.toString(); coeff.size = 4;
      equation.append(coeff);
      equation.appendText("x");
      subscriptX.appendText(j.toString());
      equation.append(subscriptX);
      if(j < int.parse(equations)){
        equation.appendText(" + ");
      }
      else{
        equation.appendText(" = ");
        var C = document.createElement("input"); C.type = "text"; C.id = "C" + i.toString(); C.size = 3;
        equation.append(C);
      }
    }
    equationList.append(equation);
  }
}
