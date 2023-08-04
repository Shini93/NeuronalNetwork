/************************************
 *KI has inputs, outputs, hiddenLayers, Biass and Weights
 *has only one Brain
 *************************************/
class Brain {
  PrintWriter File;
  Matrix input;
  Matrix output;
  Matrix[] hiddenLayers;
  Matrix[] weights;
  Matrix[] activation;
  Matrix[] bias;
  int sizeInput = 0;
  int sizeOutput = 0;
  int hiddenSize = 0;      //should be less then 2x input and about 2/3 input + output
  float fitness = -1;
  int activationFunctionNumber = 3;
  int outputActivation = 5;
  int maxWeight = 1;
  int minWeight = -1;

  //---------------------------------------------------------------------------
  Brain(int inputs, int outputs, int hiddenlayers, int hiddenSize_) {
    sizeInput = inputs;
    sizeOutput = outputs;
    hiddenSize = hiddenSize_;
    input = new Matrix(inputs, 1);
    hiddenLayers = new Matrix[hiddenlayers];
    weights = new Matrix[hiddenlayers + 1];

    bias = new Matrix[hiddenlayers + 1];
    weights[0] = new Matrix(hiddenSize, inputs);

    for ( int i=1; i < hiddenlayers; i++) {
      weights[i] = new Matrix(hiddenSize, hiddenSize);
      bias[i-1] = new Matrix(hiddenSize, 1);
    }
    bias[bias.length-2] = new Matrix(hiddenSize, 1);
    bias[bias.length-1] = new Matrix(outputs, 1);
    weights[hiddenlayers] = new Matrix(outputs, hiddenSize);
    fillWeights(minWeight, maxWeight);
    fillBias(hiddenSize * (maxWeight - minWeight));

    // activationFunctionNumber = round(random(1, 6))-1;
    //weights[0].printMatrix();
  }

  //void fillActivation(int val){
  //  for(int w = 0; w < weights.length; w++){
  //     for(int x = 0; x < weights[w].row; x++){
  //        for(int y = 0; y < weights[w].column; y++){
  //            activation[w].matrix[x][y] = val;
  //        }
  //     }
  //  }
  //}

  //---------------------------------------------------------------------------
  private void fillBias(float value) {
    for (Matrix b : bias) {
      b.fillMatrixRandom(-value, value);
    }
  }

  //---------------------------------------------------------------------------
  private void fillWeights(float weigh0, float weigh1) {
    for (Matrix w : weights) {
      w.fillMatrixRandom(weigh0, weigh1);
    }
  }

  //---------------------------------------------------------------------------
  void fillWeights() {
    for (Matrix w : weights) {
      w.fillMatrix();
    }
  }

  //---------------------------------------------------------------------------
  void calcOutput() {
    hiddenLayers[0] = scalaMul( weights[0], input); //<>//
    hiddenLayers[0] = addMat(hiddenLayers[0], bias[0]); //<>//
    hiddenLayers[0] = applyActivationFunction(hiddenLayers[0], false); //<>//

    for (int i = 1; i < hiddenLayers.length; i ++) {
      hiddenLayers[i] = scalaMul(weights[i], hiddenLayers[i-1] ); //<>//
      hiddenLayers[i] = addMat(hiddenLayers[i], bias[i]); //<>//
      hiddenLayers[i] = applyActivationFunction(hiddenLayers[i], false); //<>//
    }
    output = scalaMul(weights[weights.length-1], hiddenLayers[hiddenLayers.length-1]);
    output = addMat(output, bias[bias.length-1]);
    output = applyActivationFunction(output, true);
    // output.printMatrix();
  }

  //---------------------------------------------------------------------------
  void updateWeighsRandom(float rand, float value) {
    for (Matrix w : weights) {
      updateMatrixRandom(w, rand, value, minWeight, maxWeight);
    }
  }

  //--------------------------------------------------------------------------
  void mulWeighsAll(float val) {
    for (Matrix w : weights) {
      w = mulMatrixRandom(w, val);
    }
  }

  //--------------------------------------------------------------------------
  void mulBiasAll(float val) {
    for (Matrix b : bias) {
      b = mulMatrixRandom(b, val);
    }
  }

