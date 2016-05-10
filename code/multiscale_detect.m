function det_res = multiscale_detect(image, template, ndet)
%% Information
% input:
%     image - test image.
%     template - [16 x 16x 9] matrix.
%     ndet - the number of return values.
% output:
%      det_res - [ndet x 3] matrix
%                column one is the x coordinate
%                column two is the y coordinate
%                column three is the scale, i.e. 1, 0.7 or 0.49 ..
%% Run detect on multiple scales of the test image
scale = 1;
xs = [];
ys = [];
scores = [];
scales = [];
while(1)
    % Resize the image
    image_size = [size(image,1) * scale, size(image,2) * scale];
    if(any(image_size < [size(template,1) size(template,2)])) % if the image is smaller than the template
        break;
    end
    im_smaller = imresize(image, image_size);
    % Run the detect algorithm
    [x, y, score] = detect(im_smaller, template, ndet);
    xs = [xs; x / scale];
    ys = [ys; y / scale];
    scores = [scores; score];
    for i = 1:size(y)
        scales = [scales; scale];
    end
    scale = scale * 0.8;
end
% Add to return type
det_res = [xs ys scales scores];
% sort based on scores
det_res = flipud(sortrows(det_res,4));
% Use maximum suppression
[xs, ys, scores, scales] = maximum_suppression(image, det_res(:,1), det_res(:,2),...
    det_res(:,4), det_res(:,3), ndet);
% Add to return type
det_res = [xs ys scales scores];
% Get the ndet number of detections
% det_res = [det_res(1:ndet,1) det_res(1:ndet,2) det_res(1:ndet,3)];
end

