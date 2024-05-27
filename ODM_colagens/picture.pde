import processing.serial.*;
import processing.video.*;

Capture live_camera;
int seconds, countdown, filter, pos_x, pos_y, div_factor;
boolean trigger_countdown;
String nomePastaOuput;

//Comunicação Serial
Serial myPort;
String myString;
int lf = 10;
byte [] currentUser ={0, 0, 0, 0};

void setup() {
  size(480, 640);

  //Configurar e Limpar a Serial Port
  printArray(Serial.list());
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  myPort.clear();

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

  //Variáveis
  countdown = 0;
  seconds = 0;
  filter = 0;
  nomePastaOuput = System.currentTimeMillis() + "";

  pos_x = 15;
  pos_y = height-80;
  div_factor = 11;
}

void draw() {

  //Ler Data
  while (myPort.available() > 0) {
    getData();
  }
  
  image(live_camera, 0, 0);
  filters(filter, live_camera);
  if (trigger_countdown!=true) {
    for (int i=0; i<5; i++) {
      image(live_camera, (pos_x+i*(live_camera.width/div_factor+pos_x)), pos_y, live_camera.width/div_factor, live_camera.height/div_factor);
    }
  }

  filter(GRAY);


  if (trigger_countdown == false) {
    seconds = second();
  } else if (trigger_countdown == true) {
    countdown = second();
    fill(255, 0, 0);
    textSize(60);
    if ((3-(countdown-seconds))!=0) {
      text(3-(countdown-seconds), width/2, height/2);
    }
    if ((countdown-seconds) >= 3) {
      save(sketchPath("exportacao/" + nomePastaOuput + "/" + str(currentUser[0])+" "+str(currentUser[1])+" "+str(currentUser[2])+" "+str(currentUser[3])+ ".jpg"));
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
