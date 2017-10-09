function x = ipca_2D(x_pca,x_basis)
    x_sz = size(x_pca);
    x_vec = reshape(x_pca,x_sz(1)*x_sz(2),[])';
    x = reshape((x_basis*x_vec)',x_sz);
end