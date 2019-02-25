function [point_next, point_idx] = SelectPoint(U, num_U, C, h)
%寻找下一个查询点
%寻找目标是使得ambiguity最大
point_next = U(1, :);
point_idx = 1;
a0 = min(C(1, 2) - h, h - C(1, 1));
for m = 2 : num_U
    a = min(C(m, 2) - h, h - C(m, 1));
    if a > a0
       point_next = U(m, :);
       point_idx = m;
       a0 = a;
    end
end