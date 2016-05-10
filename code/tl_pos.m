function template = tl_pos(template_images_pos)
%% Information
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix
%% Average out the positive templates
template = zeros(round(size(template_images_pos{1},1)/8), ...
    round(size(template_images_pos{1},2)/8), 9);
for i = 1:size(template_images_pos,2)
    template = template + hog(template_images_pos{i});
end
template = template / size(template_images_pos,2);
end