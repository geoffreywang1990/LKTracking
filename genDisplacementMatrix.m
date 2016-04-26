function D = genDisplacementMatrix(perturbedConfigurations,frameAnnotations,m,n)
D = zeros(m*n,10);
for i = 1:m
    temp = repmat(frameAnnotations{i},1,n)-perturbedConfigurations(1:2,(i-1)*5*n+1:i*5*n);%2*5n matrix
    temp = reshape(temp,10,n);%10*n matrix
    % temp is n-by-10 matrix
    temp = temp';
    D((i-1)*n+1:i*n,:) = temp;
end
end