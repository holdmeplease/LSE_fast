function [x_sample, num_sample] = PointSample2D(x_down, x_up, y_down, y_up, x_num, y_num)
%输入：矩形区域[x_down,x_up]*[y_down,y_up]和每个维度需要采样的点数x_num,y_num
%输出：num_sample是采样点总数，x_sample是一个长度为num_sample的数组，每个元素是一个点(x,y)
num_sample = x_num * y_num;
x_sample = zeros(num_sample, 2);
x_step = (x_up - x_down) / x_num;
y_step = (y_up - y_down) / y_num;
for m = 1 : x_num
   for n = 1 : y_num
      x_sample(n + y_num * (m - 1), :) = [x_down + x_step * m, y_down + y_step * n]; 
   end
end