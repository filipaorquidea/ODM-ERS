import processing.serial.*;
import processing.video.*;

Capture live_camera;
int seconds, countdown, filter, pos_x, pos_y, div_factor;
boolean trigger_countdown;
String nomePastaOutput;

//Comunicação Serial
Serial myPort;
String myString;
int lf = 10;
byte [] currentUser ={0, 0, 0, 0};

PImage [] preview = new PImage [5];
PFont jost;
PShape counter1, counter2, counter3;

//Imagem usada como base para as previews
PImage display_image;

void setup() {
  //Horizontal
  //size(640, 480);

  //Vertical
  size(480, 640);

  //Configurar e Limpar a Serial Port
  /*printArray(Serial.list());
   String portName = Serial.list()[2];
   myPort = new Serial(this, portName, 9600);
   myPort.clear();*/

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("No available cameras");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    live_camera = new Capture(this, height*4/3, height, cameras[2]);
    live_camera.start();
  }

  for (int i = 0; i < preview.length; i++) {
    preview[i] = loadImage("assets/" + "filtro" + (i+1) + ".jpg");
  }

  //Imagem usada como base para as previews
  display_image = loadImage("assets/" + "display.jpg");

  //Fonte
  jost = createFont("assets/" + "Jost-SemiBold.ttf", 80);
  textFont(jost);

  //Formas - Counter
  counter1 = loadShape("assets/" +"counter1.svg");
  counter2 = loadShape("assets/" +"counter2.svg");
  counter3 = loadShape("assets/" +"counter3.svg");
  counter1.disableStyle();
  counter2.disableStyle();
  counter3.disableStyle();

  //Variáveis
  countdown = 0;
  seconds = 0;
  filter = 0;
  nomePastaOutput = System.currentTimeMillis() + "";

  pos_x = 15;
  pos_y = height-80;
  div_factor = 11;
}

void draw() {
  //save(sketchPath("exportacao/" + nomePastaOutput + "/" + nf(frameCount, 6) + ".jpg"));

  //Ler Data
  /*while (myPort.available() > 0) {
   getData();
   }*/

  image(live_camera, 0, 0);
  filters(filter, live_camera);

  //Imagem usada como base para as previews
  //image(display_image, 0, 0);

  if (trigger_countdown!=true) {
    for (int i=0; i<5; i++) {
      image(preview[i], (pos_x+i*(live_camera.width/div_factor+pos_x)), pos_y, live_camera.width/div_factor, live_camera.height/div_factor);
    }
  }

  //Imagem usada como base para as previews
  //filters(filter, display_image);


  filter(GRAY);


  if (trigger_countdown == false) {
    seconds = second();
  } else if (trigger_countdown == true) {
    countdown = second();

    if ((3-(countdown-seconds))!=0) {
      //ellipseMode(CENTER);
      shapeMode(CENTER);
      noStroke();

      pushMatrix();

      translate(width/2, height/2);
      //circle(width/2, height/2, 120);
      if (3-(countdown-seconds) == 3) {
        scale(4);
        fill(80);
        shape(counter1, 0, 0);
      } else if (3-(countdown-seconds) == 2) {
        scale(2.5);
        fill(#E88F00);
        shape(counter2, 15, 0);
      } else if (3-(countdown-seconds) == 1) {
        scale(6);
        fill(0);
        shape(counter3, 0, 4);
      }
      popMatrix();

      textAlign(CENTER, CENTER);
      fill(255);
      textSize(80);
      text(3-(countdown-seconds), width/2+1, height/2-5);
    }
    if ((countdown-seconds) >= 3) {
      save(sketchPath("../ODM_data/" + str(currentUser[0])+" "+str(currentUser[1])+" "+str(currentUser[2])+" "+str(currentUser[3])+"colagem.jpg"));

      //save(sketchPath("exportacao/" + nomePastaOutput + "/" + nf(frameCount, 6) + ".jpg"));

      countdown = 0;
      trigger_countdown = false;
    }
  }
}

void captureEvent(Capture live_camera) {
  live_camera.read();
}

void mousePressed() {
  if (mouseY>=pos_y && mouseY<=pos_y+live_camera.height/div_factor) {
    for (int i=0; i<5; i++) {
      if (mouseX>=(pos_x+i*(live_camera.width/div_factor+pos_x)) && mouseX<= (pos_x+live_camera.width/div_factor+i*(live_camera.width/div_factor+pos_x))) {
        filter = i+1;
      }
    }
  } else {
    trigger_countdown = true;
  }
}

void keyPressed() {
  if (key == 'f') {
    filter ++;
    if (filter >= 6) {
      filter = 0;
    }
  } else if (key == 'p') {
    trigger_countdown = true;
  }
}

void getData() {

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

  println(currentUser);
}
