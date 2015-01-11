function [ res0 , res1 , res2 ] = KGIEWE( im, seed, g_kernel, align, lambda_g)
%KGI Summary of this function goes here
%   Detailed explanation goes here

im = EdgeMirror(im, [align/2 , align/2]);
seed = EdgeMirror(seed, [align/2, align/2]);
im_size = size(im);

ksize = 2*align + 1;
k_rad = floor(ksize/2)-1;
g_kernel(:,:,k_rad,k_rad) = 0;

res1 = zeros(im_size);

for block_i = 1:align:im_size(1),
    for block_j = 1:align:im_size(2),
        
        block = im( block_i:block_i+align-1 , ...
            block_j:block_j+align-1 );
        block_seed = seed(block_i:block_i+align-1 , ...
            block_j:block_j+align-1 );
        
        kernels_in_block = zeros(align,align,ksize,ksize);
        kernels_in_block(1:align,1:align,1:ksize,1:ksize) = ...
                           g_kernel(block_i:block_i+align-1,...
                                    block_j:block_j+align-1,:,:);
        graph = BlockGraphFromKernelsEWE(kernels_in_block , align, ksize, block_seed);                
        lap = CalLap( graph );
        
        block_res = (eye(align*align)+lambda_g*lap)^(-1)*block(:);
        res1(block_i:block_i+align-1 , block_j:block_j+align-1) = reshape(block_res,[8 8]);                                        
                                
    end
end

res2 = zeros(im_size - align);

for block_i = 1+align/2: align : im_size(1)-align/2,
    for block_j = 1+align/2: align : im_size(2)-align/2,        
        
        block = im( block_i:block_i+align-1 , ...
            block_j:block_j+align-1 );
        block_seed = seed(block_i:block_i+align-1 , ...
            block_j:block_j+align-1 );
        
        kernels_in_block = zeros(align,align,ksize,ksize);
        kernels_in_block(1:align,1:align,1:ksize,1:ksize) = ...
                           g_kernel(block_i:block_i+align-1,...
                                    block_j:block_j+align-1,:,:);
        graph = BlockGraphFromKernelsEWE(kernels_in_block , align, ksize, block_seed);
        lap = CalLap( graph );

        
        block_res = (eye(align*align)+lambda_g*lap)^(-1)*block(:);
        res2(block_i-align/2:block_i+align/2-1 , block_j-align/2:block_j+align/2-1) = reshape(block_res,[8 8]);  
    end
end

res0 = OverLap(res1, res2 , align);

end