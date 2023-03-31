%{
Title       - MedFreqADL
Filename    - Median Frequency During ADL
Author      - Brendan P. Beauchamp
Date        - 12/7/2022
Instructor  - Dr. Samhita Rhodes
Description - This program calculates the median frequency for a desired
signal from the Jarque Bou Dataset. It will then place a linear regression
over the timespan when the subject was manipulating the object.
%}
clear all; close all;

%Load Datasets
  load('KIN_MUS_UJI.mat')
  load('RAW_EMG');

%%%%%%%%%%%%%%%%%%%%%%%%% Variable Declarations %%%%%%%%%%%%%%%%%%%%%%%%%%%
 nfft = 64;                            %Window size
  subject = 14;                          %Subject
  ADL = 14;                             %ADL
  dI = (26*(subject-1))+ADL;            %Raw Data Index
  dK = (78*(subject-1))+(3*(ADL-1))+1;  %Kinematic Data Index
  X = RAW_EMG(dI).Raw_EMG;             %Raw Data
  X = transpose(X);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Experiment Dataset %%%%%%%%%%%%%%%%%%%%%%%%
  %EMG Flexion Digits I-V
  x = X(3,:);
  
  %Angles are Seperated into Pre, During, Post Manipulation
    P1 = EMG_KIN_v4(dK).Kinematic_data;         %Pre
    P1 = transpose(P1);
    P2 = EMG_KIN_v4(dK+1).Kinematic_data;       %During
    P2 = transpose(P2);
    P3 = EMG_KIN_v4(dK+2).Kinematic_data;        %Post
    P3 = transpose(P3);
    P = [P1,P2,P3];                              %Concatenate Angle Data
    
%Time
  %Time for Joint Angles is segmented into pre, during, post manipulation
    t_ang1 = EMG_KIN_v4(dK).time;                %Pre
    t_ang1 = transpose(t_ang1);
    t_ang2 = EMG_KIN_v4(dK+1).time;              %During
    t_ang2 = transpose(t_ang2); 
    t_start = t_ang2(1);                         %Start of the regression
    t_end = t_ang2(length(t_ang2));              %End of the regression
    t_ang3 = EMG_KIN_v4(dK+2).time;              %Post
    t_ang3 = transpose(t_ang3);
    t_ang = [t_ang1,t_ang2,t_ang3];              %Concatenate time vector
    
  %EMG
    t_EMG = RAW_EMG(dI).time;
    t_EMG = transpose(t_EMG);
    fs = 1000;
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%% Finger Joint Angles %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Ensemble Finger Motion
    %MCP is the largest determinant of finger flexion because the FDS
      ensMCP = [P(6,:);P(8,:);P(11,:);P(15,:)];
      avEnsMCP = ensembleAverage(ensMCP);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Median Frequency %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segment Vector
  x_seg = x((t_start*fs):(t_end*fs));
%Calculate Median Frequency Vector
  [mf, tm] = mFVecLib(x_seg, nfft, fs);  
  [mfx, tmx] = mFVecLib(x, nfft, fs);
  
  %Indexes for Touching the Object
  y_start = mf(1);
  y_end = mf(length(mf));
  
%Line of Best Fit
  [p,S] = polyfit(tm,mf,1); 
  [yF,delta] = polyval(p,tm,S);
  tm = tm + t_start;  
  
%%%%%%%%%%%%%%%%%%%%%%% Mean Frequency %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate Mean Frequency Vector
[meanfreq, meanfreqtm] = meanFVecLib(x_seg, nfft, fs);
[meanfreqx, meanfreqtmx] = meanFVecLib(x, nfft, fs);

%Indexes for Touching the Object
y_start_mean = meanfreq(1);
y_end_mean = meanfreq(length(meanfreq));

%Line of Best Fit
[p2,S2] = polyfit(meanfreqtm,meanfreq,1);
[yF2,delta2] = polyval(p2,meanfreqtm,S2);
meanfreqtm = meanfreqtm + t_start;  

%%%%%%%%%%%%%%%%%%%%%%% Compression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = meanfreqx./mfx;
  
%%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Normalize all time axes
%tScalar = max(t_EMG);
%tm = tScalar*(tm./max(tm));


%Figure X: Joint Angles vs Median Freq
figure('Name','Figure 2: Pinch','NumberTitle','off');
%{
%Finger Flexion/ Extension - Average MCP
subplot(141);
plot(t_ang,avEnsMCP);
xlabel('Time [Sec]'); ylabel('Angle');
title('Average MCP');
grid on;
%}
%Median Frequency
subplot(3,1,1);
plot(tmx,mfx,'bo')
hold on
plot(tm,yF,'r-')
plot(tm,yF+2*delta,...
'm--',tm,yF-2*delta,'m--', 'linewidth', 2);
title('Median Frequency while Touching Object')
legend('Data',...
sprintf("Linear Fit: %.2f x + %.2f", p(1), p(2)),...
'95% Prediction Interval')
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
grid on;
%Mean Frequency
 subplot(3,1,2);
   plot(meanfreqtmx,meanfreqx,'bo')
    hold on       
    plot(meanfreqtm,yF2,'r-')
    plot(meanfreqtm,yF2+2*delta2,...
        'm--',meanfreqtm,yF2-2*delta2,'m--', 'linewidth', 2)
title('Mean Frequency while Touching Object')
legend('Data',...
    sprintf("Linear Fit: %.2f x + %.2f", p2(1), p2(2)),...
    '95% Prediction Interval')
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
grid on;
subplot(3,1,3);
plot(tmx,r,'bo')
title('MNF/MDF')
xlabel('Time (sec)'); ylabel('Hz/Hz');
grid on;