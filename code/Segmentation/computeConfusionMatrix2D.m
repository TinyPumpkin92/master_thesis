function [con_matrix] = computeConfusionMatrix2D(seg, gt)
% Computes the confusion matrix for a 2D segmentation and its ground truth.
% Matrix is given as [TP, FP; FN, TN]. Inputs should be binary images or
% logicals.
    
TP = sum(sum(seg & gt));
FP = sum(sum(seg & (~gt)));
TN = sum(sum((~seg) & (~gt)));
FN = sum(sum((~seg) & gt));
con_matrix = [TP, FP; FN, TN];

end