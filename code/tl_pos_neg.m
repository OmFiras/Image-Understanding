function template = tl_pos_neg(template_images_pos, template_images_neg)
%% Information
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix 
%% Get the average hog descriptor for the positive examples
template_pos = zeros(round(size(template_images_pos{1},1)/8), ...
    round(size(template_images_pos{1},2)/8), 9);
for i = 1:size(template_images_pos,2)
    template_pos = template_pos + hog(template_images_pos{i});
end
template_pos = template_pos / size(template_images_pos,2);
%% Get the average hog descriptor for the negative examples
template_neg = zeros(round(size(template_images_neg{1},1)/8), ...
    round(size(template_images_neg{1},2)/8), 9);
for i = 1:size(template_images_neg,2)
    template_neg = template_neg + hog(template_images_neg{i});
end
template_neg = template_neg / size(template_images_neg,2);
%% Subtract the two
template = template_pos - template_neg;
end