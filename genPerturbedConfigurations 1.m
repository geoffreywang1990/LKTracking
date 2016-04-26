%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
% CV Fall 2014 - Code
% Step 1 of SDM
% Get perturbed configuraions
%
% Created by Tao FU

function perturbedConfigurations = genPerturbedConfigurations(singleFrameAnnotation,meanShape, n, scalesToPerturb)
%% singleFrameAnnotation is a 5by2 matrix
% meanShape is a 5by2 matrix
% scalesToPerturb is candidate scales to choose from



% initialize the result
% each consecutive 5 columns is one configuration
% first two rows are x,y
% third row is scale of SIFT
% final row is orientation of SIFT,which is just set to 0 here 
perturbedConfigurations = zeros(4,n*5);

%in general Winnie moves less than 10 pixels per frame in our sequence
translations = randn(1,n)*10;
% random sample scalesToPerturb with replacement n times
scales = scalesToPerturb(randsample(length(scalesToPerturb),n,true));

for i = 1:n
    mean_shape = meanShape;
    mean_shape = bsxfun(@plus,mean_shape, mean(singleFrameAnnotation)-mean(mean_shape));
    mean_shape = mean_shape * scales(i) + translations(i);
    % Compute scale difference between mean_shape and perturbedConf
    scale = findscale(mean_shape,singleFrameAnnotation);
    mean_shape = mean_shape * scale;
    % Prepare data for vl_feat
    % First row: x location(s) of where you want to extract SIFT
    % Second row: y location(s) of where you want to extract SIFT
    % Third row: scale of SIFT point, enlarge/shrink the SIFT point range according to scale differences
    % Fourth row: orientation (setting it to 0 is fine for this homework)
    fc = [mean_shape'; [7 4 4 10 10] * scale; [0 0 0 0 0]];    
    





perturbedConfigurations(:,(i-1)*5+1:5*i) = fc;


end


















end