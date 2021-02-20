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
close all;
clear all;
N_C=4;
load seizure_samples
load non_seizure_samples

%addpath 'E:\TFSA7\TFSA7\'

cfeatures_vector_S=[];
cfeatures_vector_N=[];

art=0;
%Spike illusstration
        signal=seizure_samples(1,:); 
        signalf=filter([1 -1],1,signal);
        I=HTFD_new1(signalf,3,5,64);
        figure;tfsapl(signalf,I(:,1:4:end),'SampleFreq',32,'Timeplot','on','Freqplot','on','Grayscale','on','TFfontSize', 24 );
        [GD,~,R]= FAST_IF_EEG1(fft(signalf),155, 4, 4,5,0.01,0);
        
        %ST=16;
        ST=8;
        
        [IF,S]=FAST_IF_EEG1(hilbert(signalf),155, 1, 4,5,0,0);
        
        %IF=reshape(IF,[4 64]);
        f=0:16/256:16-1/256;
        t=0:1/32:8-1/32;
        figure;plot(t,32*IF.','linewidth',3);
        xlabel('Time(s)')
        ylabel('Frequency (Hz)')
        set(gca,'Fontsize',20);
        
        axis([0 8 0 16])
        figure;plot(f,256*GD.','linewidth',3);
        xlabel('Frequency (Hz)')
        ylabel('Delay (samples)')
        set(gca,'Fontsize',20);
        
        axis([0 16 0 255])
        % Code to estimate Spectral Centroids%
        IF=IF(:,ST:end);
        GD=GD(:,3*ST:end-1*ST);
        
        mean(std(GD.'))
        mean(std(IF.'))
        
        TFC=min(mean(std(IF.')),mean(std(GD.'))) % Proposed feature
        

        %harmonic illusstration
        signal=seizure_samples(150,:); 
        signalf=filter([1 -1],1,signal);
        I=HTFD_new1(signalf,3,5,64);
        figure;tfsapl(signalf,I(:,1:4:end),'SampleFreq',32,'Timeplot','on','Freqplot','on','Grayscale','on','TFfontSize', 24 );
        [GD,~,R]= FAST_IF_EEG1(fft(signalf),155, 4, 4,5,0.01,0);
        
        %ST=16;
        ST=8;
        
        [IF,S]=FAST_IF_EEG1(hilbert(signalf),155+20, 1, 4,5,0,0);
        
        %IF=reshape(IF,[4 64]);
        f=0:16/256:16-1/256;
        t=0:1/32:8-1/32;
        figure;plot(t,32*IF.','linewidth',3);
        xlabel('Time(s)')
        ylabel('Frequency (Hz)')
        set(gca,'Fontsize',20);
        
        axis([0 8 0 16])
        figure;plot(f,256*GD.','linewidth',3);
        xlabel('Frequency (Hz)')
        ylabel('Delay (samples)')
        set(gca,'Fontsize',20);
        
        axis([0 16 0 255])
        % Code to estimate Spectral Centroids%
        IF=IF(:,ST:end);
        GD=GD(:,3*ST:end-1*ST);
        
        mean(std(GD.'))
        mean(std(IF.'))
        
        TFC=min(mean(std(IF.')),mean(std(GD.'))) % Proposed feature

        
        
        % Illustration of background
        
                signal=non_seizure_samples(1,:); 
        signalf=filter([1 -1],1,signal);
        I=HTFD_new1(signalf,3,5,64);
        figure;tfsapl(signalf,I(:,1:4:end),'SampleFreq',32,'Timeplot','on','Freqplot','on','Grayscale','on');
        [GD,~,R]= FAST_IF_EEG1(fft(signalf),155, 4, 4,5,0.01,0);
        
        %ST=16;
        ST=8;
        
        [IF,S]=FAST_IF_EEG1(hilbert(signalf),155, 1, 4,5,0,0);
        
        %IF=reshape(IF,[4 64]);
        f=0:16/256:16-1/256;
        t=0:1/32:8-1/32;
        figure;plot(t,32*IF.','linewidth',3);
        xlabel('Time(s)')
        ylabel('Frequency (Hz)')
        set(gca,'Fontsize',20);
        
        axis([0 8 0 16])
        figure;plot(f,256*GD.','linewidth',3);
        xlabel('Frequency (Hz)')
        ylabel('Delay (samples)')
        set(gca,'Fontsize',20);
        axis([0 16 0 255])
        % Code to estimate Spectral Centroids%
        IF=IF(:,ST:end);
        GD=GD(:,3*ST:end-1*ST);
        
        mean(std(GD.'))
        mean(std(IF.'))
        
        TFC=min(mean(std(IF.')),mean(std(GD.'))) % Proposed feature

