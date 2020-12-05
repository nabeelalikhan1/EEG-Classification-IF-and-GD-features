function [Sen,Spe] = roc_rates_function(method_out,ref_mask,N_thresh)
% method_out (N_seg x 1)       : Output vector of the method (maximum values over templates)
% ref_mask (1 x N_seg)         : Reference seiz/nonseiz binary mask
% N_thresh (integer)           : Number of thresholding levels for the ROC plot

%% Compute True Positive and False Negative rates
thresh = linspace(min(method_out),max((method_out)),N_thresh);   % thresholds for computing the ROC curve

TP = zeros(1,N_thresh);
FN = zeros(1,N_thresh);
TN = zeros(1,N_thresh);
FP = zeros(1,N_thresh);
Sen = zeros(1,N_thresh);
Spe = zeros(1,N_thresh);

for i = 1 : N_thresh

    thresh_i = thresh(i);

    %%% Decision making process based on a pre-defined incidence matrix
    mask_i = method_out<=thresh_i;             % (N_seg x 1) If the seizure is observed completely in at least one region of adjacent channels
    
    TP(i) = sum(ref_mask.*mask_i');                   % True Positive Rate for method 1
    FP(i) = sum((1-ref_mask).*mask_i');               % False Positive Rate for method 1
    TN(i) = sum((1-ref_mask).*(1-mask_i)');           % True Negative Rate for method 1
    FN(i) = sum(ref_mask.*(1-mask_i)');               % False Negative Rate
    Sen(i) = TP(i)/(TP(i)+FN(i));                     % Sensitivity
    Spe(i) = TN(i)/(TN(i)+FP(i));                     % Specificity

end