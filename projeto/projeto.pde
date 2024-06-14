
/*inputFolder= "data";
 File dataFolder = new File(sketchPath, inputFolder);
 String[] fileList = dataFolder.list( );*/

PImage img1, img2, blendedImg;
color[] blendColors;

void setup() {
  size(1000, 800);
  //fullScreen();

  loadColors("0 0 0 0.dat");

  // Carrega as imagens
  img1 = loadImage("imagem1.png");
  img2 = loadImage("imagem2.png");

  if (img1 == null || img2 == null) {
    println("Erro ao carregar as imagens.");
    exit();
  }

  blendedImg = createImage(img2.width, img2.height, RGB);

  // Faz o blend das imagens
  for (int x = 0; x < img1.width; x++) {
    for (int y = 0; y < img1.height; y++) {
      color c1 = img1.get(x, y);
      color c2 = img2.get(x, y);

      // Calcula o alfa baseado na posição horizontal e vertical
      float alphaHorizontal = (float)x / img1.width;
      float alphaVertical = (float)y / img1.height;

      // Mix horizontal entre blendColors[0] e a imagem 1
      float rH = red(c1) * alphaHorizontal + red(blendColors[0]) * (1 - alphaHorizontal);
      float gH = green(c1) * alphaHorizontal + green(blendColors[0]) * (1 - alphaHorizontal);
      float bH = blue(c1) * alphaHorizontal + blue(blendColors[0]) * (1 - alphaHorizontal);

      // Mix vertical entre blendColors[1] e a imagem 2
      float rV = red(c2) * alphaVertical + red(blendColors[1]) * (1 - alphaVertical);
      float gV = green(c2) * alphaVertical + green(blendColors[1]) * (1 - alphaVertical);
      float bV = blue(c2) * alphaVertical + blue(blendColors[1]) * (1 - alphaVertical);

      float r = (rH + rV);
      float g = (gH + gV);
      float b = (bH + bV);

      blendedImg.set(x, y, color(r, g, b));
    }
  }
  noLoop();
}

void draw() {

  image(blendedImg, 0, 0);
}


void loadColors(String filename) {
  byte[] bytes = loadBytes(filename);

  blendColors = new color[2];

  // Carrega as cores do arquivo .dat
  int r1 = bytes[0] & 0xFF;
  int g1 = bytes[1] & 0xFF;
  int b1 = bytes[2] & 0xFF;
  blendColors[0] = color(r1, g1, b1);

  int r2 = bytes[3] & 0xFF;
  int g2 = bytes[4] & 0xFF;
  int b2 = bytes[5] & 0xFF;
  blendColors[1] = color(r2, g2, b2);
}

/*void getData() {
 
 //Ler a informação da serial port
 myString = myPort.readStringUntil(lf);
 println(myString);
 
 if (myString != null) {
 if (myString.charAt(0) == 'U') {
 
 String[] userIdSplit = split(myString, ' ');
 
 for (int i = 1; i < 5; i++) {
 currentUser[i-1] = byte(int(userIdSplit[i]));
 //println(hex(currentUser[i-1]));
 }
 }
 }
 
 byte [] load = loadBytes(str(currentUser[0])+" "+str(currentUser[1])+" "+str(currentUser[2])+" "+str(currentUser[3])+".dat");
 //byte [] load = loadBytes("19 52 61 -67.dat");
 //byte [] load = loadBytes("-96 72 -101 83.dat");
 
 base = load[0];
 base_color = load[1];
 shape = load[2];
 }*/
