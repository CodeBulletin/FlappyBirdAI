import java.util.Collections;

static final int world_pop = 1000;
static final float mutation_rate = 1;
static final float mutation_ratio = 1;
bird[] birds;
ArrayList<pipe> pipes;
NeuralNetwork bestbirdDNA = null;
bird best = null, test;
int framecount = 0, speedX = 1, speedO = 0, alltimebest = 0, genration = 1;
boolean testMode = true, debugmode = false, showBest = false, initialized = false;
ArrayList<Float> pointx = new ArrayList<Float>();
ArrayList<Float> pointy = new ArrayList<Float>();
//images
PImage[] imageBird1, imageBird2, imageBird3;
PImage base;
PImage background;
PImage pipe1, pipe2;

void preload() {
  imageBird1 = new PImage[3];
  imageBird1[0] = loadImage("/assets/ybirdD.png");
  imageBird1[0].resize(80, 80);
  imageBird1[1] = loadImage("/assets/ybirdM.png");
  imageBird1[1].resize(80, 80);
  imageBird1[2] = loadImage("/assets/ybirdU.png");
  imageBird1[2].resize(80, 80);
  imageBird2 = new PImage[3];
  imageBird2[0] = loadImage("/assets/rbirdD.png");
  imageBird2[0].resize(80, 80);
  imageBird2[1] = loadImage("/assets/rbirdM.png");
  imageBird2[1].resize(80, 80);
  imageBird2[2] = loadImage("/assets/rbirdU.png");
  imageBird2[2].resize(80, 80);
  imageBird3 = new PImage[3];
  imageBird3[0] = loadImage("/assets/bbirdD.png");
  imageBird3[0].resize(80, 80);
  imageBird3[1] = loadImage("/assets/bbirdM.png");
  imageBird3[1].resize(80, 80);
  imageBird3[2] = loadImage("/assets/bbirdU.png");
  imageBird3[2].resize(80, 80);
  base = loadImage("/assets/base.png");
  background = loadImage("/assets/Background.png");
  pipe1 = loadImage("/assets/pipe-green.png");
  pipe1.resize(150, height - 60 - 250);
  pipe2 = loadImage("/assets/pipe-red.png");
  pipe2.resize(150, height - 60 - 250);
}

void settings() {
  //fullScreen(P2D);
  size(1920, 1080, P2D);
}

void setup() {
  if (!initialized) {
    initialized = true;
    frameRate(144);
    preload();
    pointx.add(0.0);
    pointy.add(0.0);
    pointx.add(0.0);
    pointy.add(0.0);
  }
  birds = new bird[world_pop];
  for (int i = 0; i < birds.length; i++) {
    birds[i] = new bird(new PVector(250, height/2));
  }
  pipes = new ArrayList<pipe>();
  if (testMode) {      
    test = new bird(new PVector(200, height/2), "testModel/best.json");
  }
  noLoop();
  textAlign(CENTER, CENTER);
}

void draw() {
  if (debugmode) {
    scale(0.75);
    translate((2560 - width), height/6);
  }
  for (int n = 0; n < speedX; n++) {
    if (framecount%150 == 0) {
      if (random(1) < 0.75) {
        pipes.add(new pipe(pipe1, 150, 4, 200, 210));
      } else {
        pipes.add(new pipe(pipe2, 150, 4, 200, 210));
      }
    }
    framecount++;
    for (int i = pipes.size() - 1; i >= 0; i--) {
      pipe p = pipes.get(i);
      p.update();
      if (!testMode) {
        for (bird b : birds) {
          if (b.isalive) {
            if (p.hit(b)) {
              b.isalive = false;
            }
          }
        }
      } else {
        if (p.hit(test)) {
          test.isalive = false;
        }
      }
      if (p.offscreen()) {
        pipes.remove(p);
      }
    }
    if (testMode) {
      test.update();
    }
    if (!done() && !testMode) {
      for (bird b : birds) {
        if (b.onscreen()) {
          b.update();
        }
      }
    } else if (!testMode) {
      pipes.clear();
      framecount = 0;
      bestbirdDNA.save("/save/dna_" + str(alltimebest) + ".json");
      calfitness();
      nextGenration();
      pointx.add((float) genration);
      pointy.add((float) best.points);
      genration++;
    }
  }
  background(0);
  image(background, 0, 0);
  for (int i = 0; i < 6; i++) {
    push();
    translate(335*(i+1), 50);
    rotate(PI);
    image(base, 0, 0);
    pop();
  }
  for (int i = 0; i < 6; i++) { 
    image(base, 335*(i), height-50);
  }
  for (pipe p : pipes) {
    p.show();
  }
  if (!testMode) {
    int bestpoints = 0;
    int bestscore = 0;
    for (bird b : birds) {
      if (b.onscreen()) {
        if (!showBest) {
          b.show();
        }
        if ((b.points > bestpoints || b.score > bestscore) && b.isalive) {
          bestpoints = b.points;
          best = b;
        }
      }
    }
    if (alltimebest <= bestpoints && best != null) {
      alltimebest = bestpoints;
      bestbirdDNA = best.NN;
    }
    if (best != null) {
      best.show(true);
    }
    push();
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(64);
    text(bestpoints, width/2, 100);
    text(genration, width/2, height - 100);
    pop();
  } else {
    test.show();
    if (!test.isalive) {
      speedO = 0;
      setSpeed();
      test.pos = new PVector(200, height/2);
      test.isalive = true;
      test.points = 0;
      framecount = 1;
    }
    push();
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(64);
    text(test.points, width/2, 100);
    pop();
  }
  if (debugmode) {
    clean();
    if (pointx.size() > 0 && !testMode) {
      Garph(pointx, pointy, new PVector(-width/3 + 50, 0), (float)width/3 - 100, (float)width/3 - 100, "genration", "points");
    }
    if (testMode) {
      test.showN(-width/6, height/2, width/3-100, height/2-200);
    } else {
      best.showN(-width/6, 3*height/4 + 50, width/3-100, height/2-200);
    }
  }
}

void clean() {
  push();
  noStroke();
  fill(0);
  rect(-width/3, height, (4*width)/3, height/3);
  rect(-width/3, -height/3, (4*width)/3, height/3);
  rect(-width/3, 0, width/3, height);
  pop();
}

void calfitness() {
  int sum = 0;
  for (bird b : birds) {
    if (alltimebest < 10) {
      b.fitness = pow(b.points + b.score/10, 4);
    } else {
      b.fitness = pow(b.points*0.075 + b.score/1000, 2);
    }
    sum += b.fitness;
  }
  for (bird b : birds) {
    b.fitness /= sum;
  }
}

boolean done() {
  for (bird b : birds) {
    if (b.isalive) {
      return false;
    }
  }
  return true;
}

void keyPressed() {
  if (key == 'u') {
    speedO += 1;
    speedO %= 4;
    setSpeed();
  }
  if (key == 'j') {
    speedO -= 1;
    if(speedO < 0){
      speedO = 3;
    }
    speedO %= 4;
    setSpeed();
  }
  if (key == 'p') {
    loop();
  }
  if (key == 's') {
    bestbirdDNA.save("/save/dna_" + str(alltimebest) + ".json");
  }
  if (key == 'd') {
    debugmode = !debugmode;
  }
  if (key == 'b') {
    showBest = !showBest;
  }
}

void setSpeed() {
  if (speedO == 0) {
    speedX = 1;
  } else if (speedO == 1) {
    speedX = 10;
  } else if (speedO == 2) {
    speedX = 100;
  } else if (speedO == 3) {
    speedX = 1000;
  }
}
