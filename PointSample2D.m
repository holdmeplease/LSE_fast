function [x_sample, num_sample] = PointSample2D(x_down, x_up, y_down, y_up, x_num, y_num)
%���룺��������[x_down,x_up]*[y_down,y_up]��ÿ��ά����Ҫ�����ĵ���x_num,y_num
%�����num_sample�ǲ�����������x_sample��һ������Ϊnum_sample�����飬ÿ��Ԫ����һ����(x,y)
num_sample = x_num * y_num;
x_sample = zeros(num_sample, 2);
x_step = (x_up - x_down) / x_num;
y_step = (y_up - y_down) / y_num;
for m = 1 : x_num
   for n = 1 : y_num
      x_sample(n + y_num * (m - 1), :) = [x_down + x_step * m, y_down + y_step * n]; 
   end
end