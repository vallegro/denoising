function [  ] = ShowKernel( g_kernel,y,x )
%SHOWKERNEL Summary of this function goes here
%   Detailed explanation goes here

imtool(uint8(reshape(g_kernel(y,x,1:17,1:17),17,17)/max(max(g_kernel(y,x,1:17,1:17)))*255));

end

