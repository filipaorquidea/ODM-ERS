float x, y;
color cor;
int linhas = 3;
int colunas = 12;
int lado = 50;
Quadrado[][] matrizQuadrados;
Quadrado bigQuadrado = null;
color[] colors = {#65B8CA, #9AD26A, #8A46BF, #F3DB19, #C03D74, #D16F1F, #000000};
color[] savedcolors = {};
int numRipples = 5;
float[] rippleX = new float[numRipples];
float[] rippleY = new float[numRipples];
float[] rippleRadius = new float[numRipples];
float rippleSpeed = 2.0;

void setup() {
  size(800, 150);
  smooth();

  matrizQuadrados = new Quadrado[linhas][colunas];

  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      x = j * lado + lado / 2;
      y = i * lado + lado / 2;
      cor = colors[int(random(colors.length))];
      matrizQuadrados[i][j] = new Quadrado(x, y, lado, cor);
    }
  }
}

void draw() {
  background(0);
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      matrizQuadrados[i][j].desenhar();
    }
  }

  if (bigQuadrado != null) {
    bigQuadrado.desenhar();
  }
  for (int i = 0; i < numRipples; i++) {
    if (rippleRadius[i] > 0) {
      drawRipple(i);
      updateRipple(i);
    }
  }
  stroke(0);
}

void updateRipple(int index) {
  rippleRadius[index] += rippleSpeed;

  if (rippleRadius[index] > max(width, height)) {
    rippleRadius[index] = 0;
  }
}

void drawRipple(int index) {
  noFill();
  stroke(cor);

  ellipse(rippleX[index], rippleY[index], rippleRadius[index] * 2, rippleRadius[index] * 2);
}

void mousePressed() {

  for (int i = 0; i < numRipples; i++) {
    if (rippleRadius[i] == 0) {
      rippleX[i] = mouseX;
      rippleY[i] = mouseY;
      rippleRadius[i] = 2;
      break;
    }
  }
  for (int i = 0; i < linhas; i++) {
    for (int j = 0; j < colunas; j++) {
      if (matrizQuadrados[i][j].emCima(mouseX, mouseY)) {
        cor = matrizQuadrados[i][j].cor;
        //println(cor);
        savedcolors = append(savedcolors, cor);
        println(savedcolors);
        rectMode(CORNER);
        bigQuadrado = new Quadrado(width-lado*2, lado*3/2, lado*3, cor);
        return;
      }
    }
  }
    stroke(cor);
}
