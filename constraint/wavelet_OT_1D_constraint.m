function y = wavelet_OT_1D_constraint(y,L,x_basis,x_udwt_sorted)

% take independent component of colors
[y_pca,~] = pca_2D(y,x_basis);

%take haar wavelet transform
y_udwt = haar_udwt_2D(y_pca,L);

% do OT on wavelet subbands
y_udwt = OT_1D(y_udwt,x_udwt_sorted);

% invert to image domain
y_pca = haar_iudwt_2D(size(y),y_udwt);
y = ipca_2D(y_pca,x_basis);
