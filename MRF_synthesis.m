function y = MRF_synthesis(x0,varargin)
opts.N_scales = 4;
opts.N_iter = 4;
opts.patchsize = 14;
opts.dataratio = .04;
opts.MRF_constraint = 'OT';
opts.wavelet_OT_1D = 0;
opts.L = 3;
opts.epsilon = 3e-3;
opts = vl_argparse(opts,varargin);

isgpu = isa(x0,'gpuArray');
if isgpu;gd = gpuDevice;end;

figure
t0 = tic;
for scale = 1:opts.N_scales
    x = resize_image_2D(x0, 1/2^(opts.N_scales-scale));
    if opts.wavelet_OT_1D
        if isgpu;x = gather(x);end
        [x_basis,x_udwt_sorted] = precompute_wavelet_OT_1D(x,opts.L);
        if isgpu;x = gpuArray(x);end
    end
    
    if scale >1
        y = resize_image_2D(y,size(x));
    else
        y = cast(rand(size(x)),'like',x);
    end
    
    for iter = 1:opts.N_iter
        if strcmp(opts.MRF_constraint,'OT');
            y = LM_MRF_sinkhorn(y,x,opts.dataratio,opts.patchsize,...
                'epsilon',opts.epsilon,'M',5e7);
%             y = MRF_OT_constraint(y,x,...
%                 opts.dataratio,opts.patchsize,'epsilon',opts.epsilon);
        else
        end
        
        if opts.wavelet_OT_1D
            %this constraint runs much faster on cpu
            if isgpu;y = gather(y);end
            y = wavelet_OT_1D_constraint(y,opts.L,x_basis,x_udwt_sorted);
            if isgpu;y = gpuArray(y);end
        end
        
        imshow(y);
        title(['synthesis iter: ',num2str(iter),...
            ' synthesis scale: ',num2str( 1/2^(opts.N_scales-scale))])
        drawnow
    end
    
end
if isa(x0,'gpuArray');wait(gd);end;
disp(['Algorithm time: ',num2str(toc(t0))]);