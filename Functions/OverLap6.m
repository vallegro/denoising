function [im] = OverLap6(im1,im2,im3,im4,im5,im6, ...
                       pyra1,pyra2,pyra3,pyra4,pyra5,pyra6)
                 
align=8;
level_num =4;
sizes = [32,16,8,8];

imsize1 = size(im1);
imsize2 = size(im2);

ker1 = zeros(imsize1);
ker2 = zeros(imsize2);
ker3 = zeros(imsize2);
ker4 = zeros(imsize2);
ker5 = zeros(imsize2);
ker6 = zeros(imsize2);

ker1_tmp = zeros(imsize1);
ker2_tmp = zeros(imsize2);

levels = sort(unique(pyra1),'descend');

weights= [1,1.1,1.3,2];

for i =  1:level_num,

    blocksize_l = sizes(i);
    kernel = fspecial('gaussian', sizes(i) ,sizes(i)/2);
    size1 = floor(imsize1/blocksize_l);
    size2 = floor(imsize2/blocksize_l);
    ker_lvl1 = repmat(kernel , size1)/max(max(kernel));
    ker_lvl2 = repmat(kernel , size2)/max(max(kernel));
                    
    ker1_tmp(1:size1(1)*blocksize_l , 1:size1(2)*blocksize_l)=ker_lvl1*weights(i);
    ker2_tmp(1:size2(1)*blocksize_l , 1:size2(2)*blocksize_l)=ker_lvl2*weights(i);
    
    mask1 = pyra1==levels(i);
    mask2 = pyra2==levels(i);
    mask3 = pyra3==levels(i);
    mask4 = pyra4==levels(i);
    mask5 = pyra5==levels(i);
    mask6 = pyra6==levels(i);
                            
    ker1(mask1) = ker1_tmp(mask1);
    ker2(mask2) = ker2_tmp(mask2);
    ker3(mask3) = ker2_tmp(mask3);
    ker4(mask4) = ker2_tmp(mask4);
    ker5(mask5) = ker2_tmp(mask5);
    ker6(mask6) = ker2_tmp(mask6);        
            
end            
    
im_tmp1 = im1.*ker1;
im_tmp2 = im2.*ker2;
im_tmp3 = im3.*ker3;
im_tmp4 = im4.*ker4;
im_tmp5 = im5.*ker5;
im_tmp6 = im6.*ker6;

im = double(zeros(imsize1));
weight = double(zeros(imsize1));

im = im+im_tmp1;
im(1+align/2:end-align/2,1+align/2:end-align/2) = im(1+align/2:end-align/2,1+align/2:end-align/2)+im_tmp2;
im(1+align/4:end-align*3/4,1+align/4:end-align*3/4) = im(1+align/4:end-align*3/4,1+align/4:end-align*3/4)+im_tmp3;
im(1+align*3/4:end-align/4,1+align/4:end-align*3/4) = im(1+align*3/4:end-align/4,1+align/4:end-align*3/4)+im_tmp4;
im(1+align/4:end-align*3/4,1+align*3/4:end-align/4) = im(1+align/4:end-align*3/4,1+align*3/4:end-align/4)+im_tmp5;
im(1+align*3/4:end-align/4,1+align*3/4:end-align/4) = im(1+align*3/4:end-align/4,1+align*3/4:end-align/4)+im_tmp6;

weight = weight+ker1;
weight(1+align/2:end-align/2,1+align/2:end-align/2) = weight(1+align/2:end-align/2,1+align/2:end-align/2)+ker2;
weight(1+align/4:end-align*3/4,1+align/4:end-align*3/4) = weight(1+align/4:end-align*3/4,1+align/4:end-align*3/4)+ker3;
weight(1+align*3/4:end-align/4,1+align/4:end-align*3/4) = weight(1+align*3/4:end-align/4,1+align/4:end-align*3/4)+ker4;
weight(1+align/4:end-align*3/4,1+align*3/4:end-align/4) = weight(1+align/4:end-align*3/4,1+align*3/4:end-align/4)+ker5;
weight(1+align*3/4:end-align/4,1+align*3/4:end-align/4) = weight(1+align*3/4:end-align/4,1+align*3/4:end-align/4)+ker6;

im = im./weight;
im = im(5:end-4,5:end-4);

end