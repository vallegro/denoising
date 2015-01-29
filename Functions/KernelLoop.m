function[ kernel ] = KernelLoop( y_nei , h_c , r , ksize_c , ...
    n_size , wsize, lambda , alpha , h ,ksize , wradius  )
%KERNELLOOP Summary of this function goes here
%   Detailed explanation goes here

num_anchor_old = -1;
thres = [40,10,2];
i = 1;
while i <= length(thres),
    
    thre = thres(i);
    [y_nei_sim,sim_pixels] = DistinctPixelRemoval(y_nei, thre);
    [z_neix1c , z_neix2c ] = Gradients( y_nei_sim , ksize_c , h_c);
    
    %need to debug for wradius
    steering_mat = steering(z_neix1c , z_neix2c, sim_pixels, wsize, lambda, alpha);
    s_kernel = GetSKernel_simslct( h , steering_mat , r , ksize , n_size ,...
                                   sim_pixels(1+wradius:end-wradius , 1+wradius:end-wradius));
    g_kernel = s_kernel;

    g_kernel_temp = g_kernel/max(max(g_kernel));
    num_anchor = sum(sum(g_kernel_temp>0.05));
    if num_anchor >= num_anchor_old,
        num_anchor_old = num_anchor;
        i = i+1;
        kernel = g_kernel;
        %fprintf('%d %d\n',thre,num_anchor);
    else
        %fprintf('*%d %d\n',thre,num_anchor);
        break;
    end
end

end

