function [ im ] = OverLapAB( im1, im2, pyra1, pyra2, level_num, sizes )
%OVERLAPAB Summary of this function goes here
%   Detailed explanation goes here

imsize1 = size(im1);
imsize2 = size(im2);
diff = imsize1 - imsize2;
ker1 = zeros(imsize1);
ker2 = zeros(imsize2);
ker1_tmp = zeros(imsize1);
ker2_tmp = zeros(imsize2);
levels = sort(unique(pyra1),'descend');

weights= [0.6,0.8,1,1];

for i =  1:level_num

    blocksize_l = sizes(i);
    kernel = fspecial('gaussian', sizes(i) ,sizes(i)/2);
    size1 = floor(imsize1/blocksize_l);
    size2 = floor(imsize2/blocksize_l);
    ker_lvl1 = repmat(kernel , size1)/max(max(kernel));
    ker_lvl2 = repmat(kernel , size2)/max(max(kernel));
    
    ker1_tmp(1:size1(1)*blocksize_l , 1:size1(1)*blocksize_l)=ker_lvl1*weights(i);
    ker2_tmp(1:size2(1)*blocksize_l , 1:size2(1)*blocksize_l)=ker_lvl2*weights(i);
    
    mask1 = pyra1==levels(i);
    mask2 = pyra2==levels(i);
    
    ker1(mask1) = ker1_tmp(mask1);
    ker2(mask2) = ker2_tmp(mask2);

end

im1_temp = double(im1).*ker1;
im2_temp = double(im2).*ker2;
im = (im1_temp(1+diff(1)/2:end-diff(1)/2 , 1+diff(2)/2:end-diff(2)/2)+im2_temp)...
      ./(ker1(1+diff(1)/2:end-diff(1)/2 , 1+diff(2)/2:end-diff(2)/2)+ker2);


end

