function [mag,ori] = mygradient(I)
%%
% compute image gradient magnitude and orientation at each pixel
% Input:
%   I:          Graysacle image
%   mag:        magnitude of the x and y gradients
%   ori:        orientation of the x and y gradients
%% Get the gradients of the image
[Gx, Gy] = gradient(I);
%% Get the magnitude of the gradient
mag = sqrt((Gx).^2 + (Gy).^2);
%% Get the orientation of the gradient
ori = atan2(Gy, Gx);