function [ graph ] = BlockGraphFromKernels(kernels_in_block , block_size,  k_size )
%   BLOCKGRAPHFROMKERNELS calculate heter graph from the LARK kernel 
%   kernels_in_block: kernel file: kernel sat each pixel 
%   block_size: the size of the blocks(potential set of connected pixels)
%   k_size: the size of the kernels
    graph = zeros(block_size*block_size);
    k_rad = (k_size-1)/2;
    kernel_center = k_rad+1;
    
    % outter loop to traverse the pixels in the block 
    for a_b_i = 1:block_size,
        for a_b_j = 1:block_size,
            %inner loop to traverse the kernel (limited to the window size of the block)
            %fprintf('%d, %d\n', a_b_i,a_b_j);
            normalizer = max(max(kernels_in_block(a_b_i,a_b_j,:,:)));
            
            for b_k_i= kernel_center + ( -k_rad : k_rad),
                for b_k_j = kernel_center + ( -k_rad : k_rad),
                    b_b_i = a_b_i + b_k_i - kernel_center;
                    b_b_j = a_b_j + b_k_j - kernel_center;
                    
                    if b_b_i>0 && b_b_j>0 && b_b_i<=block_size && b_b_j<=block_size,
                        a_b_index = sub2ind([block_size,block_size] , a_b_i , a_b_j);
                        b_b_index = sub2ind([block_size,block_size] , b_b_i , b_b_j);
                        graph(a_b_index , b_b_index) = (kernels_in_block(a_b_i , a_b_j , b_k_i , b_k_j)/normalizer)*0.5;
                        graph(b_b_index , a_b_index) = graph(a_b_index , b_b_index); 
                    end
                    
                end
            end
            %end of inner loop
                        
        end
    end
    %end of outter loop

end

