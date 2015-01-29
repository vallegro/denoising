function [pyramid_map, edge_map, level_c] = AdaptivePyramidN(im,level_num )
% divide the image into blocks with various sizes of blocks
% and there are no edges in large blocks, and classify the 
% smallest blocks with or without an edge. 

    edge_map = edge(im,'canny',0.25);
    im_size = size(im);
    pyramid_map = zeros(im_size);
    level_bs = fliplr(8.*(2.^(0:level_num-1)));
    level_c = fliplr(0:floor(255/level_num):255);
    
    for i = 1:level_num,   %the smallest block size has no need to check 
        block_size = level_bs(i);              
        for block_i = 1:block_size:im_size(1)-block_size+1,
            for block_j =1:block_size:im_size(2)-block_size+1;
                if pyramid_map(block_i,block_j) > 0;
                    continue;
                end                    
                edge_block = edge_map(block_i:block_i+block_size-1,...
                                      block_j:block_j+block_size-1);
                has_edge = sum(sum(edge_block));                  
                if has_edge == 0 ;
                   pyramid_map(block_i:block_i+block_size-1,...
                               block_j:block_j+block_size-1) = level_c(i);         
                end
            end
        end
    end
end