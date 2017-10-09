function y = OT_1D(y,x,varargin)

opts.precomputed = 1;
opts = vl_argparse(opts,varargin);

% sort channels of y
y_sz = size(y);
y = reshape(y,y_sz(1)*y_sz(2),[]);
[~,y_ids] = sort(y,1);


if ~opts.precomputed
    %sort channels of exemplar x
    x = reshape(x,size(x,1)*size(x,2),[]);
    [x,~] = sort(x,1);
end

%linearize sorted indices in y
lin_offset = repmat( (0:size(y,2)-1)*size(y,1),[size(y,1),1]);
y_ids = y_ids + lin_offset;
y(y_ids(:)) = x(:);

%reshape to input size
y = reshape(y,y_sz);