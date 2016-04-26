poohpath = 'data/pooh';
mean_shape = importdata(fullfile(poohpath, 'mean_shape.mat'));
annotations = load(fullfile(poohpath,'ann'));

addpaths;    
scalesToPerturb = [0.8 1 1.2];
n = 100;
m = size(annotations,1);
% Visualize pooh mean shape 
% Format of ms: [nose_x nose_y; left_eye_x left_eye_y; right_eye_x; right_eye_y; right_ear_x right_ear_y; left_ear_x left_ear_y]
plot(mean_shape(:,1), mean_shape(:,2), 'b+', 'markersize', 12, 'linewidth', 3); axis equal ij; ylim([-130,130]);
text(mean_shape(:,1)+5, mean_shape(:,2), {'nose','left eye','right eye','right ear','left ear'}, 'color', 'r', 'fontsize', 14);
perturbedConfigurations = cell(m,1);
frameAnnotations = cell(m,1);
images = cell(m,1);
for u = 1:m
    I = imread(fullfile(poohpath,'training',sprintf('image-%04d.jpg', annotations(u,1))));
    images{u} = I;
    imshow(I);        
    hold on;          
    
    % Reshape annotations so that it is 5-by-2, ann(u, 1) is frame number
	singleFrameAnnotation = reshape(annotations(u,2:end), 2, 5)';
    frameAnnotations{u} = singleFrameAnnotation';
    perturbedConfigurations{u} = genPerturbedConfigurations(singleFrameAnnotation,mean_shape, n, scalesToPerturb);
      currentConfs(:,(u-1)*5*n+1:u*5*n) = perturbedConfigurations{u}
end
configurations = 
W = cell(2,1);
u = 1;
while 1
    D = genDisplacementMatrix(perturbedConfigurations,frameAnnotations,m,n);
    F = genFeatureMatrix(images,perturbedConfigurations,m,n);
    [W{u},displacements,perturbedConfigurations] = learnMappingAndUpdateConfigurations(D,F,perturbedConfigurations);
    currentEstimate = cell(m,1);
    Edistance = zeros(m,5);
    for i = 1:m
        estimatedNose = round(mean(perturbedConfigurations{i}(1:2,1:5:end)'));
        estimatedLeye = round(mean(perturbedConfigurations{i}(1:2,2:5:end)'));
        estimatedReye = round(mean(perturbedConfigurations{i}(1:2,3:5:end)'));
        estimatedLear = round(mean(perturbedConfigurations{i}(1:2,4:5:end)'));
        estimatedRear = round(mean(perturbedConfigurations{i}(1:2,5:5:end)'));
        currentEstimate{i} = [estimatedNose;estimatedLeye;estimatedReye;estimatedLear;estimatedRear]';
        temp = (currentEstimate{i} - frameAnnotations{i}).^2;
        Edistance(i,:) = sqrt(temp(1,:)+temp(2,:));
    end
    u = u+1
    if mean(mean(Edistance')) <=0.1
        break;
    end
end

           
    