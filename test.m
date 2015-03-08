for i_level = 1;  
    pyramid_map_l2 = pyramid_map2==levels(i_level);
    for lambda = 0.1:0.1:0.5,
        res_name = sprintf('results/Npart%d_num2_lambda%.2f.pgm', i_level, lambda);
        res = imread( res_name );
        a = CalPSNRMask( res, im, pyramid_map_l2 )
    end
end