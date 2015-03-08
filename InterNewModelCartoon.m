%% setup images
im = double(imread('/home/vallegro/Space/Resources/Mickey.jpg'));
im = rgb2gray(im);
im = imresize(im,0.3);
crop = floor(size(im)/8)*8;
im = double(im(1:crop(1),1:crop(2)));
im = round((im/max(max(im)))*255);
y_noise = im;

% 
% sigma = 25;        % standard deviation
% randn('state', 0); % initialization
% y_noise = round0_255(im + randn(size(im)) * sigma);

img = im;
align = 8; 

rand('state', 0);
I = double(rand(size(y_noise)) > 0.75);
I_mirrored = EdgeMirror(I,[align/2 align/2]);

y = double(y_noise);
y_noise = double(y_noise);
y_noise_mirrored = EdgeMirror(y_noise, [align/2 align/2]);


%% LARK
LARKInter;
seed = zs;
%% SKHeter
seed_mirrored = EdgeMirror(seed, [align/2 align/2] );
mirror_size = size(seed_mirrored);
g_kernel_size = [mirror_size, align*2+1,align*2+1];
g_kernel_lab = zeros(g_kernel_size);
par = gcp();

num = par.NumWorkers;
spmd(num)
    warning off;
    labwidth = ceil((mirror_size(2))/num);
    disp(labwidth*labindex);
    labpiece = seed_mirrored(1:end,1+(labindex-1)*labwidth : min(labwidth*labindex,(mirror_size(2))));    
    g_kernel_lab(1:end,1+(labindex-1)*labwidth : min(labwidth*labindex,mirror_size(2)),1:end,1:end) = ...
        SKHeter( labpiece, align );
    
end
g_kernel = g_kernel_lab{1}+g_kernel_lab{2}+g_kernel_lab{3}+g_kernel_lab{4};
save();

%% New Model
block_min = align;

lambda = 0.1:0.1:1.6;
num_lambda = length(lambda);

num_level = 3;
[pyramid_map1, edge_map1, levels] = AdaptivePyramidN(seed_mirrored , num_level);       

[pyramid_map2, edge_map2, ~] = AdaptivePyramidN(seed_mirrored(1+align/2:end-align/2,1+align/2:end-align/2),...
                                             num_level); %using num_level=3 
[pyramid_map3, edge_map3, ~] = AdaptivePyramidN(seed_mirrored(1+align/4:end-align*3/4,1+align/4:end-align*3/4),...
                                             num_level);
[pyramid_map4, edge_map4, ~] = AdaptivePyramidN(seed_mirrored(1+align/4:end-align*3/4,1+align*3/4:end-align/4),...
                                             num_level);
[pyramid_map5, edge_map5, ~] = AdaptivePyramidN(seed_mirrored(1+align*3/4:end-align/4,1+align/4:end-align*3/4),...
                                             num_level);                                         
[pyramid_map6, edge_map6, ~] = AdaptivePyramidN(seed_mirrored(1+align*3/4:end-align/4,1+align*3/4:end-align/4),...
                                             num_level);                                         
                                         
                                         
                                         
                                         
levels = sort((levels),'descend');    % example output with three levels 254 127 0  
block_sizes = [32,16,8,8]; %example 

for i_level = 1:num_level+1,
    pyramid_map_l1 = pyramid_map1==levels(i_level);
    pyramid_map_l2 = pyramid_map2==levels(i_level);
    pyramid_map_l3 = pyramid_map3==levels(i_level);
    pyramid_map_l4 = pyramid_map4==levels(i_level);
    pyramid_map_l5 = pyramid_map5==levels(i_level);
    pyramid_map_l6 = pyramid_map6==levels(i_level);
    
    block_size_l = block_sizes(i_level);
    
    fprintf('pyramid_level %d\n',i_level);
    
    parfor i_lambda = 1:length(lambda),
        
        %res1(1:mirror_size(1) , 1:mirror_size(2) , i_lambda ,i_level) = ...
        NewModelInter(y_noise_mirrored, I_mirrored, g_kernel, align, block_size_l, pyramid_map_l1 ,lambda(i_lambda),edge_map1,i_level,seed_mirrored,1);
        
        %res2(1:mirror_size(1)-align , 1:mirror_size(2)-align , i_lambda, i_level) = ...
        NewModelInter(y_noise_mirrored(1+align/2:end-align/2,1+align/2:end-align/2),...
                 I_mirrored(1+align/2:end-align/2,1+align/2:end-align/2),...
                        g_kernel(1+align/2:end-align/2,1+align/2:end-align/2,:,:),...
                        align, block_size_l, pyramid_map_l2, lambda(i_lambda), edge_map2,i_level,...
                        seed_mirrored(1+align/2:end-align/2,1+align/2:end-align/2),2);


                    
        NewModelInter(y_noise_mirrored(1+align/4:end-align*3/4,1+align/4:end-align*3/4),...
                 I_mirrored(1+align/4:end-align*3/4,1+align/4:end-align*3/4),...
                        g_kernel(1+align/4:end-align*3/4,1+align/4:end-align*3/4,:,:),...
                        align, block_size_l, pyramid_map_l3, lambda(i_lambda), edge_map3,i_level,...
                        seed_mirrored(1+align/4:end-align*3/4,1+align/4:end-align*3/4),3);

        NewModelInter(y_noise_mirrored(1+align*3/4:end-align/4,1+align/4:end-align*3/4),...
                 I_mirrored(1+align*3/4:end-align/4,1+align/4:end-align*3/4),...
                        g_kernel(1+align*3/4:end-align/4,1+align/4:end-align*3/4,:,:),...
                        align, block_size_l, pyramid_map_l4, lambda(i_lambda), edge_map4,i_level,...
                        seed_mirrored(1+align*3/4:end-align/4,1+align/4:end-align*3/4),4);
                                        
        NewModelInter(y_noise_mirrored(1+align/4:end-align*3/4,1+align*3/4:end-align/4),...
                I_mirrored(1+align/4:end-align*3/4,1+align*3/4:end-align/4),...
                        g_kernel(1+align/4:end-align*3/4,1+align*3/4:end-align/4,:,:),...
                        align, block_size_l, pyramid_map_l5, lambda(i_lambda), edge_map5,i_level,...
                        seed_mirrored(1+align/4:end-align*3/4,1+align*3/4:end-align/4),5);
                    
        NewModelInter(y_noise_mirrored(1+align*3/4:end-align/4,1+align*3/4:end-align/4),...
                 I_mirrored(1+align*3/4:end-align/4,1+align*3/4:end-align/4),...
                        g_kernel(1+align*3/4:end-align/4,1+align*3/4:end-align/4,:,:),...
                        align, block_size_l, pyramid_map_l6, lambda(i_lambda), edge_map6,i_level,...
                        seed_mirrored(1+align*3/4:end-align/4,1+align*3/4:end-align/4),6);
                       
        
    end
end