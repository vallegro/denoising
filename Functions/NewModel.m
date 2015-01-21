function [ ] = NewModel( y_noise, g_kernel, align, block_size_l, block_map ,lambda_g, edge_map )
%LINEARFITTING Summary of this function goes here
%   Detailed explanation goes here
im_size = size(y_noise);

ksize = 2*align + 1;
k_rad = align+1;
g_kernel(:,:,k_rad,k_rad) = 0;

res = zeros(im_size);
resL = res;

for block_i = 1:block_size_l:im_size(1),
    for block_j = 1:block_size_l:im_size(2),
        %fprintf('%d,%d\n',block_i,block_j);
        if block_map(block_i, block_j)~=0,
            block = y_noise(block_i : block_i+block_size_l-1,...
                            block_j : block_j+block_size_l-1);
            block_edge = edge_map(block_i : block_i+block_size_l-1,...
                                  block_j : block_j+block_size_l-1); 
                        
            linear_base = zeros(block_size_l);            
            
            [c1,c2]=meshgrid(1:block_size_l , 1:block_size_l);
            c3 = ones(block_size_l);
            if sum(sum(block_edge))~=0,
                cluster_num =2;
                disp(cluster_num);
            else
                cluster_num =1;
                disp(cluster_num);
            end
        
            idx = HorizonDivide(cluster_num, block_edge, block);
            idce = unique(idx);
            cluster_num = length(idce);
            for i_cluster = 1:cluster_num,
                in_cluster = (idx==idce(i_cluster));
                C = [c1(in_cluster) c2(in_cluster) c3(in_cluster)] ;
                d = block(in_cluster);
                try 
                    X = lsqlin(C,d,[],[]);
                catch err
                    disp(err)
                end
                linear_base_cluster = [c1(:) c2(:) c3(:)]*X;
                linear_base_cluster = reshape(linear_base_cluster , [block_size_l block_size_l]);
                linear_base(in_cluster) = linear_base_cluster(in_cluster);
            end
            
            if sum(sum(isnan(linear_base)));
                linear_base(isnan(linear_base)) = mean(mean(linear_base(~isnan(linear_base)))); 
            end
            residual = block - linear_base;
            kernels_in_block = g_kernel(block_i : block_i+block_size_l-1,...
                                         block_j : block_j+block_size_l-1,:,:);
            graph = BlockGraphFromKernels(kernels_in_block , block_size_l, ksize);
            lap = CalLap(graph);
            residual_res = (eye(block_size_l*block_size_l)+lambda_g*lap)^(-1)*residual(:);
            block_res = linear_base + reshape(residual_res, [block_size_l block_size_l]);
            
            res(block_i : block_i+block_size_l-1,...
                block_j : block_j+block_size_l-1) = block_res;           
            
            resL(block_i : block_i+block_size_l-1,...
                block_j : block_j+block_size_l-1) =linear_base;           

        end
    end
end



file_name = sprintf('results/Npart%d_size%d_lambda%.2f.ppm',log2(block_size_l/8),im_size(1),lambda_g);
imwrite(uint8(res),file_name);


file_name = sprintf('results/Lpart%d_size%d_lambda%.2f.ppm',log2(block_size_l/8),im_size(1),lambda_g);
imwrite(uint8(resL),file_name);

end

