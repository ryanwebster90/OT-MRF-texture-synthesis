function x = haar_iudwt_2D(x_sz,x_udwt)
    if numel(x_sz) == 3
        C = x_sz(3);
        num_levels = (size(x_udwt,3)-C)/(3*C);
        x = zeros(x_sz,'like',x_udwt);
        for c = 1:C
            band_ids = (c-1)*(3*num_levels+1)+1 : c*(3*num_levels+1);

            x(:,:,c) = haar_iudwt_2D(x_sz(1:2),x_udwt(:,:,band_ids));
        end
    else
        n = (size(x_udwt,3)-1)/3;
        x_ll = x_udwt(:,:,end);
        for l = n:-1:1
            band_num = (l-1)*3+1;
            curr_dec = -2^(l-1);

            x_band = x_udwt(:,:,band_num);
            x1 =  circshift(x_band,[0,curr_dec]);
            x2 =  circshift(x_band,[curr_dec,0]);
            x3 =  circshift(x_band,[curr_dec,curr_dec]);
            x_hl = x_band +x1 - x2 -x3;

            x_band = x_udwt(:,:,band_num+1);
            x1 =  circshift(x_band,[0,curr_dec]);
            x2 =  circshift(x_band,[curr_dec,0]);
            x3 =  circshift(x_band,[curr_dec,curr_dec]);
            x_lh = x_band -x1 +x2 -x3;

            x_band = x_udwt(:,:,band_num+2);
            x1 =  circshift(x_band,[0,curr_dec]);
            x2 =  circshift(x_band,[curr_dec,0]);
            x3 =  circshift(x_band,[curr_dec,curr_dec]);
            x_hh = x_band - x1 - x2 + x3;

            x_band = x_ll;
            x1 =  circshift(x_band,[0,curr_dec]);
            x2 =  circshift(x_band,[curr_dec,0]);
            x3 =  circshift(x_band,[curr_dec,curr_dec]);
            x_ll = x_ll + x1 + x2 + x3;

            x_ll = 1/4*(x_ll + x_hl + x_lh + x_hh);
        end
        x = x_ll;
    end
end