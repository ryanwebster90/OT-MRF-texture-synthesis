function [x_pca,x_basis] = pca_2D(x,varargin)
    x_sz = size(x);
    x_vec = reshape(x,x_sz(1)*x_sz(2),[])';
    %varargin optional param specifying basis
    if numel(varargin)
        x_basis = varargin{1};
    else
        [x_basis, ~] = eig(x_vec * x_vec');
    end

    % change to pca basis
    x_pca = reshape((x_basis' * x_vec)',x_sz);
end