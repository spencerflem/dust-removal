# -*- coding: utf-8 -*-
"""
Created on Mon Nov 11 13:26:36 2019

@author: Tomek
"""

import cv2
import numpy as np


# Load video/images for calibration
def load_source(filename):
    cap = cv2.VideoCapture(filename)
    f = 0
    vid_array = []

    while True:
        ret, frame = cap.read()
        if ret:
            vid_array.append(frame)
        else:
            break
    cap.release()
    return vid_array


# Find Max and Mins to create Imax, Imin
def min_max(frames):
    min = np.amin(frames, 0)
    max = np.amax(frames, 0)
    return min, max


# Calculate a (=Imax-Imin)
# Calculate b (=Imin)
def a_b(i_min, i_max):
    a = i_max - i_min
    b = i_min
    return a, b


def grad(image):
    grads = np.gradient(image)

    y_dir = grads[0]    # Grad 0 is y-axis
    x_dir = grads[1]    # Grad 1 in x-axis
    y_dir_squared = np.power(y_dir, 2)
    x_dir_squared = np.power(x_dir, 2)
    magnitude = x_dir_squared + y_dir_squared

    return magnitude


def norm_l1(gradient):
    np.linalg.norm(gradient, 1)

# Find c for each channel through trial and error (use provided equations) <-this is hard part

# Return result with computed c in equation


if __name__ == "__main__":
    #video_array = load_source(r"OriginalFiles\checker_shift.avi")
    #(Imin, Imax) = min_max(video_array)
    Imax = cv2.imread("test_image.png")
    cv2.imshow("Max", Imax)
    #grad = np.gradient(cv2.cvtColor(Imax,cv2.COLOR_BGR2GRAY))

    cv2.imshow("Grad0", grad[0]/255)
    cv2.imshow("Grad1", grad[1]/255)
    cv2.imshow("Grad2", grad[2]/255)

    cv2.waitKey()
    print("End of the line")