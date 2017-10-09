function y = MRF_NN_constraint(y,x,dataratio,patchsize,varargin)


x_sz = size(x);
[x_patch_inds,x_inds] =create_patch_sample(x_sz,patchsize,dataratio);
[y_patch_inds,y_inds] =create_patch_sample(x_sz,patchsize,dataratio);
X = im2col_patch_sample(x,x_patch_inds);
Y = im2col_patch_sample(y,y_patch_inds);

Y = nn_search(

fprintf('injection ratio (1 = bijection): %10.3e\n',numel(unique(P))/numel(P));
Y = X(:,P(:));

y = col2im_patch_sample(y,Y,y_patch_inds);