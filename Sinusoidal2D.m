function sin_result = Sinusoidal2D(point)
%2D���Һ�����������ֵʵ��
x = point(1);
y = point(2);
sin_result = sin(10*x) + cos(4*y) - cos(3*x*y);