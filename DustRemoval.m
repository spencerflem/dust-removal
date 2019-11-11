%vidObj = VideoReader('checkers.mp4');
%calibFrames = read(vidObj);

calibFrames(0) = imread('testcalibleft.png');
calibFrames(1) = imread('testcalibright.png');
i = imread('testimg.png');

Imax = max(calibFrames,[],4);
Imin = min(calibFrames,[],4);

a = Imax - Imin;
b = Imin;

i0 = optimal_i0(i, a, b);
imshow(i0)

function i0 = optimal_i0(i, a, b)
    i0 = zeros(size(i));
    for x = 1:3
        c = optimal_c(i(:,:,x), a(:,:,x), b(:,:,x))
        i0(:,:,x) = get_i0(i(:,:,x), a(:,:,x), b(:,:,x), c);
    end
end

function i0 = get_i0(i, a, b, c)
    i0 = (i-c*b)./a;
end

function n = gradient_norm(i, a, b, c)
    i0 = get_i0(i, a, b, c);
    [Gmagr,~] = imgradient(i0);
    n = norm(Gmagr, 1);
end

function c = optimal_c(i, a, b)
    partial_func = @(c) gradient_norm(i, a, b, c);
    c = fminsearch(partial_func, 0.5);
end

