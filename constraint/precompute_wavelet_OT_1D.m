function [x_basis,x_udwt_sorted] = precompute_wavelet_OT_1D(x,L)

[x_pca,x_basis] = pca_2D(x);
x_udwt = haar_udwt_2D(x_pca,L);
x_udwt = reshape(x_udwt,[],size(x_udwt,3));

x_udwt_sorted = sort(x_udwt,1);
