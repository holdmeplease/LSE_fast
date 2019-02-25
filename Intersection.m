function Intersect_result = Intersection(interval_1, interval_2)
%输入：两个区间
%输出：两个区间的交集
Intersect_result = [max(interval_1(1), interval_2(1)), min(interval_1(2), interval_2(2))];