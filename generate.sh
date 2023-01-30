#!/bin/sh
#
# Written by halina20011
#
# To run this script you will need to first need to install all required dependencies.
# yay -S imagemagick

## How to use it
# Monitor sizes are passed from left to rigth
#
# You can run script two ways: </br>
# 1. Automatic (only when you have two monitors) </br>
#         ```$ ./generate.sh [image1]```
#         ```$ ./generate.sh [image1] [image2]```
#
# 2. Manual ([image]/[image1] [image2]) [width of first monitor] [height of first monitor] [width of second monitor] [height of second monitor] </br>
#     ``` $ generate.sh [image] [w1] [h1] [w2] [h2]```
#     ``` $ generate.sh [image1] [image2] [w1] [h1] [w2] [h2]```

# Get all current sizes of monitors
#   Example:
#   1366x768      60.04*+
#   1920x1080     60.00*+  50.00    59.94
xrandr=($(xrandr | grep "*"))

echo "xrandr output list: ${xrandr[@]}"
echo "xrandr output list: ${#xrandr[@]}"

listOfDimensions=()

for (( i = 0; i < ${#xrandr[@]}; i++ )); do
    if [[ ${xrandr[i]} == *x* ]]; then #If String contains "x" (1366x768)
        string=${xrandr[i]}
        end=${#string}

        for (( x = 0; x < $end; x++ )); do
            _letter=${string:x:1} # 1366x768 {string:position:length}
            if [[ $_letter == "x" ]]; then          #x = 4 (index of "x")
                _w=${string:0:x}                      #_w={str:0:4} 
                _h=${string:$((x + 1)):$((end - x))}  #_h={str:4 + 1:8 - 4}
                dim=($_w $_h)                         
                listOfDimensions+=(${dim[@]})
                echo "W:H $_w:$_h"
            fi
        done
    fi
done

echo "Number of dimensions arguments: ${#listOfDimensions[@]}"
echo ${listOfDimensions[@]}

#The total number of arguments passed to the script.
arguments=$#

echo "Number of script arguments: $arguments"

w1=0
h1=0

w2=0
h2=0

img1=$(realpath $1)
img2=""

twoImages=0

echo "Number of arguments: $arguments"

if [[ $arguments == 5 ]]; then
    w1=$2
    h1=$3

    w2=$4
    h2=$5
elif [[ $arguments == 6 ]]; then
    img2=$(realpath $2)
    twoImages=1
    
    w1=$3
    h1=$4

    w2=$5
    h2=$6
elif [[ ${#listOfDimensions[@]} == 4 ]]; then
    w1=${listOfDimensions[0]}
    h1=${listOfDimensions[1]}

    w2=${listOfDimensions[2]}
    h2=${listOfDimensions[3]}
elif [[ $arguments != 5 ]]; then
    echo "Error: Wrong number of argumens."
    exit -1
fi

function checkImage () {
    echo Image $1
    img=$1
    if [ ! -f $img ]; then
        echo "Error: $img doesn't exist"
        exit -1
    fi
}

checkImage $img1
echo "Img1 path: $img1"

if [ $twoImages == 1 ]; then 
    echo Two images: $twoImagesa
    checkImage $img2
    echo "Img2 path: $img2"
fi


echo "Size: [${w1}x${h1}] [${w2}x${h2}]"

# Generate first image
bigger=""
firstImage=$img1
secondImage=$img1

height=$h1

if [[ $h1 -lt $h2 ]]; then
    height=$h2
    echo "Second display is bigger then the first one"

    bigger=second

    if [ $twoImages == 1 ]; then 
        secondImage=$img1
        firstImage=$img2
    fi
elif [ $h2 -lt $h1 ]; then
    echo "First display is bigger then the second one"

    bigger=first

    if [ $twoImages == 1 ]; then 
        firstImage=$img1
        secondImage=$img2
    fi
else
    echo "Displays are same in height"
    bigger=none
    if [ $twoImages == 1 ]; then 
        secondImage=$img1
        firstImage=$img2
    fi
fi

echo "Bigger monitor is: ${bigger} with height ${height}"

# Extend smaller image to match bigger display
if [ $bigger == second ]; then
    echo "Resizing image for first monitor to: ${w1}x${height}"
    convert $firstImage -scale ${w1}^x${h1}^ -gravity North -extent ${w1}x${height} monitor1.png

    echo "Resizing image for second monitor to: ${w2}x${height}"
    convert $secondImage -scale ${w2}x${height}\! monitor2.png
elif [ $bigger == first ]; then
    echo "Resizing image for first monitor to: ${w1}x${height}"
    convert $firstImage -scale ${w1}x${height}\! monitor1.png

    echo "Resizing image for second monitor to: ${w2}x${height}"
    convert $secondImage -scale ${w2}^x${h2}^ -gravity North -extent ${w2}x${height} monitor2.png
else
    convert $firstImage -scale ${w1}x${height}\! monitor1.png
    convert $secondImage -scale ${w2}x${height}\! monitor2.png
fi

convert +append monitor1.png monitor2.png lockImg.png

echo "Image was generated successfully"

rm monitor1.png 
rm monitor2.png
