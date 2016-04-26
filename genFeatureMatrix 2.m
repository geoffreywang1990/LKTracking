%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
% CV Fall 2014 - Code
% Step 3 of SDM
% Get SIFT feature from images
%
% Created by Tao FU

function F = genFeatureMatrix(images,n,m,perturbedConfigurations)
%% image is a cell array of images
% n is the number of perturbed configurations per image
% m is the number of images
% perturbedConfigurations is a 4-by-m*n*5 matrix
% each consecutive 5 columns is one configuration
% first two rows are x,y
% third row is scale of SIFT
% final row is orientation of SIFT,which is just set to 0 here 



% F is mn-by-640 matrix
% each row is 5 SIFT features
F = zeros(m*n,640);
for i = 1:m
    % fc is 4-by-5n matrix
    fc = perturbedConfigurations(:,(i-1)*5*n+1:i*5*n);
    % d is 128-by-5n
    d = siftwrapper(images{i}, fc);
    % d is 640-by-n now
    d = reshape(d,128*5,n);
    F((i-1)*n+1:i*n,:) = d';
end
















end