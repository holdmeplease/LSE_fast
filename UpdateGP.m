function [u, sigma] = UpdateGP(t, point_query, answer_query, sigma_noise, U, num_U)
%��������δ������u��segma
%���룺t:�Ѳ�ѯ�������point_query��answer_query:�Ѳ�ѯ��Ͳ�ѯ���
%     segma_noise:������׼�U��num_U:δ����㼯�Ϻ�δ��������
%�����ÿ��δ�����ľ�ֵ�ͱ�׼��ֱ�洢��u��segma��
u = zeros(num_U, 1);
sigma = zeros(num_U, 1);
k_lower = zeros(t, 1);
k_upper = zeros(t);
var_noise_maxtri = zeros(t);
for m = 1 : t
   for n = 1 : t
      if m == n
          var_noise_maxtri(m, n) = sigma_noise^2;
      end
   end
end
for m = 1 : num_U
    for n = 1 : t
       k_lower(n) = squared_exp_kernel(point_query(n, :), U(m, :)); 
       for p = 1 : t
          k_upper(n,p) = squared_exp_kernel(point_query(n, :), point_query(p, :));
       end
    end
    u(m) = k_lower' * inv(k_upper + var_noise_maxtri) * answer_query(1 : t);
    sigma(m) = sqrt(squared_exp_kernel(U(m, :), U(m, :)) - k_lower' * inv(k_upper + var_noise_maxtri) * k_lower);
end