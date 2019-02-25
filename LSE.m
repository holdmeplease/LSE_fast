%���֡�Active Learning for Level Set Estimation��
%The LSE algorithm
clear;
tic;
%��ʼ��������D
sample_x = 30;
sample_y = 60;
[point_sample, num_sample] = PointSample2D(0,1,0,2,sample_x,sample_y);
%��ʼ������
sigma_noise = exp(-1); %������׼��
H = zeros(num_sample, 2); %��ˮƽ��
num_H = 0; %��ˮƽ���е����
L = zeros(num_sample, 2); %��ˮƽ��
num_L = 0; %��ˮƽ���е����
U = point_sample; %δ����㼯��
num_U = num_sample; %δ��������
u = zeros(num_sample, 1); %��˹��ֵ�ĳ�ֵ
sigma = zeros(num_sample, 1);
for m = 1 : num_U
    sigma(m) = exp(1); %��˹��׼��ĳ�ֵ
end
C = zeros(num_sample, 2); %��������
Q = zeros(num_sample, 2);
h = -0.5; %��ֵ
beta_sqrt = 1.5; %������������ĳ���
acc = 0.2; %���ྫ��
t = 1; %t���Լ�¼��ѯ��ĸ���
point_query = zeros(num_sample, 2); %��ѯ���ĵ�
answer_query = zeros(num_sample, 1); %��ѯ��Ľ��
f1_score = zeros(num_sample, 1); %���������е�F1_score
while num_U ~= 0
    U_new = zeros(num_U, 2); %���ڵ���ʱ����δ���༯��U
    num_U_new = 0;
    C_new = zeros(num_U, 2); %���ڵ���ʱ������������
    Q_new = zeros(num_U, 2);
    for m = 1 : num_U  %forѭ�����ڷ���
        if t == 1
            C(m, :) = [u(m) - beta_sqrt * sigma(m), u(m) + beta_sqrt * sigma(m)];
        else
            Q(m, :) = [u(m) - beta_sqrt * sigma(m), u(m) + beta_sqrt * sigma(m)];
            C(m, :) = Intersection(C(m, :), Q(m, :));
        end
        if C(m, 1) > C(m, 2) %����������
            flag = 1;
            break; 
        end
        if C(m, 1) + acc > h
            num_H = num_H + 1; %����Ϊ��ˮƽ��
            H(num_H, :) = U(m, :);
        else if C(m, 2) - acc <= h
                num_L = num_L + 1; %����Ϊ��ˮƽ��
                L(num_L, :) = U(m, :);
            else
                num_U_new = num_U_new + 1; %��Ȼ�޷�����
                U_new(num_U_new, :) = U(m, :);
                C_new(num_U_new, :) = C(m, :);
            end
        end
    end
    if num_U_new == 0
        break;
    end
    U = U_new; %����δ����㼯��
    num_U = num_U_new;
    C = C_new; %����δ��������������
    Q = Q_new;
    [point_query(t, :), ~] = SelectPoint(U, num_U, C, h); %Ѱ����һ����ѯ��
    answer_query(t) = Sinusoidal2D(point_query(t,:)) + sigma_noise * randn(1); %���й۲������Ĺ۲���
    [u, sigma] = UpdateGP(t, point_query, answer_query, sigma_noise, U, num_U); %��������δ������u��segma
    f1_score(t) = F1_score(H, L, num_H, num_L, h, num_sample);
    t = t + 1;
end
%��������H��L��
%���ȸ��ߺ�F1-score
draw_picture(h, L, num_L, f1_score(1 : t - 1), sample_x, sample_y, point_query(1 : t - 1, :));
toc;