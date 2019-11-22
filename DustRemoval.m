% vidObj = VideoReader('bars.mp4');
% calibFrames = read(vidObj);

%Read in the sample frames
%These were made in GIMP by adding two layers
%One with blend mode: multiply to simulate the attenuation
%One with blend mode: normal + alpha to simulate the reflectance
%both were gaussian blurred with size 25
%Then two calibration images were made to allow max an min
%This should be the same as a checkerboard
%TODO: lets try this on real images!
% calibFrames(:,:,:,1) = double(imread('testcalibleft2.png'));
% calibFrames(:,:,:,2) = double(imread('testcalibright2.png'));

clear
clc

calib_num = 14;
src = './pocket_dust';

for f = 1:calib_num
   calibFrames(:,:,:,f) = double(imread([src, '/c', int2str(f), '.jpg'])); 
   disp("Loaded image #" + f)
end

% i = double(imread('testimg2.png'));
i = double(imread([src, '/t1.jpg']));

Imax = max(calibFrames,[],4);
Imin = min(calibFrames,[],4);

top = median(median(Imax,1),2);
bot = median(median(Imin,1),2);

Smax = 255*(Imax-bot)./(top-bot);
Smin = 255*(Imin-bot)./(top-bot);

a = Smax - Smin;
b = Smin;

i0 = optimal_i0(i, a, b);

imwrite(i0, src + "\x_testi0.png")
imshow(i0)

%Compute the optimal i0 one channel at a time
function i0 = optimal_i0(i, a, b)
    disp('Beginning optimization')
    i0 = uint8(zeros(size(i)));
    for x = 1:size(i0, 3)   % For each color dimension - if grayscale, only 1 dimension present, if color, 3 (rgb)
        disp("Finding optimal c" + x)
        c = optimal_c(i(:,:,x), a(:,:,x), b(:,:,x));
        disp("Recovering i0 on channel" + x)
        ci0 = get_i0(i(:,:,x), a(:,:,x), b(:,:,x), c);
        i0(:,:,x) = uint8(ci0);
    end
end

%Compute i0 given all the paramters
%Note: The 255 is because A is out of 0-255, not 0-1, so dividing would make everything too small
function i0 = get_i0(i, a, b, c)
    i0 = ((i-c*b).*(255./a));
end

%Calculate the gradient norm (what the optimizer wants to minimize)
function n = gradient_norm(i, a, b, c)
    i0 = get_i0(i, a, b, c);
    [grad,~] = imgradient(i0);
    n = norm(grad) %NOTE: NOT L1 NORM! %This worked *much* better
end

%Caluclate the optimal C by iterating over gradient norms
%Uses fancy-dancy anonomous functions and partial application
function c_star = optimal_c(i, a, b)
    partial_func = @(c) gradient_norm(i, a, b, c);
    c_star = fminsearch(partial_func, 0.5)
end

