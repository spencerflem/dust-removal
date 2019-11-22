c_list = 0:0.001:2;
clear gm_out;

for p=1:length(c_list)
    if(mod(p-1,10) == 0)
    disp(p + "/" + length(c_list))
    end
    
    [grad_mag,grad_ang] = imgradient((i(:,:,3)-c_list(p).*b(:,:,3))./a(:,:,3));
    gm_out(p)=norm(grad_mag,1);
end

c_list(gm_out == min(gm_out))

plot(c_list, gm_out)