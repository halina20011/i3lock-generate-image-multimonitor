# Generate image lock for multimonitor
This is shell script that will generate for you lock image for your setup when you have more then one monitor(2 <= x)
When you have more then 2 monitors you will need to run this script more time. First make image from first two monitors and then this use generated image with original one to make the lock image (Look into [Manual for three monitors](#manual-for-three-monitors) for more info).

## Dependencies </br>
`imagemagick`

## How to use it
Monitor sizes are passed from left to rigth

You can run script two ways: </br>
1. Automatic (only when you have two monitors) </br>
    ```$ ./generate.sh [image1]```
    ```$ ./generate.sh [image1] [image2]```

2. Manual ([image]/[image1] [image2]) [width of first monitor] [height of first monitor] [width of second monitor] [height of second monitor] </br>
    ``` $ generate.sh [image] [w1] [h1] [w2] [h2]```
    ``` $ generate.sh [image1] [image2] [w1] [h1] [w2] [h2]```

# Some examples
## Manual for two monitors </br>
```./generate.sh ./Images/archWallpaper.png 1366 768 1920 1080``` </br>
![Image](/Images/twoMonitors.png)

## Manual for three monitors </br>
Generate image for first two monitors from left </br>
```./generate.sh ./Images/archWallpaper.png 1366 768 1920 1080``` </br>
then width is sum from first two monitors and the bigger height </br>
```./generate.sh lockImg.png ./Images/archWallpaper.png 3286 1080 1366 768``` </br>
`lockImg.png` is image that was generated one step before </br>
![Image](/Images/threeMonitors.png)
