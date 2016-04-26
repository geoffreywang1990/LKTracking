%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
% CV Fall 2014 - Code
% Step 2 of SDM
% Get displacement matrix
%
% Created by Tao FU
function D = genDisplacementMatrix(FrameAnnotations,n,m,perturbedConfigurations)
%% FrameAnnotations is the ground truth annotation matrix
% It is a cell array,each element is a 2-by-5 matrix
% n is the number of perturbed configurations per image
% m is the number of images
% perturbedconfigurations is a 4-by-m*n*5 matrix
% each consecutive 5 columns is one configuration
% first two rows are x,y
% third row is scale of SIFT
% final row is orientation of SIFT,which is just set to 0 here 
% D is mn-by-10 displacement matrix D, where each row contains the
% displacements between an initial shape and a true annotation of 5 components.
D = zeros(m*n,10);
for i = 1:m
    % temp is 2-by-5*n matrix
    temp = repmat(FrameAnnotations{i},1,n)-perturbedConfigurations(1:2,(i-1)*5*n+1:i*5*n);
    % temp is 10-by-n matrix
    temp = reshape(temp,10,n);
    % temp is n-by-10 matrix
    temp = temp';
    D((i-1)*n+1:i*n,:) = temp;
end


end