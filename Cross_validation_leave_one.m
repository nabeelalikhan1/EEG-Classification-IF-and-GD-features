function [c,Group_svm]=Cross_validation_leave_one(N,S,art)

%-------------------------------------------------------------------------
% EEG Classification using SVM classifier
%
% input:
%   N --> EEG data (non-seizure segments)
%   S --> EEG data (seizure segments)
% output:
%   Display the following statistical parameters
%       1) Total classification accuracy
%       2) Sensitivity
%       3) Specificity
%
% By Dr. Larbi Boubchir (larbi@qu.edu.qa;larbi.boubchir@gmail.com)
% October 3, 2012.
%-------------------------------------------------------------------------

labels = {'seizure','normal'};
groups = labels([ones(1,length(N)) 2*ones(1,length(N))]);
% N=N(end:-1:1,:);
% S=S(end:-1:1,:);
options = statset('maxiter',100000);
c=0;
for i=1:length(N)
    train=zeros(1,length(N));
    test=train;
    
    
    test(i) = 1;
    train = ~test;
 rng(1);   
    Training = [N(train,1:end);S(train,1:end)];
    Group     = [ones(sum(train),1);2*ones(sum(train),1)];
    if art==0
        C = svmtrain(Training,Group );%,'kernel_function','linear','method','SMO','SMO_opts',options);
    %         C=fitcsvm(Training,Group);

    elseif art==1
%                SVMStruct = svmtrain(Training,Group ,'kernel_function','polynomial','method','SMO','SMO_opts',options);

        C = svmtrain(Training,Group ,'kernel_function','rbf');%,'boxconstraint',0.01,'rbf_sigma',100);
%                C=fitcsvm(Training,Group,'boxconstraint',1,'Standardize',true,'KernelFunction','RBF');

    elseif art==2
            C=TreeBagger(1,Training,Group);

    end
    %TREE=fitctree(Training,Group) ;
    % size(test)
 %       TREE=TreeBagger(100,Training,Group);

    N_test    = [N(~train,1:end)];
    
    S_test    = [S(~train,1:end)];
    
    %Group_svm(:,1) = svmclassify(SVMStruct,N_test);
    %Group_svm(:,2) = svmclassify(SVMStruct,S_test);
    
    
    
    if art==2
        Group_svm(:,1) = predict(C,N_test);
    Group_svm(:,2) = predict(C,S_test);
    c=c+display_results(str2double(Group_svm));
    else
         Group_svm(:,1) = svmclassify(C,N_test);
    Group_svm(:,2) = svmclassify(C,S_test);
  %  Group_svm(:,1) = predict(C,N_test);
   % Group_svm(:,2) = predict(C,S_test);

    c=c+display_results((Group_svm));    
    end
    
    
    %Group_svm(:,1) = predict(C,N_test);
    %Group_svm(:,2) = predict(C,S_test);

    
   % c=c+display_results((Group_svm));
%    c=c+display_results((Group_svm));
end
c=c/(length(N));



    function TotatAccuracy=display_results(R)
        % Display the classification rtesults
        [NN,M]=size(R);
        
        Sensitivity   = 100*sum(R(:,1)==1)/NN;
        Specificity   = 100*sum(R(:,2)==2)/NN;
        %fprintf('Class N: \t %d \t %d \t Sensitivity %.2f \t Specificity %.2f \n',...
        %   sum(R(:,1)==1),sum(R(:,1)==2),Sensitivity,Specificity)
        
        Sensitivity   = 100*sum(R(:,2)==2)/NN;
        Specificity   = 100*sum(R(:,1)==1)/NN;
        %fprintf('Class S: \t %d \t %d \t Sensitivity %.2f \t Specificity %.2f \n',...
        %   sum(R(:,2)==1),sum(R(:,2)==2),Sensitivity,Specificity)
        
        TotatAccuracy = 100*(sum(R(:,1)==1)+sum(R(:,2)==2))/(2*NN);
        TotatAccuracy=[TotatAccuracy Sensitivity Specificity];
        %fprintf('TotatAccuracy:  %.2f \n',TotatAccuracy)
        
    end
end