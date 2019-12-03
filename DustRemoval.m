clear
clc

calib_num = 17;
src = "saw2";
file_type = ".jpg";

for f = 1:calib_num
   calibFrames(:,:,:,f) = double(imread(src + "/c" + f + file_type))./255; 
   disp("Loaded image #" + f)
end

i = double(imread(src + "/t1" + file_type))./255;

Imax = max(calibFrames,[],4);
Imin = min(calibFrames,[],4);

top = median(median(Imax,1),2);
bot = median(median(Imin,1),2);

a = (Imax - Imin)./(top-bot);
b = (Imin.*top - Imax.*bot)./(top-bot);

i0 = optimal_i0(i, a, b);
i08 = uint8(i0.*255);

imwrite(i08, src + "\x_v2_testi0.png")
imshow(i08)

%Compute the optimal i0 one channel at a time
function i0 = optimal_i0(i, a, b)
    disp('Beginning optimization')
    i0 = double(zeros(size(i)));
    for x = 1:size(i0, 3)   % For each color dimension - if grayscale, only 1 dimension present, if color, 3 (rgb)
        disp("Finding optimal c" + x)
        c = optimal_c(i(:,:,x), a(:,:,x), b(:,:,x));
        disp("Recovering i0 on channel" + x)
        ci0 = get_i0(i(:,:,x), a(:,:,x), b(:,:,x), c);
        i0(:,:,x) = ci0;
    end
end

%Compute i0 given all the paramters
function i0 = get_i0(i, a, b, c)
    i0 = ((i-c.*b)./(a));
end

%Calculate the gradient norm (what the optimizer wants to minimize)
function n = gradient_norm(i, a, b, c)
    i0 = get_i0(i, a, b, c);
    [grad,~] = imgradient(i0);
    n = norm(grad, 1)
end

%Caluclate the optimal C by iterating over gradient norms
%Uses fancy-dancy anonomous functions and partial application
function c_star = optimal_c(i, a, b)
    partial_func = @(c) gradient_norm(i, a, b, c);
    c_star = fminsearch(partial_func, 0.7)
end

