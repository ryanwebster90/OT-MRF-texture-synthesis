function x_udwt = haar_udwt_2D(x,num_levels)
%filter RGB seperately
if size(x,3) > 1
    x_sz = size(x);
    x_udwt = zeros([x_sz(1),x_sz(2),(num_levels*3+1)*x_sz(3)],'like',x);
    for c = 1:size(x,3)
        band_ids = (c-1)*(3*num_levels+1)+1 : c*(3*num_levels+1);
        x_udwt(:,:,band_ids) = haar_udwt_2D(x(:,:,c),num_levels);
    end
else
    x_sz = size(x);
    x_udwt = zeros([x_sz,num_levels*3+1],'like',x);
    curr_dec = 1;
    for l = 1:num_levels
        band_num = (l-1)*3 +1;
        if l == 1
            x_ll = x;
        end

        x1 =  circshift(x_ll,[0,curr_dec]);
        x2 =  circshift(x_ll,[curr_dec,0]);
        x3 =  circshift(x_ll,[curr_dec,curr_dec]);

        x_hl = x_ll + x1 - x2 -x3;
        x_lh = x_ll - x1 + x2 -x3;
        x_hh = x_ll - x1 - x2 + x3;

        x_udwt(:,:,band_num) = 1/4*x_hl;
        x_udwt(:,:,band_num+1) = 1/4*x_lh;
        x_udwt(:,:,band_num+2) = 1/4*x_hh;

        x_ll = 1/4*(x_ll + x1 + x2 + x3);


        if l == num_levels
            x_udwt(:,:,end) = x_ll;
        end
        curr_dec = curr_dec*2;
    end


end
end