[pyramid_map_res, edge_mapres, levels] = AdaptivePyramidN(resab , num_level); 

for i_level = 1:length(levels);  
    pyramid_map_lres = pyramid_map_res==levels(i_level);
    psnrseed(i_level) = CalPSNRMask(seed, im, pyramid_map_lres);
    psnrres(i_level) = CalPSNRMask(resab, im, pyramid_map_lres);
end