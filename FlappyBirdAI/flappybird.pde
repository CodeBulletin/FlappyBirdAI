class bird {
  PVector pos;
  float y_vel, fitness;
  int frame = 0;
  int d = 75;
  boolean isalive = true;
  int points, score;
  float[] inputs_forshow;
  NeuralNetwork NN;
  bird(PVector pos) {
    NN = new NeuralNetwork();
    NN.addLayer(5);
    NN.addLayer(8);
    //NN.addLayer(8);
    NN.addLayer(2);
    this.pos = pos;
    points  = 0;
    y_vel = 0;
  }

  bird(PVector pos, NeuralNetwork NN) {
    this.NN = NN.copy();
    this.pos = pos;
    points  = 0;
    y_vel = 0;
  }
  
  bird(PVector pos, String stringNN) {
    this.NN = new NeuralNetwork(stringNN);
    this.pos = pos;
    points  = 0;
    y_vel = 0;
  }

  void update() {
    if (isalive) {
      score++;
      y_vel += 0.5;
      y_vel = constrain(y_vel, -10, 10);
      if ((pos.y >= 90 || y_vel >= 0) && (pos.y <= height - 90 || y_vel <= 0)) {
        pos.y += y_vel;
      }
      if (pos.y <= d/2 + 55 || pos.y >= height - d/2 - 55) {
        isalive = false;
      }
      pipe closest = null;
      float close = 2*width;
      for (pipe P : pipes) {
        if (P.x + P.w/2 + d/2> pos.x && P.x < close) {
          close = P.x;
          closest = P;
        }
      }
      inputs_forshow = new float[]{(close)/width, closest.top/height, closest.bottom/height, pos.y/height, y_vel/10};
      float[] output = NN.feedForward(inputs_forshow);
      if (output[0] > output[1]){
        up();
      }
    } else {
      pos.x -= 4;
    }
  }

  void show() {
    push();
    int frameIndex = (int)round(map(frame%27, 0, 26, 2, 0));
    imageMode(CENTER);
    if (isalive) {
      translate(pos.x+3, pos.y);
      if (y_vel > 9) {
        rotate(PI/6);
      }
      if (y_vel < -3) {
        rotate(-PI/6);
      }
      image(imageBird1[frameIndex], 0, 0);
      frame++;
    } else {
      translate(pos.x+3, pos.y);
      if (y_vel > 9) {
        rotate(PI/6);
      }
      if (y_vel < -3) {
        rotate(-PI/6);
      }
      image(imageBird2[frameIndex], 0, 0);
    }
    pop();
  }

  void show(boolean temp) {
    push();
    int frameIndex = (int)round(map(frame%27, 0, 26, 2, 0));
    imageMode(CENTER);
    translate(pos.x+3, pos.y);
    if (y_vel > 9) {
      rotate(PI/6);
    }
    if (y_vel < -3) {
      rotate(-PI/6);
    }
    image(imageBird3[frameIndex], 0, 0);
    frame++;
    pop();
  }

  boolean onscreen() {
    return !(pos.x + d < 0);
  }

  void showN(float x, float y, float w, float h){
    NN.show(x, y, w, h, inputs_forshow);
  }

  void up() {
    y_vel -= 20;
  }
}
