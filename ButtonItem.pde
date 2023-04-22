//Player presses this button to open a door
class ButtonItem {
  float xPos, yPos, buttonItemWidth, buttonItemHeight;
  color Color;
  Door door;

  //Constructor
  ButtonItem(float x, float y, float w, float h, color c, Door d) {
    xPos = x;
    yPos = y;
    buttonItemWidth = w;
    buttonItemHeight = h;
    Color = c;
    door = d;
  }

  void display() {
    rectMode(CENTER);
    fill(Color);
    rect(xPos, yPos, buttonItemWidth, buttonItemHeight);
  }

  void pressed() {
    door.toggle();
  }

  Door getDoor() {
    return door;
  }
};