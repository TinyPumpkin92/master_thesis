function [con_matrix] = computeConfusionMatrix3D(seg, gt)
% Computes the confusion matrix for a 3D segmentation and its ground truth.
% Matrix is given as [TP, FP; FN, TN]. Inputs should be binary images or
% logicals.
    
TP = sum(sum(sum(seg & gt)));
FP = sum(sum(sum(seg & (~gt))));
TN = sum(sum(sum((~seg) & (~gt))));
FN = sum(sum(sum((~seg) & gt)));
con_matrix = [TP, FP; FN, TN];

end