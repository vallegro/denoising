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

g_kernel = SKHeter(seed, align);

file_name = strcat('g_kernel_',datestr(clock),'.mat');
save(file_name,'g_kernel');

lambda = 0:0.1:3;
len = length(lambda);

res0 = zeros([im_size len]);
res1 = zeros([im_size+align len]);
res2 = zeros([im_size len]);
psnr0 = zeros(len,1);
psnr1 = zeros(len,1);
psnr2 = zeros(len,1);

for i = 1:len,
    disp(i);
        
    res1(1:im_size(1)+align, 1:im_size(2)+align, i)= KGI(y_noise, g_kernel, 8, lambda(i));
    
    res2(1:im_size(1), 1:im_size(2), i) = KGI(y_noise(1+align/2:end-align/2 , 1+align/2:end-align/2),...
                                              g_kernel(1+align/2:end-align/2 , 1+align/2:end-align/2,:,:),...
                                              8,lambda(i));
    
    res0(1:im_size(1), 1:im_size(2), i) = OverLap(res1(1:im_size(1)+align, 1:im_size(2)+align, i),...
                                                  res2(1:im_size(1), 1:im_size(2), i));                                        
                                          
    res0i(1:im_size(1), 1:im_size(2)) = uint8(res0(1:im_size(1), 1:im_size(2), i));
    psnr0(i) = CalPSNR(res0i, im);
    
    res1i(1:im_size(1)+align, 1:im_size(2)+align) = uint8(res1(1:im_size(1)+align, 1:im_size(2)+align, i));
    psnr1(i) = CalPSNR(res1i(1+align/2:end-align/2,1+align/2:end-align/2), im);

    res2i(1:im_size(1), 1:im_size(2)) = uint8(res2(1:im_size(1), 1:im_size(2), i));
    psnr2(i) = CalPSNR(res2i, im);
    
	fprintf('lambda %d 0 %d 1 %d 2 %d\n',lambda(i), psnr0(i), psnr1(i), psnr2(i));
end