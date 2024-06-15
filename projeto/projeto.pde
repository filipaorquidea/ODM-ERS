
/*inputFolder= "data";
 File dataFolder = new File(sketchPath, inputFolder);
 String[] fileList = dataFolder.list( );*/

PImage img1, img2, blendedImg;
color[] blendColors;

void setup() {
  size(620, 877);
  //fullScreen();

  loadColors("0 0 0 0cores.dat");

  // Carrega as imagens
  img1 = loadImage("../ODM_data/img1.jpg");
  img2 = loadImage("../ODM_data/img5.jpg");

  if (img1 == null || img2 == null) {
    println("Erro ao carregar as imagens.");
    exit();
  }

  blendedImg = createImage(img1.width, img1.height, RGB);

  // Faz o blend das imagens
  for (int y = 0; y < img1.height; y++) {
    float alpha = (float)y / img1.height;  // Calcula o alfa baseado na posição vertical
    for (int x = 0; x < img1.width; x++) {
      color c1 = img1.get(x, y);
      color c2 = img2.get(x, y);

      // Mistura os pixels das duas imagens
      float r = red(c1) * (1 - alpha) + red(c2) * alpha;
      float g = green(c1) * (1 - alpha) + green(c2) * alpha;
      float b = blue(c1) * (1 - alpha) + blue(c2) * alpha;

      // Define a cor no blendedImg
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
