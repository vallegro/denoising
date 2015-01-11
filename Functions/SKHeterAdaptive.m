function [ g_kernel ] = SKHeterAdaptive(im_seed, align_min)
%   Calculate the 17x17 kernels, with different h for different region
%   g_kernel: size = [im_size kernel_size] record the heter-kernels at each pixel
%   im_seed: seed image to calculate the kernel
%   mininum block size
im_seed = EdgeMirror(im_seed , [align/2 , align/2]);
im_size = size(im_seed);

% parameters of pilot estimation by second order classic kernel regression
h_c = 0.5;    % the global smoothing parameter
r = 1;        % the upscaling factor
ksize_c = 5;  % the kernel size

% iteartive steering kernel regression (second order)
wsize = 11;  % the size of the local orientation analysis window %%not radius
lambda = 1;  % the regularization for the elongation parameter
alpha = 0.5; % the structure sensitive parameter
h = 2.4;     % the global smoothing parameter
ksize = align*2+1;  % the kernel size %%not radius

n_size= wsize+ksize-1;
n_radius = (n_size-1)/2;
wradius = (wsize-1)/2;

y = EdgeMirror(im_seed , [n_radius , n_radius]);

g_kernel = zeros(im_size(1),im_size(2),ksize,ksize); 

for level_i = 1:length(levels),
    for block_i = 1 : block_size_l(level_i) : im_size(1);
        for block_j = 1 : block_size_l(level_i) : im_size(2);
            
            
        end
    end
end


end

