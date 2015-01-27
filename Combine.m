res1 = zeros(520);
res2 = zeros(512);

best_lambda = zeros(2,length(levels));
psnrs = zeros(2,length(levels));
psnrseed = zeros(1,length(levels));

for i_level = 1:length(levels);  
    pyramid_map_l1 = pyramid_map1==levels(i_level);
    for lambda = 0.1:0.1:1.6,
        res_name = sprintf('results/Npart%d_size520_lambda%.2f.pgm', i_level, lambda);
        res = imread( res_name );
        a = CalPSNRMask(res(1+align/2:end-align/2 , 1+align/2:end-align/2),...
                im, pyramid_map_l1(1+align/2:end-align/2 , 1+align/2:end-align/2))
        if psnrs(1, i_level) < a,
            best_lambda(1, i_level) = lambda;            
            psnrs(1, i_level) = a;
            res1(pyramid_map_l1) = res(pyramid_map_l1); 
        end
    end
end


for i_level = 1:length(levels);  
    pyramid_map_l2 = pyramid_map2==levels(i_level);
    psnrseed(i_level) = CalPSNRMask(seed, im, pyramid_map_l2);
    for lambda = 0.1:0.1:1.6,
        res_name = sprintf('results/Npart%d_size512_lambda%.2f.pgm', i_level, lambda);
        res = imread( res_name );
        a = CalPSNRMask( res, im, pyramid_map_l2 )
        if psnrs(2,i_level) < a,
            best_lambda(2, i_level) = lambda; 
            psnrs(2, i_level) = a;
            res2(pyramid_map_l2) = res(pyramid_map_l2);
        end
    end
end