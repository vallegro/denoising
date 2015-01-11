function[g_kernel] =  SKheter( im , im_seed, align)


im = EdgeMirror(im, [align/2 , align/2]);
im_seed = EdgeMirror(im_seed , [align/2 , align/2]);


im_size = size(im);
% parameters of pilot estimation by second order classic kernel regression
h_c = 0.5;    % the global smoothing parameter
r = 1;      % the upscaling factor
ksize_c = 5;  % the kernel size

% iteartive steering kernel regression (second order)
wsize = 11;  % the size of the local orientation analysis window %%not radius
lambda = 1;  % the regularization for the elongation parameter
alpha = 0.5; % the structure sensitive parameter
h = 2.4;     % the global smoothing parameter
ksize = align*2+1;  % the kernel size %%not radius
% z = zeros(N, M, IT+1);
% zx1 = zeros(N, M, IT+1);
% zx2 = zeros(N, M, IT+1);
% rmse = zeros(IT+1, 1);
% z(:,:,1) = y;
% zx1(:,:,1) = zx1c;
% zx2(:,:,1) = zx2c;
% error = img - y;
% rmse(1) = sqrt(mymse(error(:)));

 
n_size= wsize+ksize-1;
n_radius = (n_size-1)/2;
wradius = (wsize-1)/2;
y = EdgeMirror(im_seed , [n_radius , n_radius]);

g_kernel = zeros(im_size(1),im_size(2),ksize,ksize); 

for i = 1:im_size(1),
    for j = 1:im_size(2),
        
        fprintf('---- %d, %d ----\n', i, j);
        
        y_nei = y(i:i+n_size-1 , j:j+n_size-1);
        [g_kernel(i,j,:,:)] = KernelLoop( y_nei , h_c , r , ksize_c , ...
            n_size , wsize, lambda , alpha , h ,ksize , wradius);
        
    end
end



