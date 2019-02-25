function F1score = F1_score(H, L, num_H, num_L, h, num_sample)
%������ˮƽ����F1-score
TP = 0; %Ԥ����ȷ 
FP = 0; %��������Ԥ��Ϊ����
FN = num_sample - num_H - num_L; %������Ԥ��Ϊ������
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
    pre = TP / (TP + FP); %��ȷ��
    recall = TP / (TP + FN); %�ٻ���
    F1score = 2 * pre * recall / (pre + recall);
end
