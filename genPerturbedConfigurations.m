function perturbedConfigurations = genPerturbedConfigurations(singleFrameAnnotation,meanShape, n, scalesToPerturb)
perturbedConfigurations = zeros(4,n*5);     
%calculate the center the ground truth
center = mean(singleFrameAnnotation);

%generate the random translation and scaling
x = 10*randn(1,10*n);
y = 10*randn(1,10*n);
r = sqrt(x.^2+y.^2);
ind = find(r<=10);
x = x(ind(1:(n)));
y = y(ind(1:(n)));
scales = scalesToPerturb(randsample(length(scalesToPerturb),n,true));
translations = [x;y]';

for i = 1:n
%     scale = findscale(singleFrameAnnotation,meanShape);
%     preturbedMeanShape = scale*meanShape;
%     perturbe the means shape
%     preturbedMeanShape = scales(i)*preturbedMeanShape;
%     preturbedMeanShape = scales(i)*meanShape;
%     move it to the center 
    dis = center - mean(meanShape);
    preturbedMeanShape = meanShape+repmat(dis,5,1);
    preturbedMeanShape = preturbedMeanShape*scales(i)+repmat(translations(i,:),5,1);
%     find scale and scale it.
    scale = findscale(preturbedMeanShape,singleFrameAnnotation);
    preturbedMeanShape = scale*preturbedMeanShape;
    %create perturbed Configurations
    fc = [preturbedMeanShape'; [7 4 4 10 10] * scale; [0 0 0 0 0]];    
    perturbedConfigurations(:,(i-1)*5+1:5*i) = fc;
end
end

    

