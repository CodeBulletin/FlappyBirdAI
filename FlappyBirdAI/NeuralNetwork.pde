import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

class NeuralNetwork {
  ArrayList<Integer> layer;
  ArrayList<Matrix> weights, biases;
  NeuralNetwork() {
    layer = new ArrayList<Integer>();
    weights = new ArrayList<Matrix>();
    biases = new ArrayList<Matrix>();
  }

  NeuralNetwork(NeuralNetwork other) {
    layer = new ArrayList<Integer>();
    weights = new ArrayList<Matrix>();
    biases = new ArrayList<Matrix>();
    for (int i = 0; i < other.layer.size(); i++) {
      layer.add(other.layer.get(i));
    }
    for (int i = 0; i < other.weights.size(); i++) {
      weights.add(other.weights.get(i).copy());
      biases.add(other.biases.get(i).copy());
    }
  }

  NeuralNetwork(String string) {
    String[] jsonstring = loadStrings(string);
    String jsonString = "";
    for (String s : jsonstring) {
      jsonString += s;
    }
    Gson gson = new Gson();
    NeuralNetwork NN = gson.fromJson(jsonString, NeuralNetwork.class);
    this.layer = NN.layer;
    this.weights = NN.weights;
    this.biases = NN.biases;
  }

  void save(String filename) {
    Gson gson =  new GsonBuilder().setPrettyPrinting().create();
    String json = gson.toJson(this);
    saveStrings(filename, new String[]{json});
  }

  NeuralNetwork copy() {
    return new NeuralNetwork(this);
  }

  void mutate(float MutationRate, float MutationRatio) {
    for (Matrix matrix : weights) {
      for (int i = 0; i < matrix.rows; i++) {
        for (int j = 0; j < matrix.cols; j++) {
          if (Math.random() < MutationRate) {
            if (Math.random() < MutationRatio) {
              matrix.data[i][j] += randomGaussian()*2;
            } else {
              matrix.data[i][j] = (float) Math.random()*20 - 10;
            }
          }
        }
      }
    }
    for (Matrix matrix : biases) {
      for (int i = 0; i < matrix.rows; i++) {
        for (int j = 0; j < matrix.cols; j++) {
          if (Math.random() < MutationRate) {
            if (Math.random() < MutationRatio) {
              matrix.data[i][j] += randomGaussian()*2;
            } else {
              matrix.data[i][j] = (float) Math.random()*20 - 10;
            }
          }
        }
      }
    }
  }

  NeuralNetwork crossover(NeuralNetwork other, float MutationRate, float MutationRatio) {
    NeuralNetwork child = new NeuralNetwork();
    child.layer.addAll(other.layer);
    for (int i = 0; i < weights.size(); i++) {
      if (Math.random() < 0.5) {
        child.weights.add(this.weights.get(i).copy());
        child.biases.add(this.biases.get(i).copy());
      } else {
        child.weights.add(other.weights.get(i).copy());
        child.biases.add(other.biases.get(i).copy());
      }
    }
    child.mutate(MutationRate, MutationRatio);
    return child;
  }

  void addLayer(int n) {
    layer.add(n);
    if (layer.size() > 1) {
      Matrix weight = new Matrix(n, layer.get(layer.size() - 2));
      weight.random();
      weights.add(weight);
      Matrix bias = new Matrix(n, 1);
      bias.random();
      biases.add(bias);
    }
  }

  float[] feedForward(float[] inputs_array) {
    Matrix inputs = Matrix.toMatrix(inputs_array);
    for (int i = 0; i < weights.size(); i++) {
      inputs = Matrix.Sigmoid(Matrix.add(Matrix.dot(weights.get(i), inputs), biases.get(i)));
    }
    return inputs.toArray();
  }

  void show(float x, float y, float w, float h, float[] inputs) {
    push();
    Matrix[] activated = new Matrix[this.layer.size()];
    Matrix input = Matrix.toMatrix(inputs);
    activated[0] = input;
    for (int i = 0; i < weights.size(); i++) {
      input = Matrix.Sigmoid(Matrix.add(Matrix.dot(weights.get(i), input), biases.get(i)));
      activated[i+1] = input;
    }
    if (this.layer.size() > 1) {
      stroke(255);
      float x_min = w / this.layer.size();
      float y_min = h / Collections.max(this.layer);
      float r = min(x_min, y_min) / 2;
      float x1 = -w / 2 + r;
      for (int i = 0; i < this.layer.size(); i++) {
        float a = this.layer.get(i);
        float y1 = (1 - a) * h / (2 * a);
        for (int j = 0; j < a; j++) {
          if (i < this.layer.size() - 1) {
            float x2 = x1 + w / (this.layer.size() - 1) - 2 * r / (this.layer.size() - 1);
            float b = this.layer.get(i + 1);
            float y2 = (1 - b) * h / (2 * b);
            for (int k = 0; k < b; k++) {
              push();
              if (this.weights.get(i).data[k][j] < 0) {
                stroke(abs(255 * this.weights.get(i).data[k][j]), 0, 0);
                line(x + x1, y + y1, x + x2, y + y2);
              } else if (this.weights.get(i).data[k][j] >= 0) {
                stroke(0, abs(255 * this.weights.get(i).data[k][j]), 0);
                line(x + x1, y + y1, x + x2, y + y2);
              }
              y2 += h / b;
              pop();
            }
          }
          fill(activated[i].data[j][0] * 255);
          ellipse(x + x1, y + y1, r, r);
          y1 += h / a;
        }
        x += w / (this.layer.size() - 1) - 2 * r / (this.layer.size() - 1);
      }
    }
    pop();
  }
}
