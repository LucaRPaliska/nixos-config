#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

static unsigned char gray(unsigned char r, unsigned char g, unsigned char b) {
  return (unsigned char)(0.299f * r + 0.587f * g + 0.114f * b);
}

int main(int argc, char **argv) {
  if (argc < 2) {
    printf("Usage: %s <image> [--normalize] [--invert] [--upscale <n>]\n", argv[0]);
    printf("  --normalize     stretch contrast to full 0-255 range\n");
    printf("  --invert        bright areas -> small circles, dark areas -> large circles\n");
    printf("  --upscale <n>   multiply output resolution by n (default: 1)\n");
    return 1;
  }

  int normalize = 0, invert = 0, upscale = 1;
  for (int i = 2; i < argc; i++) {
    if (strcmp(argv[i], "--normalize") == 0) normalize = 1;
    if (strcmp(argv[i], "--invert") == 0) invert = 1;
    if (strcmp(argv[i], "--upscale") == 0 && i + 1 < argc) upscale = atoi(argv[++i]);
  }
  if (upscale < 1) upscale = 1;

  int width, height, channels;
  unsigned char *img = stbi_load(argv[1], &width, &height, &channels, 3);

  if (!img) {
    printf("Failed to load image: %s\n", argv[1]);
    return 1;
  }

  const int sizes = 8;        // number of circle size buckets
  const int grid = 5;         // grid cell size in pixels
  const float overlap = 1.1f; // makes circles touch nicely at max size

  // sqrt curve gives perceptually even steps between circle sizes
  float ratios[sizes + 1];
  for (int i = 0; i <= sizes; i++) {
    ratios[i] = sqrtf((float)i / sizes);
  }

  // Compute grayscale for every pixel, optionally stretching to full range
  int total_pixels = width * height;
  unsigned char *gray_img = malloc(total_pixels);
  if (!gray_img) {
    printf("Out of memory\n");
    stbi_image_free(img);
    return 1;
  }
  for (int k = 0; k < total_pixels; k++) {
    unsigned char *p = img + k * 3;
    gray_img[k] = gray(p[0], p[1], p[2]);
  }
  if (invert) {
    for (int k = 0; k < total_pixels; k++) {
      gray_img[k] = 255 - gray_img[k];
    }
  }
  if (normalize) {
    unsigned char lo = 255, hi = 0;
    for (int k = 0; k < total_pixels; k++) {
      if (gray_img[k] < lo) lo = gray_img[k];
      if (gray_img[k] > hi) hi = gray_img[k];
    }
    printf("Normalizing: gray range [%d, %d] -> [0, 255]\n", lo, hi);
    float range = (hi > lo) ? (float)(hi - lo) : 1.0f;
    for (int k = 0; k < total_pixels; k++) {
      gray_img[k] = (unsigned char)((gray_img[k] - lo) * 255.0f / range);
    }
  }

  // If resolution isn't divisible by grid, center the grid
  int startX = (width % grid) / 2;
  int startY = (height % grid) / 2;
  int resx = width - (width % grid);
  int resy = height - (height % grid);

  // Output image: black background, white circles (upscaled)
  int out_width = width * upscale;
  int out_height = height * upscale;
  unsigned char *out_img = calloc(out_width * out_height * 3, 1);
  if (!out_img) {
    printf("Out of memory\n");
    free(gray_img);
    stbi_image_free(img);
    return 1;
  }

  int cells_x = resx / grid;
  int cells_y = resy / grid;
  int *cell_avgs = malloc(cells_x * cells_y * sizeof(int));
  if (!cell_avgs) {
    printf("Out of memory\n");
    free(gray_img);
    free(out_img);
    stbi_image_free(img);
    return 1;
  }

  // First pass: compute all cell averages
  int max_avg = 1; // avoid div by zero
  for (int i = 0; i < cells_x; i++) {
    for (int j = 0; j < cells_y; j++) {
      int sum = 0;
      for (int x = i*grid + startX; x < (i+1)*grid + startX; x++) {
        for (int y = j*grid + startY; y < (j+1)*grid + startY; y++) {
          sum += gray_img[y * width + x];
        }
      }
      int avg = sum / (grid * grid);
      cell_avgs[j * cells_x + i] = avg;
      if (avg > max_avg) max_avg = avg;
    }
  }

  // Second pass: bin against actual max so brightest cell always hits ratio 1.0
  for (int i = 0; i < cells_x; i++) {
    for (int j = 0; j < cells_y; j++) {
      int avg = cell_avgs[j * cells_x + i];
      int bin = avg * sizes / max_avg;
      if (bin > sizes) bin = sizes;
      float radius = (grid * upscale * 0.5f) * ratios[bin] * overlap;

      // Circle center in upscaled output
      float cx = (i*grid + startX + grid / 2.0f) * upscale;
      float cy = (j*grid + startY + grid / 2.0f) * upscale;

      // Draw anti-aliased circle into upscaled output
      int x0 = (i*grid + startX) * upscale;
      int x1 = ((i+1)*grid + startX) * upscale;
      int y0 = (j*grid + startY) * upscale;
      int y1 = ((j+1)*grid + startY) * upscale;
      for (int x = x0; x < x1; x++) {
        for (int y = y0; y < y1; y++) {
          float dx = x - cx;
          float dy = y - cy;
          float dist = sqrtf(dx*dx + dy*dy);
          float edge = radius - dist;
          int val;
          if (edge > 1.0f)       val = 255;
          else if (edge < -1.0f) val = 0;
          else                   val = (int)((edge + 1.0f) * 127.5f);
          unsigned char *out_pixel = out_img + (y * out_width + x) * 3;
          out_pixel[0] = out_pixel[1] = out_pixel[2] = (unsigned char)val;
        }
      }
    }
  }

  stbi_write_png("output.png", out_width, out_height, 3, out_img, out_width * 3);
  printf("Written to output.png\n");

  free(cell_avgs);
  free(gray_img);
  free(out_img);
  stbi_image_free(img);
  return 0;
}
