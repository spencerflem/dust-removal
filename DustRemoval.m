vidObj = VideoReader('checkers.mp4');
vidFrames = read(vidObj);

Imax = max(vidFrames,[],4);
Imin = min(vidFrames,[],4);

a = Imax - Imin;
b = Imin;

r = I(:,:,1);
g = I(:,:,2);
b = I(:,:,3);
[Gmagr,Gdir] = imgradient(r);
n = norm(Gmagr, 1)