  //---------------------------------------------------------------------------
  void updateBiasRandom(float rand, float value) {
    for (Matrix b : bias) {
      updateMatrixRandom(b, rand, value, -hiddenSize * (maxWeight - minWeight), hiddenSize * (maxWeight - minWeight));
    }
  }

  //---------------------------------------------------------------------------
  void updateMatrixRandom(Matrix m, float rand, float value, float min, float max) {
    for (int r = 0; r < m.row; r++) {
      for ( int c = 0; c < m.column; c++) {
        if ( random(1) < rand) {
          m.matrix[r][c] += random(-value, +value);
          if (m.matrix[r][c] > max)
            m.matrix[r][c] = max;
          else if (m.matrix[r][c] <min)
            m.matrix[r][c] = min;
        }
      }
    }
  }

  //---------------------------------------------------------------------------
  Matrix mulMatrixRandom(Matrix m, float value) {
    Matrix y = new Matrix(m.row, m.column);
    for (int r = 0; r < m.row; r++) {
      for ( int c = 0; c < m.column; c++) {
        y.matrix[r][c] = m.matrix[r][c] * value;
      }
    }

    return y;
  }

  //---------------------------------------------------------------------------
  private Matrix applyActivationFunction(Matrix m, boolean output) {
    if (output == false) {
      for ( int r = 0; r < m.row; r++)
        for ( int c = 0; c < m.column; c++) {
          if (Float.isNaN(m.matrix[r][c])) {
            printBrain();
            println("apply"); //<>//
          }
          m.matrix[r][c] = activateFunction(m.matrix[r][c], activationFunctionNumber); //<>//
        }
    } else {
      for ( int r = 0; r < m.row; r++)
        for ( int c = 0; c < m.column; c++)
          m.matrix[r][c] = activateFunctionOutput(m.matrix[r][c]);
    }
    return m;
  } //<>//

  //---------------------------------------------------------------------------
  private float activateFunction(float input, int nr) { //<>//
    if (Float.isNaN(input)) //<>//
      println("activate");
    if (nr == 0) {
      return max(0, input);
    } else if (nr == 1) {
      return  activateFunctionOutput( input);
    } else if (nr == 2) {
      return min(input, 0);
    } else if (nr == 3) {
      return  math.tanh(input);
    } else if (nr == 4) {
      if (input > 0.5)
        return 1;
      else
        return input;
    } else if (nr == 5) {
      return sigmoid(input);
    } else if (nr == 6) {
      if (input < 0.5)
        return 0;
      else
        return 1;
    } else if(nr == 7){
      if(input < -0.5)
        return -1;
      else if (input > 0.5)
        return 1;
      else
        return input;
    }
    return 0;
  }

  //---------------------------------------------------------------------------
  private float activateFunctionOutput(float input) { //<>//
    if (Float.isNaN(input))
      println("out");
    return activateFunction(input, outputActivation);
  }

  private float sigmoid(float input) {
    float output = 1/(1+exp(-input));
    return output;
  }

  //---------------------------------------------------------------------------
  void printBrain() {
    println("----------------------------------------");
    println("----Weights----");
    for (int i=0; i < weights.length; i++) {
      weights[i].printMatrix();
    }
    println("----Bias----");
    for (int i=0; i < bias.length; i++) {
      bias[i].printMatrix();
    }
  }

  //---------------------------------------------------------------------------
  Brain clone() {
    Brain b2 = new Brain(sizeInput, sizeOutput, hiddenLayers.length, hiddenSize);
    b2.input = input.clone();
    b2.activationFunctionNumber = activationFunctionNumber;
    b2.outputActivation = outputActivation;
    for ( int i=0; i < hiddenLayers.length +1; i++) {
      b2.weights[i] = weights[i].clone();
      b2.bias[i] = bias[i].clone();
    }
    return b2;
  }

  //-------------------------------------------------------------
  void writeBrain() {
    File = createWriter("Brain.txt");
    for (int i = 0; i < hiddenLayers.length + 1; i++) {
      String weight = "";
      for (int r = 0; r < weights[i].row; r++) {
        for (int c = 0; c < weights[i].column; c++) {
          weight += weights[i].matrix[r][c] + ",";
        }
      }
      File.println( weight);
    }
    File.println(";");
    for (int i = 0; i < bias.length; i++) {
      String biass = "";
      for (int r = 0; r < bias[i].row; r++) {
        for (int c = 0; c < bias[i].column; c++) {
          biass += bias[i].matrix[r][c] + ",";
        }
      }
      File.println( biass);
    }
    File.flush(); // Writes the remaining data to the file
    File.close(); // Finishes the file
  }


