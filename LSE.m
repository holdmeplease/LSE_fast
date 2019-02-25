%复现《Active Learning for Level Set Estimation》
%The LSE algorithm
clear;
tic;
%初始化采样集D
sample_x = 30;
sample_y = 60;
[point_sample, num_sample] = PointSample2D(0,1,0,2,sample_x,sample_y);
%初始化参数
sigma_noise = exp(-1); %噪声标准差
H = zeros(num_sample, 2); %上水平集
num_H = 0; %上水平集中点个数
L = zeros(num_sample, 2); %下水平集
num_L = 0; %下水平集中点个数
U = point_sample; %未分类点集合
num_U = num_sample; %未分类点个数
u = zeros(num_sample, 1); %高斯均值的初值
sigma = zeros(num_sample, 1);
for m = 1 : num_U
    sigma(m) = exp(1); %高斯标准差的初值
end
C = zeros(num_sample, 2); %置信区间
Q = zeros(num_sample, 2);
h = -0.5; %阈值
beta_sqrt = 1.5; %控制置信区间的长度
acc = 0.2; %分类精度
t = 1; %t可以记录查询点的个数
point_query = zeros(num_sample, 2); %查询过的点
answer_query = zeros(num_sample, 1); %查询点的结果
f1_score = zeros(num_sample, 1); %迭代过程中的F1_score
while num_U ~= 0
    U_new = zeros(num_U, 2); %用于迭代时更新未分类集合U
    num_U_new = 0;
    C_new = zeros(num_U, 2); %用于迭代时更新置信区间
    Q_new = zeros(num_U, 2);
    for m = 1 : num_U  %for循环用于分类
        if t == 1
            C(m, :) = [u(m) - beta_sqrt * sigma(m), u(m) + beta_sqrt * sigma(m)];
        else
            Q(m, :) = [u(m) - beta_sqrt * sigma(m), u(m) + beta_sqrt * sigma(m)];
            C(m, :) = Intersection(C(m, :), Q(m, :));
        end
        if C(m, 1) > C(m, 2) %交集不存在
            flag = 1;
            break; 
        end
        if C(m, 1) + acc > h
            num_H = num_H + 1; %归类为上水平集
            H(num_H, :) = U(m, :);
        else if C(m, 2) - acc <= h
                num_L = num_L + 1; %归类为下水平集
                L(num_L, :) = U(m, :);
            else
                num_U_new = num_U_new + 1; %依然无法分类
                U_new(num_U_new, :) = U(m, :);
                C_new(num_U_new, :) = C(m, :);
            end
        end
    end
    if num_U_new == 0
        break;
    end
    U = U_new; %更新未分类点集合
    num_U = num_U_new;
    C = C_new; %更新未分类点的置信区间
    Q = Q_new;
    [point_query(t, :), ~] = SelectPoint(U, num_U, C, h); %寻找下一个查询点
    answer_query(t) = Sinusoidal2D(point_query(t,:)) + sigma_noise * randn(1); %带有观测噪声的观测结果
    [u, sigma] = UpdateGP(t, point_query, answer_query, sigma_noise, U, num_U); %计算所有未分类点的u和segma
    f1_score(t) = F1_score(H, L, num_H, num_L, h, num_sample);
    t = t + 1;
end
%分类结果在H和L中
%画等高线和F1-score
draw_picture(h, L, num_L, f1_score(1 : t - 1), sample_x, sample_y, point_query(1 : t - 1, :));
toc;