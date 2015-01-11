function [ res ] = KGI( im, g_kernel, align, lambda_g)
%KGI Summary of this function goes here
%   Detailed explanation goes here
im_size = size(im);

ksize = 2*align + 1;
k_rad = floor(ksize/2)-1;
g_kernel(:,:,k_rad,k_rad) = 0;

res = zeros(im_size);

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
        res(block_i:block_i+align-1 , block_j:block_j+align-1) = reshape(block_res,[8 8]);                                        
                                
    end
end

end

