function[im_res] =  SKGL0L( im )

im_size = size(im);

load('g_kernel_nov19_hat_edge1.mat');

ksize = 21;
align = 8;

im_res = zeros(im_size);
filter = zeros(align*align);

for block_i = 1:align:im_size(1),
    for block_j = 1:align:im_size(2),
        kernels_in_block = zeros(align,align,ksize,ksize);
        kernels_in_block(1:align,1:align,1:ksize,1:ksize) = ...
                           g_kernel(block_i:block_i+align-1,...
                                    block_j:block_j+align-1,:,:);
        graph = BlockGraphFromKernels(kernels_in_block , align, ksize);
        
        filter_sum = sum(graph);
        for filter_i =  1:align*align,
            filter(filter_i,:) = graph(filter_i,:)/(filter_sum(filter_i)+0.00001); 
        end
        
        block = im( block_i:block_i+align-1 , ...
                    block_j:block_j+align-1 );
        block_res = filter'*block(:);
        im_res(block_i:block_i+align-1 , block_j:block_j+align-1) = reshape(block_res,[8 8]);                                        
                                
    end
end


