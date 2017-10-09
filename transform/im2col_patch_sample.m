function X = im2col_patch_sample(x,patch_sample_inds)


X = reshape(x(patch_sample_inds(:)),size(patch_sample_inds,1),[]);