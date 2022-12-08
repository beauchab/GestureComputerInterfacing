%{
Title       - Fingertip Workspace Coherence
Filename    - FWCoherence.m
Author      - Brendan P. Beauchamp
Date        - 12/7/2022
Instructor  - Dr. Samhita Rhodes
Description - This script compares coherence spectra of digits I-V flexion
and digits II-V extension with their respective power spectra, activation 
envelopes and joint angles in order to discern changes in the fingertip
workspace.
%}
clear all; close all;

%Load Datasets
  load('KIN_MUS_UJI.mat')
  load('RAW_EMG');

%%%%%%%%%%%%%%%%%%%%%%%%% Variable Declarations %%%%%%%%%%%%%%%%%%%%%%%%%%%
  nfft = 512;
  noverlap = 0.5*nfft;      % Number of overlapping points(50%)
  MAX_FREQ = 65;            % Maximum Plotted Frequency
  subject = 1;              % Subject Number
  ADL = 14;                 % Activity of Daily Living
  dI = (26*(subject-1))+ADL;            %Data Index for Raw Data    
  dK = (78*(subject-1))+(3*(ADL-1))+1;  %Data Index for angle data

  X = RAW_EMG(dI).Raw_EMG;             %Raw Data
  X = transpose(X);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Experiment Dataset %%%%%%%%%%%%%%%%%%%%%%%%
%sEMG Flexion Digits I-V
  x_F = X(3,:);
%sEMG Extension Digits II-V
  x_eE = X(5,:);  
%sEMG Extension Digit I
  x_tE = X(4,:);  
%%%Jarque Bou Envelope Concatenation
    X_je1 = EMG_KIN_v4(dK).EMG_data; 
    X_je1 = transpose(X_je1);
    X_je2 = EMG_KIN_v4(dK+1).EMG_data;
    X_je2 = transpose(X_je2);
    X_je3 = EMG_KIN_v4(dK+2).EMG_data;
    X_je3 = transpose(X_je3);
    X_je = [X_je1,X_je2,X_je3];
   
%Time Concatenatioon
  t_ang1 = EMG_KIN_v4(dK).time; 
  t_ang1 = transpose(t_ang1);
  startIdx = length(t_ang1) + 1;
  t_ang2 = EMG_KIN_v4(dK+1).time;
  t_ang2 = transpose(t_ang2);
  t_start = t_ang2(1);              %Start time for object manipulation
  t_end = t_ang2(length(t_ang2));   %End time for object manipulation
  endIdx = startIdx + length(t_ang2);
  t_ang3 = EMG_KIN_v4(dK+2).time;
  t_ang3 = transpose(t_ang3);
  t_ang = [t_ang1,t_ang2,t_ang3];   %Concatenate Time Vector
     
  t_EMG = RAW_EMG(dI).time;
  t_EMG = transpose(t_EMG);
  fs = 1000;

   
%%%%%%%%%%%%%%%%%%%%%%%%% Generate Activation Window %%%%%%%%%%%%%%%%%%%%%% 
  %Digits I-V Flexion
    e_F = X_je(3,:);
  %Digits II-V Extension
    e_eE = X_je(5,:);  
  %Digit I Extension
    e_tE = X_je(4,:);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Joint Angles %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Concatenate Joint Angle  Dataa
    P1 = EMG_KIN_v4(dK).Kinematic_data;
    P1 = transpose(P1);
    P2 = EMG_KIN_v4(dK+1).Kinematic_data;
    P2 = transpose(P2);
    P3 = EMG_KIN_v4(dK+2).Kinematic_data;
    P3 = transpose(P3);
    P = [P1,P2,P3];
  %Ensemble Finger MCP
    ensMCP = [P(6,:);P(8,:);P(11,:);P(15,:)];
    avEnsMCP = ensembleAverage(ensMCP);
  %Thumb MCP
    tMCP = P(3,:);
    
