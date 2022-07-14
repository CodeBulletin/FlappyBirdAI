class pipe {
  float top, bottom;
  float w;
  float x;
  float x_speed;
  PImage pipe;
  pipe(PImage pipe, float w, float x_speed, float minGap, float maxGap) {
    top = random(60, height - 60 - maxGap);
    bottom = height - top - random(minGap, maxGap);
    this.w = w;
    this.x_speed = x_speed;
    x = width + w/2;
    this.pipe = pipe;
  }

  void show() {
    push();
    imageMode(CENTER);
    noStroke();
    fill(0, 200, 0);
    push();
    translate(x, - pipe.height/2 + top);
    rotate(PI);
    scale(-1, 1);
    image(pipe, 0, 0);
    pop();
    translate(x, height + pipe.height/2 - bottom);
    image(pipe, 0, 0);
    pop();
  }

  void update() {
    x -= x_speed;
  }

  boolean hit(bird b) {
    float deltaX1 = b.pos.x - max(x-w/2, min(b.pos.x, x+w/2));
    float deltaY1 = b.pos.y - max(0, min(b.pos.y, top));
    float deltaX2 = b.pos.x - max(x-w/2, min(b.pos.x, x+w/2));
    float deltaY2 = b.pos.y - max(height-bottom, min(b.pos.y, height));
    if(b.pos.x > x && b.pos.x <= x+x_speed){
      b.points += 1;
    }
    return (deltaX1 * deltaX1 + deltaY1 * deltaY1) < ((b.d/2) * (b.d/2)) || (deltaX2 * deltaX2 + deltaY2 * deltaY2) < ((b.d/2) * (b.d/2));
  }

  boolean offscreen() {
    return this.x + w < 0;
  }
}
