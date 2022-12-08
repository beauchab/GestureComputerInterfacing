%{
Title       - Maximum Intensity ADL
Filename    - MaximumIntensityADL.m
Author      - Brendan P. Beauchamp
Date        - 11/30/2022
Instructor  - Dr. Samhita Rhodes
Description - This program generates a box and whisker plot for each ADL in
order to quantify hand motion
%}
clear all; close all;

%Load Datasets
  load('KIN_MUS_UJI.mat')
  load('RAW_EMG');

%%%%%%%%%%%%%%%%%%%%%%%%% Variable Declarations %%%%%%%%%%%%%%%%%%%%%%%%%%%
  nfft = 64;                            %Window size
  eMax = zeros(20,26);                  %Max Intensity Vector
  bMax = zeros(20,26);                  %Max Intensity Vector
 
  %Loop through all ADL for each subject
  for subject = 1:20    %Iterate each subject
  for ADL = 1:26        %Iterate through Each ADL in the Dataset
   
  %Generate Data Index for Raw Data
  dI = (26*(subject-1))+ADL;
  %Generate Data Index for Kinematic Data
  dK = (78*(subject-1))+(3*(ADL-1))+1;

  X = RAW_EMG(dI).Raw_EMG;             %Raw Data
  X = transpose(X);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Experiment Dataset %%%%%%%%%%%%%%%%%%%%%%%%
%EMG Flexion Digits I-V
  x = X(3,:);
  
%%%Jarque Bou Envelope Concatenation
    X_je1 = EMG_KIN_v4(dK).EMG_data; 
    X_je1 = transpose(X_je1);
    X_je2 = EMG_KIN_v4(dK+1).EMG_data;
    X_je2 = transpose(X_je2);
    X_je3 = EMG_KIN_v4(dK+2).EMG_data;
    X_je3 = transpose(X_je3);
    X_je = [X_je1,X_je2,X_je3];
   
%Time
  % Angles
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
  %Measure Activation Window for Digits I-V Flexion
    eB = X_je(3,:);
    
%%% Heine Envelope
  %Generate Filter
    [b,a] = tf(HeineFilter);

  %Rectify Signal
    x_R = abs(x);

  %Filter Signal
      eH = filter(b,a,x_R);
  
  % Sum the entire envelope
  inte = TrapSolve(eH,t_EMG,1,length(eH));
      
  eMax(subject,ADL) = max(inte);      %Calculate Max Intensity
  bMax(subject,ADL) = max(eB);      %Calculate Max Intensity
  end 
  end
 
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %aveMax = ensembleAverage(eMax);

  %ADL_ax = 1:26; 
  
%Figure 4: ADL vs Average Flexor Intensity
figure('Name','Average Flexor Intensity','NumberTitle','off'); 
      %stem(ADL_ax,aveMax);
      boxchart(eMax)
      xlabel('ADL'); ylabel('Intensity');
      title('Average Flexor Intensity');
      grid on;
      
%Figure 4: ADL vs Average Flexor Intensity
figure('Name','Average Flexor Intensity Bou','NumberTitle','off'); 
      %stem(ADL_ax,aveMax);
      boxchart(bMax)
      xlabel('ADL'); ylabel('Intensity');
      title('Average Flexor Intensity Bou');
      grid on;
      
      
     pgDat = [eMax(:,1),eMax(:,3),eMax(:,6),eMax(:,14)] ;
     
     %Figure 4: ADL vs Average Flexor Intensity
figure('Name','Average Flexor Intensity Bou','NumberTitle','off'); 
      %stem(ADL_ax,aveMax);
      boxchart(pgDat)
      xlabel('ADL'); ylabel('Intensity');
      title('Average Flexor Intensity Bou');
      grid on;
      