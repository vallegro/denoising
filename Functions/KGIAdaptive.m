function [ res ] = KGIAdaptive( y_noise, g_kernel, align, block_size_l, block_map ,lambda_g)
%KGIADAPTIVE Summary of this function goes here
%   Detailed explanation goes here
im_size = size(y_noise);

ksize = 2*align + 1;
k_rad = align+1;
g_kernel(:,:,k_rad,k_rad) = 0;

res = zeros(im_size);

for block_i = 1:block_size_l:im_size(1),
    for block_j = 1:block_size_l:im_size(2),
        %fprintf('%d,%d\n',block_i,block_j);
        if block_map(block_i, block_j)~=0;
            kernels_in_block = g_kernel(block_i : block_i+block_size_l-1,...
                                        block_j : block_j+block_size_l-1,:,:);
            graph = BlockGraphFromKernels(kernels_in_block , block_size_l, ksize);
            lap = CalLap(graph);
            block = y_noise(block_i : block_i+block_size_l-1,...
                            block_j : block_j+block_size_l-1);
            block_res = (eye(block_size_l*block_size_l)+lambda_g*lap)^(-1)*block(:);
            res(block_i : block_i+block_size_l-1,...
                block_j : block_j+block_size_l-1) = reshape(block_res, [block_size_l block_size_l]);
        end
    end
end


file_name = sprintf('results/part%d_size%d_lambda%.2f.ppm',log2(block_size_l/8),im_size(1),lambda_g);
imwrite(uint8(res),file_name);

end
