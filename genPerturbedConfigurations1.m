function perturbedConfigurations = genPerturbedConfigurations(singleFrameAnnotation,meanShape, n, scalesToPerturb)
perturbedConfigurations = zeros(4,n*5);     
% Compute scale difference between mean_shape and annotation
% scales = findscale(singleFrameAnnotation, meanShape)*scalesToPerturb;
center = mean(singleFrameAnnotation);
%create random displacement less than 10 pixels
x = 10*randn(1,2*n);
y = 10*randn(1,2*n);
r = sqrt(x.^2+y.^2);
ind = find(r<=10);
x = x(ind(1:(round(n/3)+1)));
y = y(ind(1:(round(n/3)+1)));
nowMeanShape = cell(33,1);
for i = 1:round(n/3)
    for j = 1:length(scalesToPerturb);
        nowMeanShape{i*3-3+j} = (scalesToPerturb(j).*meanShape+repmat(center+[x(i),y(i)],5,1));
        scale = findscale(singleFrameAnnotation, nowMeanShape{i*3-3+j});
        nowMeanShape{i*3-3+j} = scale*nowMeanShape{i*3-3+j};
        % Prepare data for vl_feat
        % First row: x location(s) of where you want to extract SIFT
        % Second row: y location(s) of where you want to extract SIFT
        % Third row: scale of SIFT point, enlarge/shrink the SIFT point range according to scale differences
        % Fourth row: orientation (setting it to 0 is fine for this homework)
       
        fc = [round(nowMeanShape{i*3-3+j})'; [7 4 4 10 10] / (scale*scalesToPerturb(j)); [0 0 0 0 0]];    
        perturbedConfigurations(:,(5*(3*i-3+j)-4):(5*(3*i-3+j))) = fc;
    end
end
if mod(3,2) ~= 0
    nowMeanShape{n}= (scalesToPerturb(1).*meanShape+repmat(center+[x(end),y(end)],5,1));
    scale = findscale(singleFrameAnnotation, nowMeanShape{n});
    nowMeanShape{i*3-3+j} = scale*nowMeanShape{i*3-3+j};
% Prepare data for vl_feat
% First row: x location(s) of where you want to extract SIFT
% Second row: y location(s) of where you want to extract SIFT
% Third row: scale of SIFT point, enlarge/shrink the SIFT point range according to scale differences
% Fourth row: orientation (setting it to 0 is fine for this homework)
fc = [round(nowMeanShape{n})'; ([7 4 4 10 10] / (scale*scalesToPerturb(1))); [0 0 0 0 0]];    
perturbedConfigurations(:,(5*(n-1)+1):5*n) = fc;
end
