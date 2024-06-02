import gab.opencv.*;
import processing.video.*;

// Variáveis para captura de vídeo e processamento de imagem
Capture cam;
OpenCV opencv;
PImage canny, scharr, sobel, pose1, pose2, pose3;
int silhueta;
int lastCaptureTime;
int captureInterval = 10000; // Intervalo de 10 segundos (10000 milissegundos)

void setup() {
  size(1280, 960);
  silhueta = 1;
  lastCaptureTime = 0;

  // Lista todos os dispositivos de captura disponíveis
  String[] devices = Capture.list();
  printArray(devices);

  // Carrega as imagens das silhuetas
  pose1 = loadImage("Silhueta 1.png");
  pose2 = loadImage("Silhueta 2.png");
  pose3 = loadImage("Silhueta 3.png");

  if (devices.length == 0) {
    println("Não há câmeras disponíveis para captura.");
    exit();
  }

  // Inicializa a câmera
  cam = new Capture(this, 640, 480, devices[0]);
  cam.start();
  println("Câmera inicializada: " + devices[0]);

  // Inicializa o OpenCV
  opencv = new OpenCV(this, cam.width, cam.height);
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    println("Frame lido da câmera.");

    // Carrega a imagem da câmera no OpenCV
    opencv.loadImage(cam);

    // Processa e exibe as bordas usando o método Canny
    opencv.findCannyEdges(20, 75);
    canny = opencv.getSnapshot();
    tint(255, 204); // Define a opacidade da imagem
    image(canny, 0, 0, 1280, 960);

    // Processa e exibe as bordas usando o método Scharr
    opencv.loadImage(cam);
    opencv.findScharrEdges(OpenCV.HORIZONTAL);
    scharr = opencv.getSnapshot();

    // Processa e exibe as bordas usando o método Sobel
    opencv.loadImage(cam);
    opencv.findSobelEdges(1, 0);
    sobel = opencv.getSnapshot();

    background(245);

    // Exibe a imagem das bordas Canny
    tint(255, 204); // Redefine a opacidade para a próxima imagem
    image(canny, 0, 0, 1280, 960);

    // Exibe a imagem da silhueta conforme o valor da variável 'silhueta'
    if (silhueta == 1) {
      image(pose1, 0, 0, 1280, 960);
    } else if (silhueta == 2) {
      image(pose2, 0, 0, 1280, 960);
    } else if (silhueta == 3) {
      image(pose3, 0, 0, 1280, 960);
    }

    // Verifica se é hora de salvar um frame
    if (millis() - lastCaptureTime >= captureInterval) {
      saveFrame("output-####.png");
      println("Frame salvo.");
      lastCaptureTime = millis(); // Atualiza o tempo da última captura
    }
  } else {
    println("Frame da câmera não disponível.");
  }

  println("Tempo atual: " + millis());
  println("Tempo da última captura: " + lastCaptureTime);
}

// Função para mudar a silhueta quando uma tecla é liberada
void keyReleased() {
  if (key == '1') {
    silhueta = 1;
  } else if (key == '2') {
    silhueta = 2;
  } else if (key == '3') {
    silhueta = 3;
  }
}
