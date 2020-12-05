%--------------------------------------------------------------------------
% Newborn EEG classification
%
% input:    Newborn EEG data
% output:   Display the classification results
%
% By Dr. Nabeel Ali Khan
%--------------------------------------------------------------------------

%%-------------------------------------------------------------------------
%% Newborn EEG Database
%%
%% The N.mat (S.mat) file contains 50 non-seizure (seizure) segments.
%% The segments have been inspected visually and picked.
%% The EEG segments have been band-pass ?ltered in the range 0.5 to 10 Hz
%% and down-sampled from 256 Hz to 20 Hz.
%%-------------------------------------------------------------------------

clear all;
N_C=4;
load seizure_samples
load non_seizure_samples

nS=200;
%addpath 'E:\TFSA7\TFSA7\'

cfeatures_vector_S=[];
cfeatures_vector_N=[];

art=0;
for j=1:1:nS
    for class=1:2
        
        %%--------------------------------------------
        %% Time-frequency signal representation
        %%--------------------------------------------
        if class==1 signal=seizure_samples(j,:); end
        if class==2 signal=non_seizure_samples(j,:); end
        
        signalf=filter([1 -1],1,signal);
        
        [IF,~,R]= FAST_IF_EEG1(fft(signalf),155, 4, 4,5,0.01,0);
        
        %ST=16;
        ST=8;
        IF=IF(:,ST:end);
        
        [GD,S]=FAST_IF_EEG1(hilbert(signalf),155, 1, 4,5,0,0);
        
        GD=GD(:,3*ST:end-1*ST);
        %IF=reshape(IF,[4 64]);
        
        % Code to estimate Spectral Centroids%
        signal_freq=abs(fft(hilbert(signal)));
        signal_freq=signal_freq(1:128);
        mean_freq=sum(signal_freq.*(0:127))/sum(signal_freq); %Spectral Centroid
        mean_freq1=sum(signal_freq(1:round(mean_freq)).*(0:round(mean_freq)-1))/sum(signal_freq(1:round(mean_freq)));
        mean_freq2=sum(signal_freq(1:round(mean_freq1)).*(0:round(mean_freq1)-1))/sum(signal_freq(1:round(mean_freq1)));
        
        % Code to estimate Spectral Flatness%
        signal_freq(signal_freq==0)=eps;
        SF=prod(abs(signal_freq).^(1/256))/sum(abs(signal_freq));
        [a,~]=size(GD);
        S=real(S(1,:));
        
        TFC(1)=min(mean(std(IF.')),mean(std(GD.'))); % Proposed feature
        
        TFC(2)=entropy(signal);
        TFC(3)=mean_freq; % Spectral Centroid
        TFC(4)=mean(abs(diff(sign(signalf))));  %Zero crossing rate
        TFC(5)=iqr(signalf) ; % Inter Quartile Range
        TFC(6)=mean_freq1; % Spectral Centroid 1
        TFC(7)=mean_freq2; %Spectral centroid 2
        TFC(8)=SF; % Spectral FLux
        
        
        %% feature extraction
        
        if class==1
           
            features_vector_S(j,:)=  TFC;
        else
            features_vector_N(j,:)=  TFC;
            
        end
    end
end




F=[features_vector_S;features_vector_N];

mask=[zeros(1,nS) ones(1,nS)];
for k = 1:size(F,2)
    N_thresh = 100000; % Number of the thresholding levels
    [Sen,Spe] = roc_rates_function(F(:,k),mask,N_thresh);
    auc(k) = trapz(1-Spe,Sen);
    
    if auc(k)<0.5
        auc(k) = 1 - auc(k);
    else
    end
end
auc(1)
Cross_validation_leave_one(features_vector_N,features_vector_S,1)

%save('Seizure_samples','Seizure_samples');
%save('Back_samples','Back_samples');
