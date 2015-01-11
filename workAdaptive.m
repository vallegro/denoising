% load image
img = double(imread('/home/vallegro/space/Resources/lena.pgm'));
%im = img(197:284,197:284);
im = img;
im_size = size(im);

load('results/seed');

%seed = seed(197:284,197:284);

% add white Gaussian noise
sigma = 25;        % standard deviation
randn('state', 0); % initialization
y_noise = round0_255(im + randn(size(im)) * sigma);

align = 8;

g_kernel = SKHeter( seed, 8 );
%g_kernel = SKHeterAdaptive( seed , 8 , pyramid_map  );

file_name = strcat('results/g_kernel_',datestr(clock),'.mat');
save(file_name,'g_kernel');

lambda = 0:0.1:1;
len = length(lambda);

seed_mirrored = EdgeMirror(seed, [align/2 align/2] );

pyramid_map = AdaptivePyramid(seed_mirrored);
levels = lrflip(unique(pyramid_map));    % example output with three levels 254 127 0  
block_size_l = lrflip(align_min*2.^(1:levels));




