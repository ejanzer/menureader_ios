# Chinese Menu Reader

Chinese Menu Reader is a mobile application that takes a picture of a dish name on a Chinese menu and gives you an English translation of the dish name, a description, reviews, photos and tags.

This repository contains the code for the Python server. For the iOS application, [check out this repository](https://github.com/ejanzer/menureader_ios).

![Crop an image](https://raw.githubusercontent.com/ejanzer/menureader/master/screenshots/app3.jpg)
![Dish information](https://raw.githubusercontent.com/ejanzer/menureader/master/screenshots/app4.jpg)
![Reviews and tags](https://raw.githubusercontent.com/ejanzer/menureader/master/screenshots/app5.jpg)

## How it works

The iOS application takes the image, crops it, and uploads it to the Python server. The Python server does some basic image processing (smoothing, converting to grayscale, binarizing/thresholding) and then uses [Google Tesseract OCR](https://code.google.com/p/tesseract-ocr/) to get a string of Chinese characters from the image. If Tesseract fails to recognize any characters in the image, the server thins the image (using Stentiford's preprocessing steps and Scikit-Image's skeletonize() function) and runs it through Tesseract again. 

If Tesseract returns characters, the server looks them up first in a dishes table. If a dish is found, it returns a JSON object representing that dish. If not, it attempts to translate the characters relying first on a list of common food words and finally on [CEDICT](http://cc-cedict.org/wiki/), an open source Chinese dictionary maintained by [MDBG](http://www.mdbg.net/).

### Installation

1. Clone the repository.

    <code>git clone https://github.com/ejanzer/menureader_ios.git</code>

2. Open the directory with Xcode.

3. In <code>Server.h</code>, change <code>kBaseURL</code> to the address of your Python server ([find the server code here](https://github.com/ejanzer/menureader))

4. Connect your iPhone.

5. Change the target device from the simulator to your connected device (top left corner).

6. Build and run!

### Notes

For best results, take a picture with your camera about 6 inches away from the menu and then zoom in and crop around the name of the dish you want to translate. Try to hold the menu straight and avoid blur if possible.

Tesseract has trouble recognizing some Chinese characters that have vertical space between two halves or radicals. I haven't yet figured out how to address this problem, so the app will have trouble recognizing dish names with these characters, especially if the font accentuates these spaces.