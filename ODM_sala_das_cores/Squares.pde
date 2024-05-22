class Quadrado {
  float x, y;
  float lado;
  color cor;

  Quadrado(float x, float y, float lado, color cor) {
    this.x = x;
    this.y = y;
    this.lado = lado;
    this.cor = cor;
  }

  void desenhar() {
    fill(cor);
    rectMode(CENTER);
    rect(x, y, lado, lado);
  }

  boolean emCima(float px, float py) {
    return px > x - lado / 2 && px < x + lado / 2 && py > y - lado / 2 && py < y + lado / 2;
  }
}
