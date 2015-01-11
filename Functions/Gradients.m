function [ grad1 ,grad2 ] = Gradients( im , ksize, h)
%GRADIENTS Summary of this function goes here
%   Detailed explanation goes here
    im_size = size(im);
    radius = (ksize - 1)/2;
    [x2,x1] = meshgrid( -radius:1:radius, -radius:1:radius);
    tt = x1.*x1 + x2.*x2;
    w = exp(-(0.5/h^2) * tt);
    xw = [ x1(:).*w(:) , x2(:).*w(:) ];
    a = ([x1(:),x2(:)]'*xw)\xw';
    grad1 = zeros(im_size);
    grad2 = zeros(im_size);
    
    im = EdgeMirror(im, [radius radius]);
    
    for i = 1:im_size(1),
        for j = 1:im_size(2),
            imp = im(i:i+ksize-1 , j:j+ksize-1);
            grad1(i,j) = a(1,:)*imp(:);
            grad2(i,j) = a(2,:)*imp(:);                    
        end
    end   
end
    
    