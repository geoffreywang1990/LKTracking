function SDMtrack(models, mean_shape, start_location, start_frame, outvidfile)
% CV Fall 2014 - Provided Code
% You need to implement the SDM test phase in this function, and output a
% tracking video for Winnie the Pooh
%
% Input:
%   models:         The model you trained in SDMtrain.m
%   mean_shape:     A provided 5x2 matrix indicating the x and y coordinates of 5 control points
%   start_location: A initial location for the first frame to start tracking. It has the format
%                   [nose_x nose_y; left_eye_x left_eye_y; right_eye_x right_eye_y; right_nose_x right_nose_y; left_nose_x left_nose_y]
%   start_frame:    A frame index denoting which frame to start tracking
%   outvidfile:     A string indicating the output video file name (eg, 'vidout.avi')

    % Open video for writing	
	vidout = VideoWriter(outvidfile);
	vidout.FrameRate = 20;
	open(vidout);

    % ADD YOUR CODE HERE

        %These two lines are only here to let runTrackWinnie without errors when you have not modified this file yet. Feel free to delete them once you started modifying this file.
	begin_shape = start_location;    
	current_shape = start_location;    

	for iFrm = (start_frame+1):3000
		% Load testing image
		I = imread(sprintf('data/pooh/testing/image-%04d.jpg', iFrm));
%         imshow(I);
%         hold on
		% ADD YOUR CODE HERE
        % Store your initial guess as a 5x2 matrix named begin_shape 
        % (1st column indicates x-coordinate, and 2nd column indicates y-coordinate).
%         % Store your final guess as a 5x2 matrix named current_shape (in the same format as begin_shape)
        center = mean(current_shape);
        dis = center - mean(mean_shape);
        mean_shape = mean_shape+repmat(dis,5,1);
        scale = findscale(mean_shape,current_shape);
        mean_shape = scale*mean_shape;
        configure = [mean_shape'; [7 4 4 10 10]* scale; [0 0 0 0 0]];   
        begin_shape = mean_shape;
        for i=1:length(models)
            d = siftwrapper(I, configure);
            displacement = d(:)' * models{i};
            displacement = reshape(displacement,2,5);
            configure(1:2,:) = configure(1:2,:)+displacement;            
        end
        current_shape = configure(1:2,:)';

        % Draw tracked location of parts
		% Red crosses should track Pooh's nose, eyes and ears
		figure(1);
		if ~exist('hh','var'), hh = imshow(I); hold on; 
		else set(hh,'cdata',I);
		end
		if ~exist('hPtBeg','var'), hPtBeg = plot(begin_shape(:,1), begin_shape(:,2), 'g+', 'MarkerSize', 15, 'LineWidth', 3);
		else set(hPtBeg,'xdata',begin_shape(:,1),'ydata',begin_shape(:,2));
		end
		if ~exist('hPtcurrent_shape','var'), hPtcurrent_shape = plot(current_shape(:,1), current_shape(:,2), 'r+', 'MarkerSize', 25, 'LineWidth', 5);
		else set(hPtcurrent_shape,'xdata',current_shape(:,1),'ydata',current_shape(:,2));
		end
		title(['frame ',num2str(iFrm)]);
		if ~exist('hFrmNum', 'var'), hFrmNum = text(30, 30, ['Frame: ',num2str(iFrm)], 'fontsize', 40, 'color', 'r');
		else set(hFrmNum, 'string', ['Frame: ',num2str(iFrm)]);
		end
		%resized so that video will not be too big
		frm = getframe;
		writeVideo(vidout, imresize(frm.cdata, 0.5));
	end
	
	% close vidobj
	close(vidout);
end
