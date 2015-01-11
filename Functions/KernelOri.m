function[ kernel , nei_ks] = KernelOri( y_nei , h_c , r , ksize_c , ...
    n_size , wsize, lambda , alpha , h ,ksize , wradius  )
%KERNELLOOP Summary of this function goes here
%   Detailed explanation goes here
    
    %[y_nei,sim_pixels] = DistinctPixelRemoval(y_nei, thre);
    [z_neic , z_neix1c , z_neix2c] = ckr2_regular(y_nei, h_c, r, ksize_c);
    steering_mat = steering(z_neix1c , z_neix2c, ones(n_size), wsize, lambda, alpha);
    kernel = GetSKernel(h,steering_mat,r,ksize,n_size);
    nei_ks = z_neic(1+wradius:end-wradius , 1+wradius:end-wradius);


end

