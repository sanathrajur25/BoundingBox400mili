from datetime import datetime as dt

import numpy as np
from cv2 import IMREAD_GRAYSCALE, Canny, imread, imwrite
from numpy import argwhere as arg
from PIL import Image as im


#get the starting time
def process_image():

    red=(255,0,0)
    
    #ROI points
    rx1,ry1,rx2,ry4=342,521,2286,1745

    start=dt.now()

    LOGFile=open("D:\\Intership\\Renovus\\Camera_python\\PyInt\\Integrate\\trial\\LOGFile.txt","w")
    LOGFile.write("\n//Start time ://"+str(start))
    path=path="D:\\Intership\\Renovus\\Camera_python\\PyInt\\Integrate\\component_images\\image0000008.bmp"

    gray_image=imread(path,IMREAD_GRAYSCALE)

    edgedetect=Canny(gray_image,100,200)

    imwrite("detectededge.bmp",edgedetect)

    edge_detected=im.open("detectededge.bmp")
    
    #top
    edge_array = np.array(edge_detected)

    mask = (edge_array[ry1:ry4-1, rx1:rx2-1] == 255)

    # Find the indices where the mask is True
    indices = np.argwhere(mask)

    if indices.size > 0:
        y1, x1 = indices[0] + np.array([ry1, rx1])
        print(f"{x1},{y1}")
    
    #bottom
    y2, x2 = None, None
    edge_array = np.array(edge_detected)

    for i in range(ry4 - 1, ry1 - 1, -1):
        row_slice = edge_array[i, rx1 - 1:rx2 - 1][::-1]
        if np.any(row_slice == 255):
            x2 = rx1 - 1 + len(row_slice) - 1 - np.argmax(row_slice == 255)
            y2 = i
            break

    if x2 is not None:
        print(f"{x2},{y2}")

    centerX=round((x1+x2)/2)
    centerY=round((y1+y2)/2)
    radius=centerY-y1
    #find left and right side of x axis
    x3=centerX-radius
    x4=centerX+radius

    i = x3
    while i < rx2:
        color = edge_array[centerY, i]
        if color != 0:
            x3 = i
            break
        i += 1

    if x3 is not None:
        print(f"Found at x={x3}")
    
    i = x4
    while i < rx2:
        color = edge_array[centerY, i]
        if color != 0:
            x4 = i
            break
        i += 1

    if x4 is not None:
        print(f"Found at x={x4}")

    normal_image=im.open(path)
    i=x3
    while(i<x4):
        normal_image.putpixel((i,y1),red)
        normal_image.putpixel((i,y2),red)
        i=i+1

    j=y1
    while(j<y2):
        normal_image.putpixel((x3,j),red)
        normal_image.putpixel((x4,j),red)
        j=j+1
    #Stopping last part
    normal_image.save("check.bmp")
    endtime=dt.now()
    print(abs(start-endtime))

