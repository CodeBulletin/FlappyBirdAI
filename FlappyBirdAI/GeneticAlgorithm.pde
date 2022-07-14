void nextGenration() {
  bird[] newBirds = new bird[world_pop];
  for (int i = 0; i < world_pop; i++) {
    NeuralNetwork dna1 = pick();
    NeuralNetwork dna2 = pick();
    NeuralNetwork childDna = dna1.crossover(dna2, mutation_rate, mutation_ratio);
    newBirds[i] = new bird(new PVector(200, height/2), childDna);
  }
  birds = newBirds;
}

NeuralNetwork pick() {
  int index = 0;
  float r = random(1);

  while (r > 0) {
    if (index >= world_pop) {
      index = world_pop - 1;
    }
    r = r - birds[index].fitness;
    index++;
  }
  index--;
  if (index >= world_pop) {
    index = world_pop - 1;
  }
  NeuralNetwork parrentDna = birds[index].NN;
  return parrentDna;
}
