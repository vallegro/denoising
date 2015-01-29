%% setup images
im = double(imread('/home/vallegro/Space/Resources/disp.pgm'));
im = imresize(im,0.3);
img = im;
align = 8;
sigma = 15;        % standard deviation
randn('state', 0); % initialization
y_noise = round0_255(im + randn(size(im)) * sigma);

y = double(y_noise);
y_noise_mirrored = EdgeMirror(y_noise, [align/2 align/2]);
%% LARK
LARK;
seed = z(:,:,13);
%% SKHeter
seed_mirrored = EdgeMirror(seed, [align/2 align/2] );
mirror_size = size(seed_mirrored);
g_kernel_size = [mirror_size, align*2+1,align*2+1];
g_kernel = zeros(g_kernel_size);
par = gcp();

num = par.NumWorkers;
spmd(num)
    warning off;
    labwidth = ceil((mirror_size(2))/num);
    disp(labwidth);
    labpiece = seed_mirrored(:,1+(labindex-1)*labwidth : min(labwidth*labindex,(mirror_size(2))));    
    g_kernel(:,1+(labindex-1)*labwidth : min(labwidth*labindex,mirror_size(2)),:,:) = ...
        SKHeter( labpiece, align );
    
end
g_kernel = g_kernel{1}+g_kernel{2}+g_kernel{3}+g_kernel{4};
save();

%% New Model
block_min = align;

lambda = 0.1:0.1:1.6;
num_lambda = length(lambda);

num_level = 3;
[pyramid_map1, edge_map1, levels] = AdaptivePyramidN(seed_mirrored , num_level);       
[pyramid_map2, edge_map2, levels] = AdaptivePyramidN(seed_mirrored(1+align/2:end-align/2,1+align/2:end-align/2),...
                                             num_level); %using num_level=3 
levels = sort((levels),'descend');    % example output with three levels 254 127 0  
block_sizes = [32,16,8,8]; %example 

res1 = zeros( [mirror_size num_lambda num_level]);
res2 = zeros( [mirror_size-align num_lambda num_level]);
res0 = zeros( [mirror_size-align num_lambda num_level]);

psnr1 = zeros([num_level num_lambda]);
psnr2 = zeros([num_level num_lambda]);
psnr0 = zeros([num_level num_lambda]);

for i_level = 4,
    pyramid_map_l1 = pyramid_map1==levels(i_level);
    pyramid_map_l2 = pyramid_map2==levels(i_level);
    block_size_l = block_sizes(i_level);
    
    fprintf('pyramid_level %d\n',i_level);
    
    parfor i_lambda = 1:num_lambda,
        
        %res1(1:mirror_size(1) , 1:mirror_size(2) , i_lambda ,i_level) = ...
        NewModel(y_noise_mirrored, g_kernel, align, block_size_l, pyramid_map_l1 ,lambda(i_lambda),edge_map1,i_level,seed_mirrored);
        
        %res2(1:mirror_size(1)-align , 1:mirror_size(2)-align , i_lambda, i_level) = ...
        NewModel(y_noise_mirrored(1+align/2:end-align/2,1+align/2:end-align/2),...
                        g_kernel(1+align/2:end-align/2,1+align/2:end-align/2,:,:),...
                        align, block_size_l, pyramid_map_l2, lambda(i_lambda), edge_map2,i_level,...
                        seed_mirrored(1+align/2:end-align/2,1+align/2:end-align/2));

        
    end
end