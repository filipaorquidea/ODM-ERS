import processing.serial.*;

PImage img1, img2, text;
String nomePastaOutput;

//Comunicação Serial
Serial myPort;
String myString;
int lf = 10;
byte [] currentUser = {0, 0, 0, 0};
byte [] final_colors;

color[] colors = {#65B8CA, #9AD26A, #8A46BF, #F3DB19, #C03D74, #D16F1F};
int color1, color2;

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
  
  final_colors = loadBytes("../ODM_data/0 0 0 0cores.dat");
  random_colors();
  //println(color1);
  //println(color2);
}

void draw() {
  //Ler Data
  /*if (myPort.available() > 0) {
   getData();
   random_colors();
   }*/ 
   
 //Ver se isto resulta - só recebe a informação quando troca o RFID

  pushStyle();
  tint(color1);
  image(img1, 0, 0, width, height);

  tint(color2, 200);
  image(img2, 0, 0, width, height);

  popStyle();

  image(text, -20, 0, width+50, height+50);
  
  //Debug
  /*fill(color1);
  rect(0,0,100,100);
  fill(color2);
  rect(200,200,100,100);*/
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

  final_colors = loadBytes("../ODM_data/" + str(currentUser[0])+" "+str(currentUser[1])+" "+str(currentUser[2])+" "+str(currentUser[3])+"cores.dat");
  img1 = loadImage("../ODM_data/" + str(currentUser[0])+" "+str(currentUser[1])+" "+str(currentUser[2])+" "+str(currentUser[3])+"colagem.jpg");
  img2 = loadImage("../ODM_data/" + str(currentUser[0])+" "+str(currentUser[1])+" "+str(currentUser[2])+" "+str(currentUser[3])+"movimento.jpg");
}

void random_colors(){
  int c = int(random(3));
  int c2 = int(random(3));
  
  //println(c);
  //println(c2);
  
  color1 = color(map(final_colors[((c*2)+c)],127,-128,0,255),map(final_colors[((c*2)+c)+1],127,-128,0,255),map(final_colors[((c*2)+c)+2],127,-128,0,255));
  //color2 = color(final_colors[((c2*2)+c2)],final_colors[((c2*2)+c2)+1], final_colors[((c2*2)+c2)+2]);
  color2 = color(map(final_colors[((c2*2)+c2)],127,-128,0,255),map(final_colors[((c2*2)+c2)+1],127,-128,0,255),map(final_colors[((c2*2)+c2)+2],127,-128,0,255));
}
