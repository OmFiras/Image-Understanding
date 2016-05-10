%% Function to draw the detection
function draw_detection(Itest, ndet, x, y, scale)
    %display top ndet detections
    figure;
    imshow(Itest);
    for i = 1:ndet
      % draw a rectangle.  use color to encode confidence of detection
      %  top scoring are green, fading to red
      hold on; 
      h = rectangle('Position',[(x(i,1)-64 * scale(i)), (y(i,1)-64*scale(i)), 128*scale(i), 128*scale(i)],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
      hold off;
    end
end