%vidObj = VideoReader('checkers.mp4');
%calibFrames = read(vidObj);

%Read in the sample frames
%These were made in GIMP by adding two layers
%One with blend mode: multiply to simulate the attenuation
%One with blend mode: normal + alpha to simulate the reflectance
%both were gaussian blurred with size 25
%Then two calibration images were made to allow max an min
%This should be the same as a checkerboard
%TODO: lets try this on real images!
calibFrames(:,:,:,1) = double(imread('testcalibleft2.png'));
calibFrames(:,:,:,2) = double(imread('testcalibright2.png'));
i = double(imread('testimg2.png'));

Imax = max(calibFrames,[],4);
Imin = min(calibFrames,[],4);

a = Imax - Imin;
b = Imin;

i0 = optimal_i0(i, a, b);

imwrite(i0, 'x_testi0.png')
imshow(i0)

%Compute the optimal i0 one channel at a time
function i0 = optimal_i0(i, a, b)
    i0 = uint8(zeros(size(i)));
    for x = 1:size(i0, 3)
        c = optimal_c(i(:,:,x), a(:,:,x), b(:,:,x))
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
    n = norm(grad); %NOTE: NOT L1 NORM! %This worked *much* better
end

%Caluclate the optimal C by iterating over gradient norms
%Uses fancy-dancy anonomous functions and partial application
function c = optimal_c(i, a, b)
    partial_func = @(c) gradient_norm(i, a, b, c);
    c = fminsearch(partial_func, 0.5);
end

