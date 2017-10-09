function y = MRF_OT_constraint(y,x,dataratio,patchsize,varargin)
% sinkhorn options
% epsilon is entropic regularization
opts.epsilon = 2e-3;
opts.N_iter = 1;
opts = vl_argparse(opts,varargin);


x_sz = size(x);
[x_patch_inds,x_inds] =create_patch_sample(x_sz,patchsize,dataratio);
[y_patch_inds,y_inds] =create_patch_sample(x_sz,patchsize,dataratio);
X = im2col_patch_sample(x,x_patch_inds);
Y = im2col_patch_sample(y,y_patch_inds);

if isa(x,'gpuArray');gd = gpuDevice;end;

t0 = tic;
C = l2_dist_mat(X,Y);
if isa(x,'gpuArray');wait(gd);end;
fprintf('time elapsed for l2 dist computation = %10.3e\n',toc(t0));

t0 = tic;
[E,gamma] = sinkhorn(C,'epsilon',opts.epsilon,'N_iter',opts.N_iter);
if isa(x,'gpuArray');wait(gd);end;
fprintf('time elapsed for sinkhorn = %10.3e\n',toc(t0));


clear('C');

[~,P]= max(gamma,[],1);

fprintf('injective ratio: %10.3e\n',numel(unique(P))/numel(P));
Y = X(:,P(:));

y = col2im_patch_sample(y,Y,y_patch_inds);



