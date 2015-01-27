% load image
%img = double(imread('/home/vallegro/space/Resources/lena.pgm'));
img = double(imread('/home/vallegro/Space/Resources/disp.pgm'));
%im = img(197:284,197:284);
im = img;

load('results/seed');

%seed = seed(197:284,197:284);

% add white Gaussian noise
sigma = 25;        % standard deviation
randn('state', 0); % initialization
y_noise = round0_255(im + randn(size(im)) * sigma);

align = 8;

g_kernel = SKHeter( seed, align );
%g_kernel = SKHeterAdaptive( seed , 8 , pyramid_map  );

file_name = strcat('results/g_kernel_',datestr(clock),'.mat');
save(file_name,'g_kernel');

block_min = align;
lambda = 0:0.1:1;
num_lambda = length(lambda);

seed_mirrored = EdgeMirror(seed, [align/2 align/2] );
mirror_size = size(seed_mirrored);

num_level = 3;
pyramid_map = AdaptivePyramid(seed_mirrored); %using num_level=3 
levels = lrflip(unique(pyramid_map));    % example output with three levels 254 127 0  
block_sizes = lrflip(block_min*2.^(1:levels)); %example 

res1 = zeros( [mirror_size num_lambda num_level]);
res2 = zeros( [mirror_size-align num_lambda num_level]);
res0 = zeros( [mirror_size-align num_lambda num_level]);

psnr1 = zeros([num_level num_lambda]);
psnr2 = zeros([num_level num_lambda]);
psnr0 = zeros([num_level num_lambda]);

for i_level = 1:num_level,
    pyramid_map_l = pyramid_map==levels(i_level);
    block_size_l = block_sizes(i_level);
    
    for i_lambda = 1:num_lambda,
        
        res1(1:mirror_size(1) , 1:mirror_size(2) , i_lambda ,i_level) = ...
            KGIAdaptive(y_noise, g_kernel, align, block_size_l, pyramid_map_l ,lambda(i_lambda));
        
        res2(1:mirror_size(1)-align , 1:mirror_size(2)-align , i_lambda, i_level) = ...
            KGIAdaptive(y_noise(1+align/2:end-align/2,1+align/2:end-align/2),...
                        g_kernel(1+align/2:end-align/2,1+align/2:end-align/2,:,:),...
                        align, block_size_l, pyramid_map_l, lambda(i_lambda));
        
        res0(1:mirror_size(1)-align , 1:mirror_size(2)-align , i_lambda, i_level) = ...
            OverLap(res1(1:mirror_size(1) , 1:mirror_size(2) , i_lambda, i_level),...
                    res2(1:mirror_size(1)-align , 1:mirror_size(2)-align , i_lambda, i_level),...
                    align);
        
        res0i(1:im_size(1), 1:im_size(2)) = uint8(res0(1:im_size(1), 1:im_size(2), i_lambda, i_level));
        psnr0(i_lambda, i_level) = CalPSNR(res0i, im);
        
        res1i(1:im_size(1)+align, 1:im_size(2)+align) = uint8(res1(1:im_size(1)+align, 1:im_size(2)+align, i_lambda, i_level));
        psnr1(i_lambda, i_level) = CalPSNR(res1i(1+align/2:end-align/2,1+align/2:end-align/2), im);
        
        res2i(1:im_size(1), 1:im_size(2)) = uint8(res2(1:im_size(1), 1:im_size(2), i_lambda, i_level));
        psnr2(i_lambda, i_level) = CalPSNR(res2i, im);
        
        fprintf('lambda %d 0 %d 1 %d 2 %d\n',...
            lambda(i_lambda), psnr0(i_lambda, i_level), psnr1(i_lambda, i_level), psnr2(i_lambda, i_level));
        
    end
end