  //--------------------------------------------------------------
  //void readBrain() {
  //  String[] lines = loadStrings("Brain.txt");
  //  boolean isBias = false;
  //  for (int i = 0; i < lines.length; i++) {
  //    if (isBias == false) {
  //      if (lines[i].contains(";")) {
  //        isBias = !isBias;
  //      } else {
  //        String[] split = split(lines[i], ',');
  //        float[] brain = float(split);
  //        println(i);
  //        dots[0].b.weights[i].fillMatrixArray(brain);
  //      }
  //    } else {
  //      String[] split = split(lines[i], ',');
  //      float[] brain = float(split);

  //      dots[0].b.bias[i-dots[0].b.weights.length-1].fillMatrixArray(brain);
  //    }
  //  }
  //}

  //----------------------------------------------------------------------------
  Brain combineBrains(Brain b1, Brain b2, float offSet) {
    Brain b3 = new Brain(b1.sizeInput, b2.sizeOutput, b1.hiddenLayers.length, b2.hiddenSize);
    for (int w = 0; w < b3.weights.length; w++) {
      for (int r = 0; r < b3.weights[w].row; r++) {
        for (int c = 0; c < b3.weights[w].column; c++) {
          if (random(1) < offSet)
            b3.weights[w].matrix[r][c] =  b1.weights[w].matrix[r][c];
          else
            b3.weights[w].matrix[r][c] =  b2.weights[w].matrix[r][c];
        }
        if (random(1) < offSet)
          b3.bias[w].matrix[r][0] =  b1.bias[w].matrix[r][0];
        else
          b3.bias[w].matrix[r][0] =  b2.bias[w].matrix[r][0];
      }
    }
    return b3;
  }

