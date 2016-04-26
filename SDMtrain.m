function models = SDMtrain(mean_shape, annotations)
% CV Fall 2014 - Provided Code
% You need to implement the SDM training phase in this function, and
% produce tracking models for Winnie the Pooh
%
% Input:
%   mean_shape:    A provided 5x2 matrix indicating the x and y coordinates of 5 control points
%   annotations:   A ground truth annotation for training images. Each row has the format
%                  [frame_num nose_x nose_y left_eye_x left_eye_y right_eye_x right_eye_y right_ear_x right_ear_y left_ear_x left_ear_y]
% Output:
%   models:        The models that you will use in SDMtrack for tracking
%

% ADD YOUR CODE HERE  

fprintf('begin training\n')
poohpath = 'data/pooh';
scalesToPerturb = [0.8:0.2:1.2];
n = 100;
m = size(annotations,1);
frameAnnotations = cell(m,1);
images = cell(m,1);
currentConfigurations = zeros(4,m*n*5);
models = cell(5,1);
for u = 1:m
    I = imread(fullfile(poohpath,'training',sprintf('image-%04d.jpg', annotations(u,1))));
    images{u} = I;
    % Reshape annotations so that it is 5-by-2, ann(u, 1) is frame number
	singleFrameAnnotation = reshape(annotations(u,2:end), 2, 5)';
    frameAnnotations{u} = singleFrameAnnotation';
    temp = genPerturbedConfigurations(singleFrameAnnotation,mean_shape, n, scalesToPerturb);
    currentConfigurations(:,(u-1)*5*n+1:u*5*n) = temp;
end

fprintf('start created models\n')

for i = 1:7
    D = genDisplacementMatrix(currentConfigurations,frameAnnotations,m,n);
% %  D = genDisplacementMatrix(frameAnnotations,n,m,currentConfigurations);
    F = genFeatureMatrix(images,currentConfigurations,m,n);
% % F = genFeatureMatrix(images,n,m,currentConfigurations);
    [currentConfigurations,W] = learnMappingAndUpdateConfigurations(F,D,currentConfigurations);
%     currentEstimate = cell(m,1);
%     Edistance = zeros(m,5);
%     for i = 1:m
%         estimatedNose = round(mean(perturbedConfigurations{i}(1:2,1:5:end)'));
%         estimatedLeye = round(mean(perturbedConfigurations{i}(1:2,2:5:end)'));
%         estimatedReye = round(mean(perturbedConfigurations{i}(1:2,3:5:end)'));
%         estimatedLear = round(mean(perturbedConfigurations{i}(1:2,4:5:end)'));
%         estimatedRear = round(mean(perturbedConfigurations{i}(1:2,5:5:end)'));
%         currentEstimate{i} = [estimatedNose;estimatedLeye;estimatedReye;estimatedLear;estimatedRear]';
%         temp = (currentEstimate{i} - frameAnnotations{i}).^2;
%         Edistance(i,:) = sqrt(temp(1,:)+temp(2,:));
%     end
    models{i} = W;
%     if mean(mean(Edistance')) <=0.1
%         break;
%     end
end
fprintf('finish created models\n')
end
