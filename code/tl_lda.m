function template = tl_lda(template_images_pos, template_images_neg, lambda)
%% Information
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
%     lambda - parameter for lda
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
neg_hogs = cell(size(template_images_neg));
template_neg = zeros(round(size(template_images_neg{1},1)/8), ...
    round(size(template_images_neg{1},2)/8), 9);
for i = 1:size(template_images_neg,2)
    neg_hogs{i} = hog(template_images_neg{i});
    template_neg = template_neg + neg_hogs{i};
end
template_neg = template_neg / size(template_images_neg,2);
%% Subtract the two
template_sub = template_pos - template_neg;
%% Get an appropriate identity matrix
I = zeros(size(template_sub));
for i = 1:size(template_neg,3)
    I(:,:,i) = eye(size(template_neg,1), size(template_neg,2));
end
%% Calculate the covariance matrix for the negative set
sum = zeros(round(size(template_images_neg{1},1)/8), ...
    round(size(template_images_neg{1},2)/8), 9);
for i = 1:size(template_images_neg, 2)
    size(neg_hogs{i})
    size(template_neg)
    diff = neg_hogs{i} - template_neg;
    for j = 1:size(diff,3)
        outer_product(:,:,j) = (diff(:,:,j))*(diff(:,:,j))';
    end
    sum = sum + outer_product;
end
cov_neg = (sum / size(template_neg,2)) + lambda * I;
%% Calculate the inverse
cov_neg_inv = zeros(size(cov_neg));
for i = 1:size(cov_neg,3)
    cov_neg_inv(:,:,i) = inv(cov_neg(:,:,i));
end
%% Get the final template
template = zeros(size(cov_neg_inv));
for i = 1:size(cov_neg_inv,3)
    template(:,:,i) = cov_neg_inv(:,:,i) * template_sub(:,:,i);
end
end