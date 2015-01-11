function [ res_ker ] = KernelReg( g_kernel , y_noise , k_size, align) 
%   Do kernel regression based on the calculated kernel
%   Dec 10 2014 by val 
    k_radius = (k_size-1)/2;
    k_radius1 = align/2;
    
    im_size = size(y_noise);
    y_noise = EdgeMirror(y_noise, [k_radius1 k_radius1]);
    res_ker = zeros(im_size);
    
    for i1 = 1:im_size(1),
        for i2 = 1:im_size(2),
            ker(1:align+1 , 1:align+1) = g_kernel( i1+k_radius1, i2+k_radius1,...
                1+k_radius-k_radius1 :1+k_radius+k_radius1,...
                1+k_radius-k_radius1 :1+k_radius+k_radius1);
            y_ker = y_noise( i1:i1+align , i2:i2+align);
            res_ker(i1 , i2) = sum(sum(ker .* y_ker))/sum(sum(ker));
        end
    end
    

end

