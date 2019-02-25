function k = squared_exp_kernel(point_a, point_b)
%如函数名所示，计算squared_exponential_kernel
l = exp(-1.5);
sigma_kernel_inside = exp(1); 
k = sigma_kernel_inside^2*exp(-((point_a(1)-point_b(1))^2+(point_a(2)-point_b(2))^2)/(2*l^2));