function F1score = F1_score(H, L, num_H, num_L, h, num_sample)
%计算上水平集的F1-score
TP = 0; %预测正确 
FP = 0; %错将其他类预测为本类
FN = num_sample - num_H - num_L; %将本类预测为其他类
for m = 1 : num_H
    if Sinusoidal2D(H(m, :)) > h
       TP = TP + 1;
    else
        FP = FP + 1;
    end
end
for m = 1 : num_L
   if Sinusoidal2D(L(m, :)) > h
      FN = FN + 1; 
   end
end
if TP + FP == 0 || TP + FN == 0
    F1score = 0;
else
    pre = TP / (TP + FP); %精确度
    recall = TP / (TP + FN); %召回率
    F1score = 2 * pre * recall / (pre + recall);
end
