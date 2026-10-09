// Comic Filter
// Personal portfolio version
//
// Controls:
// R = reset image
// P = posterize
// B = apply one 3x3 box blur
// E = Sobel edge view
// C = complete comic effect
// S = save current result as output.png

PImage sourceImage;
PImage displayImage;

int posterizeLevels = 5;
float edgeThreshold = 100;

void setup() {
  size(480, 360);
  pixelDensity(1);

  sourceImage = loadImage("input.jpg");
  sourceImage.resize(width, height);
  displayImage = sourceImage.copy();
}

void draw() {
  image(displayImage, 0, 0);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    displayImage = sourceImage.copy();
  } else if (key == 'p' || key == 'P') {
    displayImage = posterize(sourceImage, posterizeLevels);
  } else if (key == 'b' || key == 'B') {
    displayImage = boxBlur3x3(displayImage);
  } else if (key == 'e' || key == 'E') {
    displayImage = sobelEdges(sourceImage, edgeThreshold);
  } else if (key == 'c' || key == 'C') {
    displayImage = comicEffect(sourceImage);
  } else if (key == 's' || key == 'S') {
    displayImage.save("output.png");
    println("Saved output.png");
  }
}

PImage posterize(PImage input, int levels) {
  PImage result = createImage(input.width, input.height, RGB);
  input.loadPixels();
  result.loadPixels();

  int safeLevels = max(levels, 2);
  float step = 255.0 / (safeLevels - 1);

  for (int i = 0; i < input.pixels.length; i++) {
    color c = input.pixels[i];
    float r = round(red(c) / step) * step;
    float g = round(green(c) / step) * step;
    float b = round(blue(c) / step) * step;
    result.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }

  result.updatePixels();
  return result;
}

PImage boxBlur3x3(PImage input) {
  PImage result = createImage(input.width, input.height, RGB);
  input.loadPixels();
  result.loadPixels();

  for (int y = 0; y < input.height; y++) {
    for (int x = 0; x < input.width; x++) {
      float sumR = 0;
      float sumG = 0;
      float sumB = 0;

      for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
          int sx = constrain(x + dx, 0, input.width - 1);
          int sy = constrain(y + dy, 0, input.height - 1);
          color c = input.pixels[sx + sy * input.width];
          sumR += red(c);
          sumG += green(c);
          sumB += blue(c);
        }
      }

      result.pixels[x + y * input.width] = color(sumR / 9.0, sumG / 9.0, sumB / 9.0);
    }
  }

  result.updatePixels();
  return result;
}

PImage sobelEdges(PImage input, float threshold) {
  PImage result = createImage(input.width, input.height, RGB);
  input.loadPixels();
  result.loadPixels();

  for (int y = 1; y < input.height - 1; y++) {
    for (int x = 1; x < input.width - 1; x++) {
      float gx =
          luminanceAt(input, x - 1, y - 1) - luminanceAt(input, x + 1, y - 1)
        + 2 * luminanceAt(input, x - 1, y) - 2 * luminanceAt(input, x + 1, y)
        + luminanceAt(input, x - 1, y + 1) - luminanceAt(input, x + 1, y + 1);

      float gy =
          luminanceAt(input, x - 1, y - 1) + 2 * luminanceAt(input, x, y - 1) + luminanceAt(input, x + 1, y - 1)
        - luminanceAt(input, x - 1, y + 1) - 2 * luminanceAt(input, x, y + 1) - luminanceAt(input, x + 1, y + 1);

      float magnitude = sqrt(gx * gx + gy * gy);
      result.pixels[x + y * input.width] = magnitude > threshold ? color(255) : color(0);
    }
  }

  result.updatePixels();
  return result;
}

float luminanceAt(PImage image, int x, int y) {
  color c = image.pixels[x + y * image.width];
  return 0.299 * red(c) + 0.587 * green(c) + 0.114 * blue(c);
}

PImage comicEffect(PImage input) {
  PImage blurred = boxBlur3x3(input);
  blurred = boxBlur3x3(blurred);

  PImage colors = posterize(blurred, posterizeLevels);
  PImage edges = sobelEdges(blurred, edgeThreshold);
  PImage result = colors.copy();

  colors.loadPixels();
  edges.loadPixels();
  result.loadPixels();

  for (int i = 0; i < result.pixels.length; i++) {
    result.pixels[i] = red(edges.pixels[i]) == 255 ? color(0) : colors.pixels[i];
  }

  result.updatePixels();
  return result;
}
