function [ block_res, slct ] = DistinctPixelRemoval( block  , threshold)
%DISTINCTPIXELREMOVE Summary of this function goes here
%   Detailed explanation goes here
    block_size  = size(block);
    coord_c = (block_size(1)+1)/2;
    center = block(coord_c , coord_c);
    
    err = abs(double(block) - double(center));
    slct = err(:)<threshold;
    
    graph_seed  = ones(block_size);
    neis = [ -1,0 ; 0,-1 ; 1,0 ; 0,1 ];
    
    lap = Node2Lap(graph_seed , neis);
    
    lamda = 0.01;
     
    x= (diag(slct)+lamda*lap)^(-1)*(block(:).*slct);

    block_res = reshape(x,block_size);
    slct = reshape(slct,block_size);
end

