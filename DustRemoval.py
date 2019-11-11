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
    
    while(cap.isOpened()):
        ret, frame = cap.read()
        cv2.imshow("Frame", frame)
        if(cv2.waitKey(1) & 0xFF == ord('q')):
            break
    
    cap.release()
    cv2.destroyAllWindows()
# Find Max and Mins to create Imax, Imin
# Calculate b (=Imin)
# Calculate a (=Imax-Imin)
# Find c for each channel through trial and error (use provided equations) <-this is hard part

# Return result with computed c in equation
    
if (__name__ == "__main__"):
    load_source("OriginalFiles\checker_shift.avi")
