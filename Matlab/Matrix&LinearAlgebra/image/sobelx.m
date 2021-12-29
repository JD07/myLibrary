function edges = sobelx(image)
%SOBEL
%    Uses the sobel operator method for edge detection.
%    input: image - 3d array of RGB - pixels containing image
%    output: edges - 3d array of RGB - pixels sobel operator values

image = double(image);

kernelx = [ -1, 0, 1;
            -2, 0, 2;
            -1, 0, 1];

height = size(image,1);
width = size(image,2);

for i = 2:height - 1
    for j = 2:width - 1
        magx = 0;
        for a = 1:3
            for b = 1:3
                magx = magx + (kernelx(a, b) * image(i + a - 2, j + b - 2));
            end
        end     
        edges(i,j) = (magx); %#ok<AGROW>
    end
end