function [updatedConfs,W] = learnMappingAndUpdateConfigurations(F,D,perturbedConfigurations)
updatedConfs = perturbedConfigurations;
W = learnLS(F,D);
displacement = F*W;% displacement is mn*10 matrix
displacement = reshape(displacement',2,[]);%reshape displacement to 2*5000 matrix
updatedConfs(1:2,:) = updatedConfs(1:2,:)+displacement;
end