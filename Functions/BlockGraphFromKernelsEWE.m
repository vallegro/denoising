function [ graph ] = BlockGraphFromKernelsEWE( kernels_in_block , align, k_size, block_seed )
%BL Summary of this function goes here
%   Detailed explanation goes here
    graph = zeros(align*align);
    kernel_center = (k_size+1)/2;
    %var_block = var(block_seed(:));
    
    % outter loop to traverse the pixels in the block 
    for a_b_i = 1:align,
        for a_b_j = 1:align,
            %inner loop to traverse the kernel (limited to the window size of the block)
            normalizer = max(max(kernels_in_block(a_b_i,a_b_j,:,:)));
            
            for b_k_i= kernel_center + ( -(align-1) : align-1),
                for b_k_j = kernel_center + ( -(align-1) : align-1),
                    b_b_i = a_b_i + b_k_i - kernel_center;
                    b_b_j = a_b_j + b_k_j - kernel_center;
                    
                    if b_b_i>0 && b_b_j>0 && b_b_i<=align && b_b_j<=align
                        a_b_index = sub2ind([align,align] , a_b_i , a_b_j);
                        b_b_index = sub2ind([align,align] , b_b_i , b_b_j);
                        if kernels_in_block(a_b_i , a_b_j , b_k_i , b_k_j)/normalizer>0.05,
                            
                        %graph(a_b_index , b_b_index) = exp( - (block_seed(a_b_index)-block_seed(b_b_index))^2/(var_block*0.15));
                        graph(a_b_index , b_b_index) = exp( - (block_seed(a_b_index)-block_seed(b_b_index))^2/300);    
                        graph(b_b_index , a_b_index) = graph(a_b_index , b_b_index);
                        end
                    end
                    
                end
            end
            %end of inner loop
                        
        end
    end
    %end of outter loop

end




