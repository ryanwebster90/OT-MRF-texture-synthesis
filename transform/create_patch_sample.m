function [patch_sample_inds,sample_inds] = create_patch_sample(x_sz,patchsize,dataratio,varargin)
% create_patch_sample is used in conjuction with im2col_patch_sample
% to randomly sample patches in an input tensor with probability dataratio.
% im2col_patch_sample extracts these patches from a tensor x and stores
% them in their column stacked version X sized 
% [x_sz(3)*patchsize^2 , floor(x_sz(1)*x_sz(2)*dataratio)
%
% See also: create_sample_inds, im2col_patch_sample
%
% INPUTS:
%   x_sz = size of image to take patches from
%   patchsize = #pels in side of square patch
%   dataratio = 0...1 ratio of patches sampled (e.g. .5 samples half)
%
% OPTIONS:
%   'sample_inds'  As an alternative to dataratio, you can provide
%   sample_inds, the linear indices of topleft index of patches, which
%   are converted into every index of every patch.
% 
% OUTPUTS:
%   patch_sample_inds = every index in every patch contiguously.
%   sample_inds = topleft indices of patches in first two dims of x_sz
%
% Ryan Webster, 2017

opts.sample_inds = [];
opts = vl_argparse(opts,varargin);


x_sz = [x_sz,ones(1,3-numel(x_sz))];
%randomly sample 2d linear inds
sample_inds = create_sample_inds(x_sz,dataratio);


% turn linear sample inds into 2D inds
sample_inds = sample_inds-1;
j0  = floor(sample_inds/x_sz(1));
i0 = sample_inds-j0*x_sz(1);
patch_2d_inds = cat(1,i0(:)',j0(:)');

%expand into patch indices
[j0,i0,c0] = meshgrid(0:patchsize-1,0:patchsize-1,0:x_sz(3)-1);
i0 = bsxfun(@plus,patch_2d_inds(1,:),i0(:));
j0 = bsxfun(@plus,patch_2d_inds(2,:),j0(:));
c0 = bsxfun(@plus,zeros(1,size(patch_2d_inds,2)),c0(:));

%periodize pels outside of image
i0 = mod(i0,x_sz(1));
j0 = mod(j0,x_sz(2));

% turn back into linear indices
patch_sample_inds = c0*x_sz(1)*x_sz(2) + j0*x_sz(1) + i0;

patch_sample_inds = reshape(patch_sample_inds,patchsize*patchsize*x_sz(3),[]) + 1;
sample_inds = sample_inds+1;