  //--------------------------------------------------------------
  //need to add bias to it
  void drawKI(Brain b, int widthScreen, int heightScreen) {
    int rowsin = b.sizeInput;
    int columns = 2 + b.hiddenLayers.length;
    PVector distin = new PVector(float(widthScreen/(2*columns)), float(heightScreen/rowsin));
    int offsetYin = round(distin.y/2.0);
    int rowshid = b.hiddenSize;
    PVector disthid = new PVector(float(widthScreen/(columns*(3/2))), float(heightScreen/rowshid));
    int offsetYhid = round(disthid.y/2.0);
    int offsetXhid = widthScreen / columns;
    int rowsout = b.sizeOutput;
    PVector distout = new PVector(float(widthScreen/(2*columns)), float(heightScreen/rowsout));
    int offsetYout = round(distout.y/2.0);
    int offSetXout = width - 20;

    fill(#0000FF);
    for ( int r = 0; r < b.sizeInput; r ++) {
      for (int h = 0; h < b.hiddenSize; h ++) {
        lineColourStrength(b.weights[0].matrix[h][r]);
        line(10, offsetYin + r*distin.y, 1*disthid.x * 1.5, offsetYhid + h*disthid.y);
      }

      ellipse(10, offsetYin + r*distin.y, 20, 20);        //node
    }

    //Hidden Layers
    stroke(#00FF00);
    for ( int h = 0; h < b.hiddenLayers.length; h ++) {
      for ( int r = 0; r < b.hiddenSize; r ++) {
        if (h < b.hiddenLayers.length - 1) {
          for (int k = 0; k < b.hiddenSize; k ++) {
            lineColourStrength(b.weights[h+1].matrix[k][r]);
            line(1*disthid.x * (h + 1.5), offsetYhid + r*disthid.y, 1*disthid.x * ((h+1) + 1.5), offsetYhid + k*disthid.y);
          }
        } else {  //output
          for (int k = 0; k < b.sizeOutput; k ++) {
            lineColourStrength(b.weights[b.weights.length-1].matrix[k][r]);
            line(1*disthid.x * (h + 1.5), offsetYhid + r*disthid.y, offSetXout, offsetYout + k*distout.y);
          }
        }
        if (b.bias[h].matrix[r][0] > 0)
          fill(#00FF00);
        else if (b.bias[h].matrix[r][0] <0)
          fill(#009900);
        else
          fill(#00CC00);
        ellipse(1*disthid.x * (h + 1.5), offsetYhid + r*disthid.y, 20, 20);
      }
    }
    //outputs
    for ( int r = 0; r < b.sizeOutput; r ++) {
      if (b.bias[b.bias.length-1].matrix[r][0] > 0)
        fill(#FF0000);
      else if (b.bias[b.bias.length-1].matrix[r][0] <0)
        fill(#990000);
      else
        fill(#CC0000);
      ellipse(offSetXout, offsetYout + r*distout.y, 20, 20);
    }
    stroke(0);
  }

  private void lineColourStrength(float value) {
    if ( value >= 0)
      stroke(0);
    else
      stroke(#DD3333);
    strokeWeight(sqrt(abs(value)));
  }

  //--------------------------------------------------------------
  void drawKI() {
    drawKI(this, width, height);
  }

  //--------------------------------------------------------------
  //Changes all input related matrixs
  //Does not change any other size related matrixs
  void resizeBrainInputs(int inputs) {

    int oldInputs = sizeInput;
    sizeInput = inputs;
    input = new Matrix(inputs, 1);
    weights[0] = changeColumns(weights[0], inputs);
  }

  //--------------------------------------------------------------
  //Changes all output related matrixs
  //Does not change any other size related matrixs
  void resizeBrainOutputs(int outputs) {
    sizeOutput = outputs;
    output = new Matrix(outputs, 1);

    bias[bias.length-1] =changeRows(bias[bias.length-1], outputs);
    weights[weights.length - 1] = changeRows(weights[weights.length - 1], outputs);
  }

  //--------------------------------------------------------------
  //Changes all HiddenSize related matrixs
  //Does not change any other size related matrixs
  void resizeHiddenSize(int hiddenS) {

    weights[0] = changeRows(weights[0], hiddenS);
    for ( int i=1; i < hiddenLayers.length; i++) {
      weights[i] = changeRowColumn(weights[i], hiddenS, hiddenS);
      bias[i-1] = changeRows(bias[i-1], hiddenS);
    }
    bias[bias.length-2] = changeRows(bias[bias.length-2], hiddenS);
    weights[hiddenLayers.length] = changeColumns(weights[hiddenLayers.length], hiddenS);

    hiddenSize = hiddenS;
  }

  void resizeHiddenLayers(int hiddenL) {
    if (hiddenL == hiddenLayers.length)
      return;
    //adds or deletes hiddenLayers as a whole
    int minSize = min(hiddenL, hiddenLayers.length);
    int formerLength = hiddenLayers.length;

    hiddenLayers = new Matrix[hiddenL];
    Matrix[] dummyWeights = new Matrix[hiddenL + 1];
    Matrix[] dummyBias = new Matrix[hiddenL + 1];

    //init length of former Layer size
    for (int i=0; i <= minSize; i++) {
      dummyWeights[i] = weights[i].clone();
      dummyBias[i] = bias[i].clone();
    }

    //fill weights as before
    dummyWeights[hiddenL] = weights[formerLength].clone();
    dummyWeights[hiddenL-1] = new Matrix(hiddenSize, hiddenSize);

    //last weight are the outputs, need to stay last
    //secondlast layer is the new layer, needs to be empty with diagonal 1s
    dummyWeights[hiddenL-1].fillMatrix(0);
    dummyWeights[hiddenL-1].fillDiagonal(1);
    weights = dummyWeights.clone();

    //Bias
    dummyBias[formerLength] = bias[formerLength-1].clone();
    dummyBias[formerLength].fillMatrix(0);
    dummyBias[hiddenL] = bias[formerLength].clone();

    bias = dummyBias;
  }

  //--------------------------------------------------------------
  //Changes all output related matrixs
  //Does not change any other size related matrixs
  void resizeBrainSize(int inputs, int outputs, int hiddenL, int hiddenS) {
    resizeHiddenSize(hiddenS);        //funzt
    resizeHiddenLayers(hiddenL);
    resizeBrainInputs(inputs);
    resizeBrainOutputs(outputs);
  }
}
