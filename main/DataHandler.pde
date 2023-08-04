class DataHandler {
  int dataSize = 150;
  float[][] data = new float[dataSize][3];

  DataHandler() {
    for (int i = 0; i < dataSize; i++) {
      data[i][0] = random(100);
      data[i][1] = random(20);
      data[i][2] = 0;
      if (data[i][0] > 30 && data[i][0] < 70  )
        data[i][2] = 1;
      if (data[i][0] > 80 )
        data[i][2] = 1;
      if(data[i][0] > 30 && data[i][0] < 70 && data[i][1] >10 )
        data[i][2] = 0;
      if(data[i][0] < 30 && data[i][1] > 10)
        data[i][2] = -1;
    }
  }


  void drawData() {
    background(125);
    for (int i = 0; i < dataSize; i++) {
      if (data[i][2] == 0)
        fill(#FF0000);
      else if(data[i][2] == 1)
        fill(#00FF00);
      else
        fill(#0000FF);
      ellipse(data[i][0] * 0.01 * width, data[i][1] * height * 0.05, 20, 20);
    }
  }
}
