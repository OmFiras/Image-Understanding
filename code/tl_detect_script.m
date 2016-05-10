%% Information
% tl_detect_script.m
% A script that runs the various template stuff to try and automate the
% detection
clear;
clc;
%% Load the template images for positive and negative for signs
load('template_images_pos.mat');
load('template_images_neg.mat');
%% Load the template images for positive and negative for faces
load('template_images_face_pos.mat');
load('template_images_face_neg.mat');
%% Load the template images for positive and negative for stop signs
load('template_images_stop_sign_pos.mat');
load('template_images_stop_sign_neg.mat');
%% Get the test image for the signs
upscale = 3; % Factor to upscale to get larger images
Itest = im2double(rgb2gray(imread('../data/test4.jpg')));
image_size_scale = [size(Itest,1) * upscale, size(Itest,2) * upscale];
Itest = imresize(Itest, image_size_scale);
%% Get the test image for the faces
upscale = 3.5; % Factor to upscale to get larger images
Itest = im2double(rgb2gray(imread('../data/stop_signs/stop_sign_test3.jpg')));
image_size_scale = [size(Itest,1) * upscale, size(Itest,2) * upscale];
Itest = imresize(Itest, image_size_scale);
%% Show test image
figure;
imshow(Itest);
%% Run detection for positive templates
ndet = 5;
template = tl_pos(template_images_pos);
[x,y,score] = detect(Itest,template,ndet);
scale = ones(ndet,1);
draw_detection(Itest, ndet, x, y, scale);
%% Run detection using positive and negative templates
ndet = 5;
template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,score] = detect(Itest,template,ndet);
scale = ones(ndet,1);
draw_detection(Itest, ndet, x, y, scale);
%% Run detection using lda
ndet = 5;
lambda = 0.0001;
template = tl_lda(template_images_pos, template_images_neg, lambda);
[x,y,score] = detect(Itest,template,ndet);
scale = ones(ndet,1);
draw_detection(Itest, ndet, x, y, scale);
%% Run detection using muti-scale
lambda = 0.0001;
template = tl_lda(template_images_pos, template_images_neg, lambda);
ndet = 20; % Number to detect at each resolution
det_res = multiscale_detect(Itest, template, ndet);
% Get the ndet number ones
x = det_res(:,1);
y = det_res(:,2);
scales = det_res(:,3);
ndet = 5; % Number to display
if(upscale > 1)
    draw_detection_upscale(Itest, ndet, x, y, scales);
else
    draw_detection(Itest, ndet, x, y, scales);
end
%% Run detection using multiple templates
% Get the test images
upscale = 0.5; % Factor to upscale to get larger images
Itest = im2double(rgb2gray(imread('../data/runner_train3.jpg')));
image_size_scale = [size(Itest,1) * upscale, size(Itest,2) * upscale];
Itest = imresize(Itest, image_size_scale);
% Get the training images
load('template_images_face_pos.mat');
front_images_pos = template_images_pos;
load('template_images_side_face_pos.mat');
side_images_pos = template_images_pos;
load('template_images_face_neg.mat');
% Get the templates for the images
lambda = 0.01;
front_template = tl_lda(front_images_pos, template_images_neg, lambda);
side_template = tl_lda(side_images_pos, template_images_neg, lambda);
% Get the detections for the front images
ndet = 20; % Number to detect at each scale
det_res = multiscale_detect(Itest, front_template, ndet);
% Get the ndet number ones
x = det_res(:,1);
y = det_res(:,2);
scales = det_res(:,3);
scores = det_res(:,4);
% Get the detections for the side images
det_res = multiscale_detect(Itest, front_template, ndet);
% Get the values recturned
x = [x; det_res(:,1)];
y = [y; det_res(:,2)];
scales = [scales; det_res(:,3)];
scores = [scores; det_res(:,4)];
% Sort according to scores
det_res = [x, y, scales, scores];
det_res = flipud(sortrows(det_res,4));
% Use maximum suppression
[x, y, scores, scales] = maximum_suppression(Itest, det_res(:,1), det_res(:,2),...
    det_res(:,4), det_res(:,3), ndet);
ndet = 5; % Number to display
upscale = 1;
if(upscale > 1)
    draw_detection_upscale(Itest, ndet, x, y, scales);
else
    draw_detection(Itest, ndet, x, y, scales);
end


