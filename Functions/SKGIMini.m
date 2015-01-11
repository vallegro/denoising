function[res0, res1, res2] =  SKGIMini( im  ,kernel_file, lambda_g , align)

im = EdgeMirror(im, [align/2 , align/2]);


im_size = size(im);
% parameters of pilot estimation by second order classic kernel regression
h_c = 0.5;    % the global smoothing parameter
r = 1;      % the upscaling factor
ksize_c = 5;  % the kernel size

% iteartive steering kernel regression (second order)
wsize = 11;  % the size of the local orientation analysis window %%not radius
ksize = 17;  % the kernel size %%not radius

 
n_size= wsize+ksize-1;
n_radius = (n_size-1)/2;
wradius = (wsize-1)/2;


load(kernel_file);

k_rad = floor(ksize/2)-1;
g_kernel(:,:,k_rad,k_rad) = 0;



res1 = zeros(im_size);

for block_i = 1:align:im_size(1),
    for block_j = 1:align:im_size(2),
        kernels_in_block = zeros(align,align,ksize,ksize);
        kernels_in_block(1:align,1:align,1:ksize,1:ksize) = ...
                           g_kernel(block_i:block_i+align-1,...
                                    block_j:block_j+align-1,:,:);
        graph = BlockGraphFromKernels(kernels_in_block , align, ksize);
        lap = CalLap( graph );
        block = im( block_i:block_i+align-1 , ...
                    block_j:block_j+align-1 );
        block_res = (eye(align*align)+lambda_g*lap)^(-1)*block(:);
        res1(block_i:block_i+align-1 , block_j:block_j+align-1) = reshape(block_res,[8 8]);                                        
                                
    end
end

res2 = zeros(im_size - align);

for block_i = 1+align/2: align : im_size(1)-align/2,
    for block_j = 1+align/2: align : im_size(2)-align/2,
                kernels_in_block = zeros(align,align,ksize,ksize);
        kernels_in_block(1:align,1:align,1:ksize,1:ksize) = ...
                           g_kernel(block_i:block_i+align-1,...
                                    block_j:block_j+align-1,:,:);
        graph = BlockGraphFromKernels(kernels_in_block , align, ksize);
        lap = CalLap( graph );
        block = im( block_i:block_i+align-1 , ...
                    block_j:block_j+align-1 );
        block_res = (eye(align*align)+lambda_g*lap)^(-1)*block(:);
        res2(block_i-align/2:block_i+align/2-1 , block_j-align/2:block_j+align/2-1) = reshape(block_res,[8 8]);  
    end
end

res0 = OverLap(res1, res2 , align);