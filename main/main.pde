// unterschied zwischen bestrun und vorherigem besten anschauen
// wenn es besser ist die stellen der matrix weiter ändern für die nächste runde


//--------------------------------
//nicht nach jeder iteration lünchen. Mehrere Goals nacheinander erstellen, die fitness über alle goals erstellen und danach aussuchen und neu erstellen!!!
//BIAS hinzufügen (für jeden Node in den hiden layers, vor der activation function + ausgang
//Zeitlimit stetig verkürzen möglich machen
//Grafik für savedDot Brain möglich machen (per mausklick switchen, oder als bild nebendran erstellen)
//saven von allen Dots in datei zum wiedererstellen (dass man mehr als eine session haben kann)

//-------------------------------
SliderHandler sliders;
float percAcc = 0;
float bestCost = 999999;
int gen = 0;
Math math = new Math();
//PWindow window = new PWindow();
DataHandler dataHandler = new DataHandler();
aiHandlerr ai = new aiHandlerr();

//void setupSliders() {
//  sliders = new SliderHandler();

//  //weight sliders
//  for (int w = 0; w < ai.b.weights.length; w++) {
//    //find all 1.
//    for (int x = 0; x < ai.b.weights[w].matrix.length; x++) {
//      //find all y
//      for (int y = 0; y < ai.b.weights[w].matrix[x].length; y++) {
//        //ai.b.weights[w].matrix[x][y] = 2 * sliders.sliders.get( w * (x * (ai.b.weights[w].matrix[x].length - 1) + y) ).getPosCalc() - 1;
//        sliders.addSlider();
//        sliders.sliders.get(sliders.sliders.size()-1).name = "weight "+ w + "["+x+"]["+y+"]";
//      }
//    }
//  }

//  //bias sliders
//  for (int b = 0; b < ai.b.bias.length; b++) {
//    //find all 1.
//    for (int x = 0; x < ai.b.bias[b].matrix.length; x++) {
//      //find all y
//      for (int y = 0; y < ai.b.bias[b].matrix[x].length; y++) {
//        //ai.b.weights[w].matrix[x][y] = 2 * sliders.sliders.get( w * (x * (ai.b.weights[w].matrix[x].length - 1) + y) ).getPosCalc() - 1;
//        sliders.addSlider();
//        sliders.sliders.get(sliders.sliders.size()-1).name = "bias "+ b + "["+x+"]["+y+"]";
//      }
//    }
//  }
//}

void setup() {
  size(800, 800);
  frameRate(9999);
  //setupSliders();
}

void draw() {

  float time = millis();
  background(125);
//  if (percAcc < 0.999)
    ai.runAI();
    
  //else {
  //  dataHandler.drawData();
  //  noLoop();
  //}
  fill(0);
  textSize(30);
  text(time, 50, 50);
  text(100 * ( 1 -bestCost / (2 * dataHandler.dataSize)), 50, 100);
  text("generation :"+gen, 50, 150);
  text("Hidden Layer: "+ai.Layer, 50 , 200);
  text("Size: "+ai.size, 50 , 250);
  text("Population: "+ai.maxBrains, 50, 300);
  gen++;
  if(bestCost < 0.1)
    noLoop();
  //sliders.drawAndUpdateSlider();
}

void keyPressed(){
  ai.allTimeBest.printBrain();
}
