class SliderHandler {
  ArrayList <Slider> sliders = new ArrayList <Slider>();
  int sWidth = 300;
  int sHeight = 20;
  int sPosX = 20;
  int sAbstand = 30;
  int sSlow = 10;
  int textWidth = 100;

  SliderHandler() {
  }

  void addSlider() {
    sliders.add(new Slider ("Slider "+(sliders.size()+1), sPosX, (sliders.size() + 1) * sAbstand, sWidth, sHeight, sSlow));
  }

  void drawSlider() {
    for (int s = 0; s < sliders.size(); s++)
      sliders.get(s).display();
  }

  void updateSlider(int textWidth) {
    for (int s = 0; s < sliders.size(); s++)
      sliders.get(s).update(textWidth);
  }

  void drawAndUpdateSlider() {
    
    updateSlider(textWidth);
    pushMatrix();
    translate(textWidth, 0);
    drawValues();
    drawSlider();
    popMatrix();
    drawText();
  }

  void drawValues() {
    fill(125);
    noStroke();
    textSize(sHeight);
    rect(sPosX + sWidth + 5, 20, 50, (sAbstand + sHeight) * sliders.size());
    fill(0);
    for (int s = 0; s < sliders.size(); s++) {
      float xPercent = sliders.get(s).getPosCalc();
      text(xPercent, sPosX + sWidth + 5, sliders.get(s).ypos + sAbstand/2);
    }
  }

  void drawText() {
    fill(125);
    noStroke();
    rect(sPosX, 20, textWidth, (sAbstand + sHeight) * sliders.size());
    fill(0);
    for (int s = 0; s < sliders.size(); s++) {
      text(sliders.get(s).name, sPosX, sliders.get(s).ypos + sAbstand/2);
    }
  }

  void printSliderConfig() {
    println("xPos: "+sPosX + "  yPos: "+sAbstand+ "  xWidth: "+sWidth+ "  yHeight: "+sHeight+ " trägheit: "+ sSlow);
    for (int s = 0; s < sliders.size(); s++) {
      println("sliders.add(new Slider (\"" + sliders.get(s).name+"\", "+sPosX+", "+sliders.get(s).ypos+", "+sWidth+", "+sHeight+", "+sSlow+"));");
    }
  }

  void changeParameter(char k) {
    if (k == '+')
      sWidth+=20;
    if (k == '-')
      sWidth-=20;
    updateParameter();
  }

  void updateParameter() {
    int size = sliders.size();
    sliders.clear();
    for (int s = 0; s < size; s++)
      addSlider();
    background(125);
  }
  
  float getPerc(int number){
    return sliders.get(number).getPosCalc();
  }
    
  float getRangedOutput(int number){
    return map(getPerc(number),0,1,sliders.get(number).range.x,sliders.get(number).range.y); 
  }
  
  void defRange(int number, float min, float max){
    sliders.get(number).range = new PVector(min,max); 
  }
  
}
