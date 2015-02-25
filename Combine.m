res1 = zeros(264,264);
res2 = zeros(256,256);
res3 = zeros(256,256);
res4 = zeros(256,256);
res5 = zeros(256,256);
res6 = zeros(256,256);





best_lambda = zeros(6,length(levels));
psnrs = zeros(6,length(levels));

for i_level = 1:length(levels);  
    pyramid_map_l1 = pyramid_map1==levels(i_level);
    for lambda = 0.1:0.1:1.6,
        res_name = sprintf('results/Npart%d_num1_lambda%.2f.pgm', i_level, lambda);
        res = imread( res_name );
        a = CalPSNRMask(res(1+align/2:end-align/2 , 1+align/2:end-align/2),...
                im, pyramid_map_l1(1+align/2:end-align/2 , 1+align/2:end-align/2));
        if psnrs(1, i_level) < a,
            best_lambda(1, i_level) = lambda;            
            psnrs(1, i_level) = a;
            res1(pyramid_map_l1) = res(pyramid_map_l1); 
        end
    end
end


for i_level = 1:length(levels);  
    pyramid_map_l2 = pyramid_map2==levels(i_level);
    for lambda = 0.1:0.1:1.6,
        res_name = sprintf('results/Npart%d_num2_lambda%.2f.pgm', i_level, lambda);
        res = imread( res_name );
        a = CalPSNRMask( res, im, pyramid_map_l2 );
        if psnrs(2,i_level) < a,
            best_lambda(2, i_level) = lambda; 
            psnrs(2, i_level) = a;
            res2(pyramid_map_l2) = res(pyramid_map_l2);
        end
    end
end

for i_level = 1:length(levels);  
    pyramid_map_l3 = pyramid_map3==levels(i_level);
    for lambda = 0.1:0.1:1.6,
        res_name = sprintf('results/Npart%d_num3_lambda%.2f.pgm', i_level, lambda);
        res = imread( res_name );
        a = CalPSNRMask(res(1+align/4:end , 1+align/4:end),...
                im(1:end-align/4 , 1:end-align/4),...
                pyramid_map_l3(1+align/4:end , 1+align/4:end))
        if psnrs(3, i_level) < a,
            best_lambda(3, i_level) = lambda;            
            psnrs(3, i_level) = a;
            res3(pyramid_map_l3) = res(pyramid_map_l3); 
        end
    end
end

for i_level = 1:length(levels);  
    pyramid_map_l4 = pyramid_map4==levels(i_level);
    for lambda = 0.1:0.1:1.6,
        res_name = sprintf('results/Npart%d_num4_lambda%.2f.pgm', i_level, lambda);
        res = imread( res_name );
        a = CalPSNRMask(res(1:end-align/4 , 1+align/4:end),...
                im(1+align/4:end,1:end-align/4),... 
                pyramid_map_l4(1:end-align/4 , 1+align/4:end))
        if psnrs(4, i_level) < a,
            best_lambda(4, i_level) = lambda;            
            psnrs(4, i_level) = a;
            res4(pyramid_map_l4) = res(pyramid_map_l4); 
        end
    end
end

for i_level = 1:length(levels);  
    pyramid_map_l5 = pyramid_map5==levels(i_level);
    for lambda = 0.1:0.1:1.6,
        res_name = sprintf('results/Npart%d_num5_lambda%.2f.pgm', i_level, lambda);
        res = imread( res_name );
        a = CalPSNRMask(res(1+align/4:end , 1:end-align/4),...
                im(1:end-align/4,1+align/4:end),...
                pyramid_map_l5(1+align/4:end , 1:end-align/4))
        if psnrs(5, i_level) < a,
            best_lambda(5, i_level) = lambda;            
            psnrs(5, i_level) = a;
            res5(pyramid_map_l5) = res(pyramid_map_l5); 
        end
    end
end

for i_level = 1:length(levels);  
    pyramid_map_l6 = pyramid_map6==levels(i_level);
    for lambda = 0.1:0.1:1.6,
        res_name = sprintf('results/Npart%d_num6_lambda%.2f.pgm', i_level, lambda);
        res = imread( res_name );
        a = CalPSNRMask(res(1:end-align/4 , 1:end-align/4),...
                im(1+align/4:end , 1+align/4:end), ...
                pyramid_map_l6(1:end-align/4 , 1:end-align/4))
        if psnrs(6, i_level) < a,
            best_lambda(6, i_level) = lambda;            
            psnrs(6, i_level) = a;
            res6(pyramid_map_l6) = res(pyramid_map_l6); 
        end
    end
end

res6 = OverLap6(res1,res2,res3,res4,res5,res6,pyramid_map1,pyramid_map2,pyramid_map3,pyramid_map4,pyramid_map5,pyramid_map6)



