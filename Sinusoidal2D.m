function sin_result = Sinusoidal2D(point)
%2D正弦函数，用于数值实验
x = point(1);
y = point(2);
sin_result = sin(10*x) + cos(4*y) - cos(3*x*y);