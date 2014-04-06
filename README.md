# Chinese Menu Reader

Chinese Menu Reader is an iOS application that takes a picture of a dish name on a Chinese menu and gives you some information about the dish, including a translation, a description, user reviews and tags.

This repository has the Xcode project for the iOS application. For the server code, [check out this repository](https://github.com/ejanzer/menureader).

## How to use it
![Screenshot 1: Open the app](https://raw.githubusercontent.com/ejanzer/menureader/master/screenshots/app1.jpg)

1. Take a photo of a menu or choose one from your photo library.

![Screenshot 2: Take a photo](https://raw.githubusercontent.com/ejanzer/menureader/master/screenshots/app2.jpg)

2. Crop the image around the dish you’d like to look up.

![Screenshot 3: Crop the image](https://raw.githubusercontent.com/ejanzer/menureader/master/screenshots/app3.jpg)

3. Tap “Search” to upload the image to the server.

![Screenshot 4: Dish information](https://raw.githubusercontent.com/ejanzer/menureader/master/screenshots/app4.jpg)

4a. If the dish exists, the server will return some information about the dish. Tap on a tag to see other dishes with the same tag.

![Screenshot 5: Reviews and tags](https://raw.githubusercontent.com/ejanzer/menureader/master/screenshots/app5.jpg)

4b. If the dish doesn’t exist, the server will try to translate the dish name using [CEDICT](http://cc-cedict.org/wiki/). Tap on a similar dish to go to that dish’s page.

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