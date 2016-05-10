%% Maximum Suppression algorithm
function [xs, ys, scores, scales] = maximum_suppression(I, x, y, score, scale, ndet)
    if(size(x) == 1)
        xs = x;
        ys = y;
        scores = score;
        scales = scale;
        return;
    elseif(size(x) == 0)
        xs = 0;
        ys = 0;
        scores = 0;
        scales = 0;
        display('Nothing returned');
        return;
    else
        % Put the highest scoring in the first element
        xs = [x(1)];
        ys = [y(1)];
        scores = [score(1)];
        scales = [scale(1)];
        for i = 2:size(x,1)
            if(size(xs,1) == ndet)
                break;
            end
            % Get the maximum and minimum values of the x's and y's in list
            xs_min = xs(:) - 64;
            xs_max = xs(:) + 64;
            ys_min = ys(:) - 64;
            ys_max = ys(:) + 64;
            % Get the min and max values of quered x and y
            x_min = x(i) - 64;
            x_max = x(i) + 64;
            y_min = y(i) - 64;
            y_max = y(i) + 64;
            if(x_min < 1 || y_min < 1 || x_max > size(I,2) || y_max > size(I,1))
                continue;
            end
            rect = [x_min, y_min, abs(x_max - x_min), abs(y_max - y_min)];
            rects = [xs_min, ys_min, abs(xs_max - xs_min), abs(ys_max - ys_min)];
            if(any(rectint(rect, rects)) > 0)
                continue;
            else
                xs = [xs; x(i)];
                ys = [ys; y(i)];
                scores = [scores; score(i)];
                if(numel(scale) > 1)
                    scales = [scales; scale(i)];
                else
                    scales = scale;
                end
            end
        end
    end
end

