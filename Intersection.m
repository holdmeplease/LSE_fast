function Intersect_result = Intersection(interval_1, interval_2)
%���룺��������
%�������������Ľ���
Intersect_result = [max(interval_1(1), interval_2(1)), min(interval_1(2), interval_2(2))];