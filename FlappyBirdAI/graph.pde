void Garph(ArrayList<Float> xpoints, ArrayList<Float> ypoints, PVector pos, float w, float h, String x_name, String y_name){
  push();
  stroke(255);
  push();
  textAlign(CENTER, CENTER);
  textSize(20);
  translate(pos.x, h/2);
  rotate(-PI/2);
  text(y_name, 0, 0);
  pop();
  push();
  textAlign(CENTER, CENTER);
  textSize(20);
  translate(pos.x + w/2, pos.y + h - 10);
  text(x_name, 0, 0);
  pop();
  stroke(255);
  strokeWeight(4);
  line(pos.x + 20, pos.y + 20, pos.x + 20, pos.y + h - 20);
  line(pos.x + 20, pos.y + 20, pos.x + 30, pos.y + 30);
  line(pos.x + 20, pos.y + 20, pos.x + 10, pos.y + 30);
  line(pos.x + 20, pos.y + h -20, pos.x + w - 20, pos.y + h - 20);
  line(pos.x + w - 20, pos.y + h - 20, pos.x + w - 30, pos.y + h - 10);
  line(pos.x + w - 20, pos.y + h - 20, pos.x + w - 30, pos.y + h - 30);
  float x_len = w - 100;
  float y_len = h - 100;
  float max_x = Collections.max(xpoints);
  float max_y = Collections.max(ypoints);
  float min_x = Collections.min(xpoints);
  float min_y = Collections.min(ypoints);
  beginShape();
  noFill();
  for(int i = 0; i < xpoints.size(); i++){
    float x = (xpoints.get(i) - min_x)/(max_x-min_x);
    float y = (ypoints.get(i) - min_y)/(max_y-min_y);
    vertex(x*x_len + pos.x + 20, - y*y_len + h + pos.y - 20);
  }
  endShape();
  pop();
}
