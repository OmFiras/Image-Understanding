function ohist = hog(I)
%% Information
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
% Input:
%   I:          grayscale image of dimension HxW
% Output:
%   ohist:      orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
% Tips:
% normalize the histogram so that sum over orientation bins is 1 for each block
%   NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 
%% Get the magnitude and orientation of the image gradient
[mag, ori] = mygradient(I);
%% Set the threshold
thresh = 0.1 * max(mag(:));
%% Get binary data for the image
orientation = [-pi:0.7392:pi, pi];
orientations = zeros(size(I,1), size(I,2), 9);
for i = 1:size(orientation,2)-1
    range = [orientation(i), orientation(i+1)];
    logical1 = ori >= range(1) & ori < range(2);
    logical2 = mag > thresh;
    orientations(:,:,i) = logical1 & logical2;
end
%% Get the 8x8 block histogram
ohist = zeros(ceil(size(I,1)/8), ceil(size(I,2)/8), 9);
blocks = [];
for i = 1:9
    blocks(:,:,i) = sum(im2col(orientations(:,:,i), [8 8], 'distinct'),1);
    % Reshape the histogram
    ohist(:,:,i) = reshape(blocks(:,:,i), [ceil(size(I,1)/8), ceil(size(I,2)/8)]);
end
%% Normalize the histogram
for i = 1:size(ohist,1)
    for j = 1:size(ohist,2)
        temp = [];
        for k = 1:size(ohist,3)
            temp = [temp; ohist(i,j,k)];
        end
        if(norm(temp,1) ~= 0)
            temp = temp / norm(temp,1);
        end
        for k = 1:size(ohist,3)
            ohist(i,j,k) = temp(k);
        end
    end
end
