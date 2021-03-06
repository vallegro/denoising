im_size = size(y_noise);
y_noise_mirrored = EdgeMirror(y_noise, [align/2 , align/2]);

lambda = 0.7;
len = length(lambda);

res0 = zeros([im_size len]);
res1 = zeros([im_size+align len]);
res2 = zeros([im_size len]);
psnr0 = zeros(len,1);
psnr1 = zeros(len,1);
psnr2 = zeros(len,1);

for i = 1:len,
    disp(i);
    
    res1(1:im_size(1)+align, 1:im_size(2)+align, i)= KGI(y_noise_mirrored, g_kernel, 8, lambda(i));
    
    res2(1:im_size(1), 1:im_size(2), i) = KGI(y_noise_mirrored(1+align/2:end-align/2 , 1+align/2:end-align/2),...
                                              g_kernel(1+align/2:end-align/2 , 1+align/2:end-align/2,:,:),...
                                              8,lambda(i));
    
    res0(1:im_size(1), 1:im_size(2), i) = OverLap(res1(1:im_size(1)+align, 1:im_size(2)+align, i),...
                                                  res2(1:im_size(1), 1:im_size(2), i),align);                                        
                                          
    res0i(1:im_size(1), 1:im_size(2)) = uint8(res0(1:im_size(1), 1:im_size(2), i));
    psnr0(i) = CalPSNR(res0i, im);
    
    res1i(1:im_size(1)+align, 1:im_size(2)+align) = uint8(res1(1:im_size(1)+align, 1:im_size(2)+align, i));
    psnr1(i) = CalPSNR(res1i(1+align/2:end-align/2,1+align/2:end-align/2), im);

    res2i(1:im_size(1), 1:im_size(2)) = uint8(res2(1:im_size(1), 1:im_size(2), i));
    psnr2(i) = CalPSNR(res2i, im);
    
	fprintf('lambda %d 0 %d 1 %d 2 %d\n',lambda(i), psnr0(i), psnr1(i), psnr2(i));
end