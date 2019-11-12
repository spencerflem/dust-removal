import cv2
import numpy as np

cap = cv2.VideoCapture('lens_calib.avi')
frameCount = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
frameWidth = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
frameHeight = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

buf = np.empty((frameCount, frameHeight, frameWidth, 3), np.dtype('uint8'))

fc = 0
ret = True

while (fc < frameCount and ret):
    ret, buf[fc] = cap.read()
    fc += 1

cap.release()

print(buf.shape)

min = np.amin(buf, axis=0)
max = np.amax(buf, axis=0)

cv2.imshow('a', max-min)
cv2.imshow('b', min)
cv2.waitKey(0)