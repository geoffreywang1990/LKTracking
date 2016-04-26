function F = genFeatureMatrix(images,perturbedConfigurations,m,n)
F = zeros(m*n,640);
for i = 1:m
    d = siftwrapper(images{i}, perturbedConfigurations(:,(i-1)*5*n+1:i*5*n));
    %reshape d to n*640 matrix
    temp = reshape(d,128*5,n);
    %create F by mn*640 matrix
    F((i-1)*n+1:i*n,:) = temp';
end
end
