lamb_len = length(lambda);
psnr_mat_size = [im_size/align, lamb_len];
im_mat = [im_size/align align align];
psnr_mat = zeros(psnr_mat_size);

for i = 1:lamb_len,
    b(1:im_size(1) , 1:im_size(2)) = res2(:,:,i);
    [psnr_mat( :,:,i), im_mat] = CalPSNRPerBlock(b , im , align);
end


for i = 1:psnr_mat_size(1),
    for j = 1:psnr_mat_size(2),
        block_psnr(1:lamb_len) = psnr_mat(i,j,:);
        
        subplot(11,22,((i-1)*11+j)*2-1 );
        plot(block_psnr);
        
        block = reshape( im_mat( i,j, :, :), 8, 8);
        
        subplot(11,22,((i-1)*11+j)*2);        
        imshow(uint8( block ));
        %imshow( uint8(im(1+align*(i-1): align*i , 1+align*(j-1): align*j) ) );
        fprintf('%d %d\n',i,j);        
    end
end


clear b block_psnr;