
class PWindow extends PApplet {
  int w_ = 500;
  int h_ = 500;
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  PWindow(int w, int h) {
    super();
    w_ = w;
    h_ = h;
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(800, 800);
  }

  void draw() {
    background(0255);
  }
}
