img = imread('./hendrix_final.png');
N = 600;  %Number of SVD considered
r = im2double(img(:,:,1));
g = im2double(img(:,:,2));
b = im2double(img(:,:,3));
[ur,sr,vr] = svd(r);
[ug,sg,vg] = svd(g);
[ub,sb,vb] = svd(b);
sigmaVectorR = diag(sr);
sigmaVectorG = diag(sg);
sigmaVectorB = diag(sb);
figure(1);
loglog(sigmaVectorR);

% sorting singular values to get the most influential vector.
[sortedSigmaR,indR] = sort(sigmaVectorR,'descend');
[sortedSigmaG,indG] = sort(sigmaVectorG,'descend');
[sortedSigmaB,indB] = sort(sigmaVectorB,'descend');
rRecon = zeros(size(r));
gRecon = zeros(size(g));
bRecon = zeros(size(b));
normForbR = zeros(N,1);
normForbG = zeros(N,1);
normForbB = zeros(N,1); 
% Adding each Singular value recontruction to get the reconstruction of original image.
for i=1:N
    rRecon = rRecon + ur(:,indR(i))*sortedSigmaR(i)*vr(:,indR(i))';
    rRecon = normalize(rRecon,'range');
    normForbR(i) = norm(r - rRecon,'fro');
    gRecon = gRecon + ug(:,indG(i))*sortedSigmaG(i)*vg(:,indG(i))';
    gRecon = normalize(gRecon,'range');
    normForbG(i) = norm(g - rRecon,'fro');
    bRecon = bRecon + ub(:,indB(i))*sortedSigmaB(i)*vb(:,indB(i))';
    bRecon = normalize(bRecon,'range');
    normForbB(i) = norm(b - bRecon,'fro');
end
x = 1:N;
% plotting recontruction error
figure(2);
plot(x, normForbR, 'r', x, normForbG, 'g',x ,normForbB, 'b')
%combining r, g, b component to create colored image
reconImg = zeros(size(r));
reconImg(:,:,1)= rRecon;
reconImg(:,:,2)= gRecon;
reconImg(:,:,3)= bRecon;
figure(3)
subplot(1,2,1)
imshow(mat2gray(img))
title('original')
subplot(1,2,2), imshow(reconImg)
title('recontructed')
