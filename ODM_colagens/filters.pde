void filters(int filter, PImage capture) {

  //Possibilidades de filtros: Swirl, Formas, Blurred

  int [] img_x = new int[int((height/10)*1.6)];
  int [] img_y = new int [(height/10)];

  capture.loadPixels();

  if (filter == 0) {
    noTint();
  } else if (filter == 1) {
    filter(THRESHOLD);
  } else if (filter == 2) {
    filter(POSTERIZE, 4);
  } else if (filter == 3) {
    filter(BLUR, 5);
  } else if (filter == 4) {

    for (int i=0; i<img_x.length; i++) {
      for (int j=0; j<img_y.length; j++) {

        int x = i * 10;
        int y = j * 10;

        int loc = (x+y*capture.width);
        float pixel_brightness = brightness(capture.pixels[loc]);
        noStroke();
        fill(pixel_brightness);
        
        //rect(x, y, 10, 10);
        circle(x,y,10);
      }
    }
  } else if (filter == 5) {

    float threshold = 170;

    for (int i=0; i<img_x.length; i++) {
      for (int j=0; j<img_y.length; j++) {

        int x = i * 10;
        int y = j * 10;

        int loc = (x+y*capture.width);
        float pixel_brightness = brightness(capture.pixels[loc]);
        
        textSize(int(random(4,16)));
        
        if (pixel_brightness > threshold) {
          fill(255);
          text("lagen", x, y);
        } else {
          fill(0);
          text("lagen", x, y);
        }
      }
    }
  }

  capture.updatePixels();
}
