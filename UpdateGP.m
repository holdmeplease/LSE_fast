function [u, sigma] = UpdateGP(t, point_query, answer_query, sigma_noise, U, num_U)
%计算所有未分类点的u和segma
%输入：t:已查询点个数，point_query、answer_query:已查询点和查询结果
%     segma_noise:噪声标准差，U、num_U:未分类点集合和未分类点个数
%输出：每个未分类点的均值和标准差，分别存储在u和segma中
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