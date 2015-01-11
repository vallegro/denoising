% load image
im = double(imread('/home/vallegro/space/Resources/lena.pgm'));
im = im(197:284,197:284);
im_size = size(im);

load('results/SKResult17');

seed(1:512 , 1:512) = z(:,:,13);
seed = seed(197:284,197:284);


% add white Gaussian noise
sigma = 25;        % standard deviation
randn('state', 0); % initialization
y_noise = round0_255(im + randn(size(im)) * sigma);

load('g_kernel_18-Dec-2014 22:49:01');

lambda = 0.4:0.1:1.8;
len = length(lambda);

align = 8;

res0 = zeros([im_size len]);
res1 = zeros([im_size+align len]);
res2 = zeros([im_size len]);
psnr0 = zeros(len,1);
psnr1 = zeros(len,1);
psnr2 = zeros(len,1);

for i = 1:len,
    disp(i);
    
    [res0(1:im_size(1), 1:im_size(2), i),...
     res1(1:im_size(1)+align, 1:im_size(2)+align, i),...
     res2(1:im_size(1), 1:im_size(2), i)]= KGISpectrum(y_noise, g_kernel, 8, 625);
    
    res0i(1:im_size(1), 1:im_size(2)) = uint8(res0(1:im_size(1), 1:im_size(2), i));
    psnr0(i) = CalPSNR(res0i, im);
    
    res1i(1:im_size(1)+align, 1:im_size(2)+align) = uint8(res1(1:im_size(1)+align, 1:im_size(2)+align, i));
    psnr1(i) = CalPSNR(res1i(1+align/2:end-align/2,1+align/2:end-align/2), im);

    res2i(1:im_size(1), 1:im_size(2)) = uint8(res2(1:im_size(1), 1:im_size(2), i));
    psnr2(i) = CalPSNR(res2i, im);

    
	fprintf('lambda %d 0 %d 1 %d 2 %d\n',lambda(i), psnr0(i), psnr1(i), psnr2(i));
end