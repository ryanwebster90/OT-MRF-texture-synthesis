function x = col2im_patch_sample(x,X,patch_sample,varargin)

opts.M = 1e8;
opts.nonzero_only = 1;
opts = vl_argparse(opts,varargin);

%num columns in each slice
m = floor(opts.M/size(X,1));
%number of slices
K = ceil(size(X,2)/m);

tmp = cast(zeros(numel(x),1),'like',x);
weights = cast(zeros(numel(x),1),'like',x); 

%compute sliced im2col
for k = 1:K
    slice = (k-1)*m+1:min(k*m,size(X,2));
    sliced_sample = patch_sample(:,slice);
    weights = weights + accumarray(sliced_sample(:),1,[numel(x),1]);
    X_sample = X(:,slice);
    tmp = tmp + accumarray(sliced_sample(:),X_sample(:),[numel(x),1]);

end

if opts.nonzero_only
    % invert only nonzero components
    nz = weights~=0;
    x(nz) = tmp(nz)./weights(nz);
else
    % invert as is (eg computing derivatives)
    nz = weights~=0;
    tmp(nz) = tmp(nz)./weights(nz);
    x = reshape(tmp,size(x));
end

%unsliced version
% w = accumarray(patch_sample(:),1);
% tmp = accumarray(patch_sample(:),X(:),[numel(x),1],@sum);
% nz = w~=0;
% x(nz) = tmp(nz)./w(nz);

