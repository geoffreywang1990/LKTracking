load('data/pooh/rects_frm992.mat'); % load sequence
addpaths;
[a b c] = size(imread('data/pooh/testing/image-0992.jpg'));

% Open video writer
vidname = 'pooh_lk.avi';
vidout  = VideoWriter(vidname);
vidout.FrameRate = 10;
open(vidout);

images = cell(3000-991);
images{1} = imread('data/pooh/testing/image-0992.jpg');
sequences(:,:,:,1) = images{1};
imshow(images{1});hold on;text(80,100,num2str(992),'color','r','fontsize',30); 
drawRect([rect_lear(1:2),rect_lear(3:4)-rect_lear(1:2)],'r',3);
drawRect([rect_leye(1:2),rect_leye(3:4)-rect_leye(1:2)],'g',3);
drawRect([rect_rear(1:2),rect_rear(3:4)-rect_rear(1:2)],'r',3);
drawRect([rect_reye(1:2),rect_reye(3:4)-rect_reye(1:2)],'g',3);
drawRect([rect_nose(1:2),rect_nose(3:4)-rect_nose(1:2)],'b',3);
hold off;
drawnow;
frm = getframe;
writeVideo(vidout, imresize(frm.cdata, 0.5));

for i = 993:3000
    images{i-991} = imread(sprintf('data/pooh/testing/image-%04d.jpg',i));
    It = images{i-992};
    It1 = images{i-991};
    [u1,v1] = LucasKanade(It,It1,rect_lear);
    rect_lear  = rect_lear + [u1,v1,u1,v1];
    [u2,v2] = LucasKanade(It,It1,rect_rear);
    rect_rear  = rect_rear + [u2,v2,u2,v2];
    [u3,v3] = LucasKanade(It,It1,rect_leye);
    rect_leye  = rect_leye + [u3,v3,u3,v3];
    [u4,v4] = LucasKanade(It,It1,rect_reye);
    rect_reye  = rect_reye + [u4,v4,u4,v4];
    [u5,v5] = LucasKanade(It,It1,rect_nose);
    rect_nose  = rect_nose + [u5,v5,u5,v5];
    % compute the displacement using LK
    
    imshow(images{i-991});hold on;text(80,100,num2str(i),'color','r','fontsize',30); 
    drawRect([rect_lear(1:2),rect_lear(3:4)-rect_lear(1:2)],'r',3);
    drawRect([rect_leye(1:2),rect_leye(3:4)-rect_leye(1:2)],'g',3);
    drawRect([rect_rear(1:2),rect_rear(3:4)-rect_rear(1:2)],'r',3);
    drawRect([rect_reye(1:2),rect_reye(3:4)-rect_reye(1:2)],'g',3);
    drawRect([rect_nose(1:2),rect_nose(3:4)-rect_nose(1:2)],'b',3);
    hold off;
    drawnow;
    
   % Write a frame to video, resized so that video will not be too big
    frm = getframe;
	writeVideo(vidout, imresize(frm.cdata, 0.5));

end

close(vidout);
close(1);
fprintf('Video saved to %s\n', vidname);