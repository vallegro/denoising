function [W] = GetSKernel( h, C, r, ksize,nsize)

% [SKR0_REGULAR]
% The zeroth order steering kernel regression function for regularly sampled
% data.
%
% [USAGE]
% z = skr0_regular(y, h, C, r, ksize)
%
% [RETURNS]
% z     : the estimated image
%
% [PARAMETERS]
% y     : the input image
% h     : the global smoothing parameter
% C     : the covariance matrices containing local orientation information
% r     : the upscaling factor ("r" must be an integer number)
% ksize : the size of the kernel (ksize x ksize, and "ksize" must be
%         an odd number)
%
% [HISTORY]
% June 17, 2007 : created by Hiro
% Apr  14, 2008 : the transpose operator is fixed by Hiro

% Get the oritinal image size

% Pixel sampling positions
radius = (ksize - 1) / 2;
center = (nsize + 1) / 2;
[x2, x1] = meshgrid(-radius-(r-1)/r : 1/r : radius, -radius-(r-1)/r : 1/r : radius);


% pre-culculation for covariance matrices
C11(1:nsize , 1:nsize) = C(1:1 , 1:1 , 1:nsize , 1:nsize);
C12(1:nsize , 1:nsize) = C(1:1 , 2:2 , 1:nsize , 1:nsize);
C22(1:nsize , 1:nsize) = C(2:2 , 2:2 , 1:nsize , 1:nsize);
sq_detC = C11.*C22-C12.^2;

% Estimate an image and its first gradients with pixel-by-pixel

n = center - radius;
m = n;

% Neighboring samples to be taken account into the estimation


% compute the weight matrix
tt = x1 .* (C11(n:n+ksize-1, m:m+ksize-1) .* x1...
    + C12(n:n+ksize-1, m:m+ksize-1) .* x2)...
    + x2 .* (C12(n:n+ksize-1, m:m+ksize-1) .* x1...
    + C22(n:n+ksize-1, m:m+ksize-1) .* x2);
W = exp(-(0.5/h^2) * tt) .* sq_detC(n:n+ksize-1, m:m+ksize-1);

% Equivalent kernel
%Xw = W(:);
% A = inv(Xx' * Xw)\(Xw');
% 
% % Estimate the pixel values at (nn,mm)
% z(nn,mm)   = A(1,:) * yp(:);
end