%%%%%%%%%%%%%%%%%%%%%%%%% Spectrum Analyzer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Digits I-V Flexion
 [sx_F,fx_F,tx_F] = spectrogram(x_F,hamming(nfft),noverlap,nfft,fs);
 sx_F = abs(sx_F);
 sx_F = sx_F.^2;
 sx_F = sx_F./max(sx_F);
 
% Digits II-V Extension
 [sx_eE,fx_eE,tx_eE] = spectrogram(x_eE,hamming(nfft),noverlap,nfft,fs);
 sx_eE = abs(sx_eE);
 sx_eE = sx_eE.^2;
 sx_eE = sx_eE./max(sx_eE);
  
%%%%%%%%%%%%%%%%%%%%% Compute MSC for MFC 50% overlap %%%%%%%%%%%%%%%%%%%%%
%Flexion vs Digits II-V Extension
  [msc_FeE,  t_FeE, f_FeE] = MSC(x_F', x_eE', nfft, nfft/2, fs);
  
%%%%%%%%%%%%%%%%%%%%%%%Plotting%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %Figure: Coherence Between Fingertip Workspace Flexors and Extensors
  figure('Name','Fingertip Workspace Coherence','NumberTitle','off'); 
  %Ensemble Fingers
    %Finger Flexion/ Extension - Average MCP
     subplot(3,3,[1 2]); 
       imagesc(tx_F,fx_F,sx_F);
       hold on
         line([t_start,t_start], [0 MAX_FREQ], 'Color', 'r');
         line([t_end,t_end], [0 MAX_FREQ], 'Color', 'r');
       hold off
       colorbar;
       ylim([0 MAX_FREQ]);
       xlabel('Time (sec)'); ylabel('Frequency (Hz)');
       title('Power Spectra I-V Flexion');
       grid on
    %Intention Extraction Ensemble Fingers
     subplot(333);
       plot(t_ang,e_F);
       hold on
        %Plot Start and End Points
         plot(t_start,e_F(startIdx),'r*');
         plot(t_end,e_F(endIdx),'r*');
        hold off
       xlabel('Time [Sec]'); ylabel('Intensity');
       title('Digits I-V Flexion');
       
       
    %Coherence between I-V Flexion and II-V Extension
     subplot(3,3,[4,5]);
       imagesc(tx_eE,fx_eE,sx_eE);
       hold on
         line([t_start,t_start], [0 MAX_FREQ], 'Color', 'r');
         line([t_end,t_end], [0 MAX_FREQ], 'Color', 'r');
       hold off
       colorbar;
       ylim([0 MAX_FREQ]);
       xlabel('Time (sec)'); ylabel('Frequency (Hz)');
       title('Power Spectra II-V Extension');
       grid on
     %Intensity Digits II-V Extension
     subplot(336);   
       plot(t_ang,e_eE);
       hold on
        %Plot Start and End Points
         plot(t_start,e_eE(startIdx),'r*');
         plot(t_end,e_eE(endIdx),'r*');
        hold off
       xlabel('Time [Sec]'); ylabel('Intensity');
       title('Digits II-V Extension');
     %Coherence between I-V Flexion and II-V Extension
     subplot(3,3,[7,8]);
      imagesc(t_FeE,f_FeE,abs(msc_FeE));
       hold on
         line([t_start,t_start], [0 MAX_FREQ], 'Color', 'r');
         line([t_end,t_end], [0 MAX_FREQ], 'Color', 'r');
       hold off
       colorbar;
       ylim([0 MAX_FREQ]);
       xlabel('Time (sec)'); ylabel('Frequency (Hz)');
       title('I-V Flexion and II-V Extension Coherence');
       grid on
    subplot(339)
    %Finger Flexion/ Extension - Average MCP
       plot(t_ang,avEnsMCP);
       hold on
        %Plot Start and End Points
         plot(t_start,avEnsMCP(startIdx),'r*');
         plot(t_end,avEnsMCP(endIdx),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Average MCP');
       