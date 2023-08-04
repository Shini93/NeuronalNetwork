class aiHandlerr { //<>// //<>// //<>// //<>//
  int maxBrains = 400;
  Brain[] b = new Brain[ maxBrains ];
  Brain allTimeBest;
  Brain bestRun;
  int Layer =1;
  int size = 40;
  float bestAcc = 0;
  int best = 0;
  int noChange = 0;
  int maxWeights = 1;
  int maxBias = size * 2 * maxWeights;
  float change = 5;
  int input = 2;
  int output = 3;

  aiHandlerr() {
    for (int i = 0; i < maxBrains; i++) {
      b[i] = new Brain(input, output, Layer, size);
      b[i].maxWeight = maxWeights;
      b[i].minWeight = -maxWeights;
    }
    allTimeBest = b[0].clone();
    bestRun = b[0].clone();
  }

  void drawBrain() {
    allTimeBest.drawKI();
  }

  //----------------------------------------------------------------------------------
  float testAI() {
    float cost = 0;
    float bCost = 9999999;
    //test all brains
    best = 0;
    for (int k = 0; k < maxBrains; k++) {
      cost = 0;
      //test all data perbrain
      for (int i = 0; i < dataHandler.dataSize; i++) {
        cost += testData(k, i);
      }
      if (cost <= bCost) {
        bCost = cost;
        best = k;
      }
    }
    bestRun = b[best].clone();
    return bCost;
  }
  //----------------------------------------------------------------------------------

  void runAI() {
    float cost = testAI();
    //if (random(1) < 0.01)
    //  adjustBestInRun(cost);
    testVsBest();

    //if(noChange >= 200 || random(1) < 0.001){
    //  noChange = 0;
    //  size++;
    //  allTimeBest.resizeBrainSize(2,2,Layer,size);
    //  bestRun.resizeBrainSize(2,2,Layer,size);
    //  println(size);
    //}

    resetBrains();
    //testDraw();
    dataHandler.drawData();
    drawdecisionBorder();
  }

  void resetBrains() {
    for (int i = 0; i < maxBrains; i++) {
      if (random(1) < 0.5)
        b[i] = allTimeBest.clone();
      else
      b[i] = bestRun.clone();

      //if (random(1) < 0.3) {
      //  //change activation function
      //  // b[i].activationFunctionNumber = round(random(1, 6))-1;
      //}

      float ran = random(1);
      //change everything a little
      if (ran < 0.1) {
        b[i].updateWeighsRandom(1, change * 0.01 * maxWeights);
        b[i].updateBiasRandom(1, change * 0.001 * maxBias);
      } else if (ran < 0.5) {
        //change everything much more
        b[i].updateWeighsRandom(1, change * 0.1 * maxWeights);
        b[i].updateBiasRandom(1, change * 0.01 * maxBias);
      } else if (ran < 0.9) {
        //change a bit a lot
        b[i].updateWeighsRandom(0.05, change * 0.1 * maxWeights);
        b[i].updateBiasRandom(0.05, change * 0.01 * maxBias);
      } else {
        //change a bit a little
        b[i].updateWeighsRandom(0.05, change * 0.01 * maxWeights);
        b[i].updateBiasRandom(0.05, change * 0.001 * maxBias);
      }
    }
    //if (bestCost > 11 && random(1) < 0.05) {
    //  allTimeBest.updateWeighsRandom(0.1, 0.0001 * bestCost);
    //  allTimeBest.updateBiasRandom(0.1, 0.001 * bestCost);
    //  bestCost = testData(allTimeBest);
    //}
  }


  //finds best brain ever
  void testVsBest() {
    float costBest = 999999;
    float costNew = 99999;
    costBest = testData(allTimeBest);
    costNew = testData(bestRun);

    noChange++;

    if (costNew <= costBest) {
      Brain oldBest = allTimeBest.clone();
      allTimeBest = bestRun.clone();
      bestCost = costNew;
      noChange = 0;
      allTimeBest = updateBest(oldBest, allTimeBest);
    }
  }

  Brain updateBest(Brain oldBest, Brain allTimeBest) {
    Matrix[] wDiff = oldBest.weights.clone();
    Matrix[] bDiff = oldBest.bias.clone();
    Brain newBest = allTimeBest.clone();

    //find diff matrixes
    for (int w = 0; w < oldBest.weights.length; w++) {
      wDiff[w] = subMat(allTimeBest.weights[w], oldBest.weights[w]);
    }
    for (int b = 0; b < oldBest.bias.length; b++) {
      bDiff[b] = subMat(allTimeBest.bias[b], oldBest.bias[b]);
    }

    float startmul = 10;
    float multiplyer = startmul;
    int times = 30;
    int timesRandom = 20;

    //apply diff matrixes to best and see if its better then before.
    for (int i = 0; i < times; i++) {
      for (int w = 0; w < oldBest.weights.length; w++) {
        Matrix wDum = wDiff[w].clone();
        wDum.mul(multiplyer);
        if (i < timesRandom)
          wDum.mulRandom(0, 0.9);      //parameter gets multiplied by zero with 70% chance.
        newBest.weights[w] = addMat(wDum, newBest.weights[w]);
      }
      for (int b = 0; b < oldBest.bias.length; b++) {
        Matrix bDum = bDiff[b].clone();
        bDum.mul(multiplyer);
        if (i < timesRandom)
          bDum.mulRandom(0, 0.9);      //parameter gets multiplied by zero with 70% chance.
        newBest.bias[b] = addMat(bDum, newBest.bias[b]);
      }
      if (testData(newBest) < bestCost) {
        allTimeBest = newBest.clone();
      } else {
        newBest = allTimeBest.clone();
      }
      multiplyer *= 0.5;
      if (i== timesRandom - 1)
        multiplyer = startmul;
    }

    return newBest;
  }

  void drawdecisionBorder() {
    noStroke();
    float abstand = 1;

    for (float i = 0; i < 100; i+= abstand) {
      for (float k = 0; k < 20; k+= abstand) {
        allTimeBest.input.matrix[0][0] =   i;
        allTimeBest.input.matrix[1][0] =   k;

        allTimeBest.calcOutput();
        int red = round(255 * allTimeBest.output.matrix[0][0]);
        int green = round(255 * allTimeBest.output.matrix[1][0]);
        int blue = round(255 * allTimeBest.output.matrix[2][0]);
        fill(color(red, green, blue), 100);
        rect(i * width * 0.01, k * height *0.05, width * 0.01 * abstand, height * 0.05 * abstand);
      }
    }
  }

  float testData(int bi, int i) {
    float cost = 0;
    b[bi].input.matrix[0][0] =  dataHandler.data[i][0];
    b[bi].input.matrix[1][0] =  dataHandler.data[i][1];
    b[bi].calcOutput();

    cost += findCost(i, b[bi]);

    //drawprobability( b.input.matrix[0][0], b.input.matrix[1][0], b.output.matrix[0][0], dataHandler.data[i][2]);

    return cost;
  }

  float findCost(int i, Brain b) {
    float cost = 0;
    if (dataHandler.data[i][2] == 0) {
      cost += abs(b.output.matrix[0][0] - 1) + b.output.matrix[1][0] + b.output.matrix[2][0];
    } else if(dataHandler.data[i][2] == 1) {
      cost += abs(b.output.matrix[1][0] - 1) + b.output.matrix[0][0] + b.output.matrix[2][0];
    } else{
      cost += abs(b.output.matrix[2][0] - 1) + b.output.matrix[0][0] + b.output.matrix[1][0];
    }
    return cost;
  }

  float testData(Brain b) {
    float cost = 0;
    for (int i = 0; i < dataHandler.dataSize; i++) {
      b.input.matrix[0][0] =  dataHandler.data[i][0];
      b.input.matrix[1][0] =  dataHandler.data[i][1];
      b.calcOutput();
      cost += findCost(i, b);
    }
    return cost;
  }

  void drawprobability(float in0, float in1, float out0, float needs) {
    color bg = #FF0000;
    noStroke();
    if (needs == 0 && out0 > 0.5 )
      bg = #00FF00;
    fill(bg, 30);
    ellipse(in0 * 0.01 * width, in1 * 0.05 * height, 100, 100);
  }

  //void testDraw() {
  //  //find all weight matrixes
  //  // ai.b.printBrain();
  //  int i = 0;
  //  for (int w = 0; w < ai.b.weights.length; w++) {
  //    //find all 1.
  //    for (int x = 0; x < ai.b.weights[w].matrix.length; x++) {
  //      //find all y
  //      for (int y = 0; y < ai.b.weights[w].matrix[x].length; y++) {
  //        ai.b.weights[w].matrix[x][y] = 2 * sliders.sliders.get(i).getPosCalc() - 1;
  //        i++;
  //      }
  //    }
  //  }

  //  for (int b = 0; b < ai.b.bias.length; b++) {
  //    //find all 1.
  //    for (int x = 0; x < ai.b.bias[b].matrix.length; x++) {
  //      //find all y
  //      for (int y = 0; y < ai.b.bias[b].matrix[x].length; y++) {
  //        ai.b.bias[b].matrix[x][y] = 2 * sliders.sliders.get(i).getPosCalc() - 1;
  //        i++;
  //      }
  //    }
  //  }
  //  ai.b.printBrain();

  //  ai.testAI();
  //}
}
