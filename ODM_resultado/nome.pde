import processing.serial.*;

PImage img1, img2, text;
String nomePastaOutput;

//Comunicação Serial
Serial myPort;
String myString;
int lf = 10;
byte [] currentUser ={0, 0, 0, 0};

void setup() {
  size(620, 877);

  //Configurar e Limpar a Serial Port
  /*printArray(Serial.list());
   String portName = Serial.list()[2];
   myPort = new Serial(this, portName, 9600);
   myPort.clear();*/

  nomePastaOutput = System.currentTimeMillis() + "";

  //Carregar Imagens
  img1 = loadImage("../ODM_data/img1.jpg");
  img2 = loadImage("../ODM_data/img5.jpg");
  text = loadImage("../ODM_data/lagen.png");

  smooth(8);
}

void draw() {
  //Ler Data
  /*while (myPort.available() > 0) {
   getData();
   }*/

  pushStyle();
  tint(192, 61, 116);
  image(img1, 0, 0, width, height);

  tint(209, 111, 31, 200);
  image(img2, 0, 0, width, height);

  popStyle();

  image(text, -20, 0, width+50, height+50);
}

void keyPressed() {

  if (key == 's') {
    save(sketchPath("exportacao/" + nomePastaOutput + "/" + nf(frameCount, 6) + ".jpg"));
  }
}

void getData() {
  //println(currentUser);

  //Ler a informação da serial port
  myString = myPort.readStringUntil(lf);
  //println(myString);

  if (myString != null) {

    if (myString.charAt(0) == 'U') {

      String[] userIdSplit = split(myString, ' ');

      for (int i = 0; i < 4; i++) {
        currentUser[i] = byte(int(userIdSplit[i+1]));
      }
    }
  }

  byte [] load = loadBytes("../ODM_data/" + str(currentUser[0])+" "+str(currentUser[1])+" "+str(currentUser[2])+" "+str(currentUser[3])+"cores.dat");
  img1 = loadImage("../ODM_data/" + str(currentUser[0])+" "+str(currentUser[1])+" "+str(currentUser[2])+" "+str(currentUser[3])+"colagem.jpg");
  img2 = loadImage("../ODM_data/" + str(currentUser[0])+" "+str(currentUser[1])+" "+str(currentUser[2])+" "+str(currentUser[3])+"movimento.jpg");
}
