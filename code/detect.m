function [x,y,score] = detect(I,template,ndet)
%% Information
% return top ndet detections found by applying template to the given image.
% Output:
%   score should contain the scores of the detections
% Input:
%   Image - I
%   Template image - template
%   Number of matches to return - ndet
% How to run:
%   Use the script: detect_script.m
%% Compute histogram-of-gradient-orientation
ohist = hog(I);
%% Get the cross-correlations of the image and the template
correlation = zeros(size(ohist,1), size(ohist,2));
for i = 1:size(ohist, 3)
    correlation = correlation + filter2(template(:,:,i), ohist(:,:,i), 'same');
end
% figure;
% imagesc(correlation); % Print the correlation heatmap
% colormap jet;
% figure, surf(correlation), shading flat % Print a correlation height field
%% Sort the correlation response
[sorted_vals, In] = sort(correlation(:), 'descend');
%% Get the scores and the x and y values
x = [];
y = [];
score = [];
for i = 1:size(sorted_vals,1)
    % Get the x and y values of the high match
    y_temporary = mod(In(i), size(ohist,1));
    if(y_temporary == 0)
        y_temporary = size(ohist,1);
    end
    x_temporary = In(i) / size(ohist,1);
    x = [x; x_temporary * 8];
    y = [y; y_temporary * 8];
    score = [score; sorted_vals(i)];
end
[x, y, score, scales] = maximum_suppression(I, x, y, score, 1, ndet);
end

