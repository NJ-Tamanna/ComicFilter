# Comic Filter

A Processing image-processing project that combines posterization, repeated 3x3 box blur, and Sobel edge detection to create a comic-style image.

## Features

- RGB posterization
- 3x3 neighborhood averaging blur
- Sobel gradient edge detection
- Adjustable edge threshold
- Combined comic-style rendering
- Keyboard controls for viewing each processing stage

## Controls

- `R` reset
- `P` posterize
- `B` apply one blur pass
- `E` show Sobel edges
- `C` build the complete comic effect
- `S` save the current result

## Add your own image

The repository intentionally does not include the original course-provided sample image. Put an image that you own, created yourself, or are licensed to redistribute into the `data` folder and name it:

`input.jpg`

The sketch resizes that image to 480 x 360 when it starts.


### Included sample image

This prepared package includes a simple synthetic `input.jpg` created specifically for this portfolio bundle so the sketch runs immediately. You may replace it with your own photograph later.
