%% Information
% Script that lets the users draw patches on the image that will be set up
% as training examples. The users should fill in information about which 
% training examples
clc;
clear;
rng('shuffle', 'twister');
%% Specify the images to run for the signs
I0 = im2double(rgb2gray(imread('../data/test0.jpg')));
I1 = im2double(rgb2gray(imread('../data/test1.jpg')));
I2 = im2double(rgb2gray(imread('../data/test2.jpg')));
I3 = im2double(rgb2gray(imread('../data/test3.jpg')));
I4 = im2double(rgb2gray(imread('../data/test4.jpg')));
I5 = im2double(rgb2gray(imread('../data/test5.jpg')));
I6 = im2double(rgb2gray(imread('../data/test6.jpg')));
% Array that determines which images to run
images_to_run = [1, 2, 3, 5, 6, 7]; 
% Put the images into a call
Itrains = cell(size(images_to_run,1));
Itrains{1} = I0;
Itrains{2} = I1;
Itrains{3} = I2;
Itrains{4} = I3;
Itrains{5} = I4;
Itrains{6} = I5;
Itrains{7} = I6;
%% Specify the images to run for the faces
% I1 = im2double(rgb2gray(imread('../data/runner_train1.jpg')));
% I2 = im2double(rgb2gray(imread('../data/runner_train2.jpg')));
% I3 = im2double(rgb2gray(imread('../data/runner_train3.jpg')));
% I4 = im2double(rgb2gray(imread('../data/test0.jpg')));
% I5 = im2double(rgb2gray(imread('../data/runner_train5.jpg')));
% % Array that determines which images to run
% images_to_run = [1, 2, 3, 4, 5]; 
% % Put the images into a call
% Itrains = cell(size(images_to_run,1));
% Itrains{1} = I1;
% Itrains{2} = I2;
% Itrains{3} = I3;
% Itrains{4} = I4;
% Itrains{5} = I5;
%% Specify the images to run for the stop signs
% I1 = im2double(rgb2gray(imread('../data/stop_signs/stop_sign_train1.jpg')));
% I2 = im2double(rgb2gray(imread('../data/stop_signs/stop_sign_train2.jpg')));
% I3 = im2double(rgb2gray(imread('../data/stop_signs/stop_sign_train3.jpg')));
% I4 = im2double(rgb2gray(imread('../data/stop_signs/stop_sign_train4.jpg')));
% I5 = im2double(rgb2gray(imread('../data/stop_signs/stop_sign_train5.jpg')));
% % Array that determines which images to run
% images_to_run = [1, 2, 3, 4, 5]; 
% % Put the images into a call
% Itrains = cell(size(images_to_run,1));
% Itrains{1} = I1;
% Itrains{2} = I2;
% Itrains{3} = I3;
% Itrains{4} = I4;
% Itrains{5} = I5;
%% Specify the parameters for the bounding box
% If there is more than 1 example in the training image (e.g. faces), 
% you could set nclicks higher here and average together.
nPositive = 1; % Number of positive examples
nNegative = 20; % Number of negative examples
ndet = 2; % Number detected
image_size = [128, 128];
%% Get the bounding boxes from user input of the positive examples
template_images_pos = cell(nPositive * size(images_to_run,2),1);
template_images_neg = cell(nNegative * size(images_to_run,2),1);
pos_image_y = [];
pos_image_x = [];
neg_image_y = [];
neg_image_x = [];
for i = 1:size(images_to_run,2)
    Itrain = Itrains{images_to_run(i)};
    figure(1); clf;
    imshow(Itrain);
    for j = 1:nPositive
        rect = getrect;
        rect = round(rect);
        if(rect(3) > rect(4))
            diff = rect(3) - rect(4);
            rect(4) = rect(3);
            rect(2) = rect(2) - abs(diff / 2);
        elseif(rect(4) > rect(3))
            diff = rect(4) - rect(3);
            rect(3) = rect(4);
            rect(1) = rect(1) - abs(diff / 2);
        end
        hold on; 
        h = rectangle('Position',[rect(1) rect(2) rect(3) rect(4)],'EdgeColor',[0 1 0],'LineWidth',3,'Curvature',[0 0]); 
        hold off;
        pos_image_y = [pos_image_y; [rect(2), (rect(2) + rect(4))]];
        pos_image_x = [pos_image_x; [rect(1), (rect(1) + rect(3))]];
        template_images_pos{size(pos_image_x,1)} = Itrains{images_to_run(i)}(rect(2):(rect(2) + rect(4)), ...
            rect(1):(rect(1) + rect(3)));
        size(template_images_pos{size(pos_image_x,1)});
    end
    for k = 1:nNegative
        rect = getrect;
        rect = round(rect);
        % Make the image square
        if(rect(3) > rect(4))
            diff = rect(3) - rect(4);
            rect(4) = rect(3);
            rect(2) = rect(2) - abs(diff / 2);
        elseif(rect(4) > rect(3))
            diff = rect(4) - rect(3);
            rect(3) = rect(4);
            rect(1) = rect(1) - abs(diff / 2);
        end
        hold on; 
        h = rectangle('Position',[rect(1) rect(2) rect(3) rect(4)],'EdgeColor',[1 0 0],'LineWidth',3,'Curvature',[0 0]); 
        hold off;
        neg_image_y = [neg_image_y; [rect(2), (rect(2) + rect(4))]];
        neg_image_x = [neg_image_x; [rect(1), (rect(1) + rect(3))]];
        template_images_neg{size(neg_image_x,1)} = Itrains{images_to_run(i)}(rect(2):(rect(2) + rect(4)), ...
            rect(1):(rect(1) + rect(3)));
        size(template_images_neg{size(neg_image_x,1)});
    end
end
%% Resize the images
for i = 1:size(template_images_pos,1)
    % resize image to 128x128
    template_images_pos{i} = imresize(template_images_pos{i}, image_size);
    template_images_neg{i} = imresize(template_images_neg{i}, image_size);
end
%% Save for the signs
save('template_images_pos.mat','template_images_pos')
save('template_images_neg.mat','template_images_neg')
%% Save for the faces
% save('template_images_face_pos.mat','template_images_pos')
% save('template_images_face_neg.mat','template_images_neg')
%% Save for the stop signs
% save('template_images_stop_sign_pos.mat','template_images_pos')
% save('template_images_stop_sign_neg.mat','template_images_neg')


