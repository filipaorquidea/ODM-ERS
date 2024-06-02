
/*inputFolder= "data";
 File dataFolder = new File(sketchPath, inputFolder);
 String[] fileList = dataFolder.list( );*/

PImage img1, img2, blendedImg;
color[] blendColors;

void setup() {
  size(800, 600);


  loadColors("nome.txt");


  img1 = loadImage("imagem1.jpg");
  img2 = loadImage("imagem2.jpg");


  if (img1 == null || img2 == null) {
    println("Erro ao carregar as imagens.");
    exit();
  }


  if (img1.width != img2.width || img1.height != img2.height) {
    println("As imagens devem ter o mesmo tamanho.");
    exit();
  }

  // Cria uma nova imagem para armazenar o resultado do blend
  blendedImg = createImage(img1.width, img1.height, RGB);

  // Faz o blend das imagens manualmente usando as cores do arquivo
  for (int x = 0; x < img1.width; x++) {
    for (int y = 0; y < img1.height; y++) {
      color c1 = img1.get(x, y);
      color c2 = img2.get(x, y);

      // Ajusta a transparência (alfa) para a mistura
      float alpha = 0.5;
      float r = red(c1) * alpha + red(c2) * (1 - alpha);
      float g = green(c1) * alpha + green(c2) * (1 - alpha);
      float b = blue(c1) * alpha + blue(c2) * (1 - alpha);

      // Aplica a cor do arquivo (usando a posição x como índice)
      int colorIndex = x % blendColors.length;
      color blendColor = blendColors[colorIndex];
      r = (r + red(blendColor)) / 2;
      g = (g + green(blendColor)) / 2;
      b = (b + blue(blendColor)) / 2;

      blendedImg.set(x, y, color(r, g, b));
    }
  }
}

void draw() {

  image(blendedImg, 0, 0);
}

void loadColors(String filename) {
  String[] lines = loadStrings(filename);
  blendColors = new color[lines.length];

  for (int i = 0; i < lines.length; i++) {
    String line = lines[i].trim();
    if (line.startsWith("#")) {
      blendColors[i] = unhex(line.substring(1));
    } else {
      String[] rgb = split(line, ',');
      if (rgb.length == 3) {
        int r = int(trim(rgb[0]));
        int g = int(trim(rgb[1]));
        int b = int(trim(rgb[2]));
        blendColors[i] = color(r, g, b);
      }
    }
  }
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
