%{
Title       - Activation Envelopes and Joint Angles
Filename    - IntensityPinchGrasp.m
Author      - Brendan P. Beauchamp
Date        - 12/7/2022
Instructor  - Dr. Samhita Rhodes
Description - This program generates time varying activation envelopes for
digits I-V flexion, II-V extension, and I extension, and plots them with
joint angles for MCP and PIP of digit I (thumb), digit II, and an ensemble
average
%}
clear all; close all;

%Load Data Sets
load('KIN_MUS_UJI.mat')
load('RAW_EMG');

%%%%%%%%%%%%%%%%%%%%%%%%% Variable Declarations %%%%%%%%%%%%%%%%%%%%%%%%%%%
  nfft = 64;                            %Window size
%Datasets
  patient = 1;
  ADL_Pinch = 3;
  ADL_Grasp = 14;
%Load EMG Data
  dI_Pinch = (26*(patient-1))+ADL_Pinch;           %Raw Data Index Pinch
  dK_Pinch = (78*(patient-1))+(3*(ADL_Pinch-1))+1; %Angle Data Index Pinch
  dI_Grasp = (26*(patient-1))+ADL_Grasp;           %Raw Data Index Grasp
  dK_Grasp = (78*(patient-1))+(3*(ADL_Grasp-1))+1; %Angle Data Index Grasp
  X_Pinch = RAW_EMG(dI_Pinch).Raw_EMG;             %Raw Data Pinch
  X_Grasp = RAW_EMG(dI_Grasp).Raw_EMG;             %Raw Data Grasp
  X_Pinch = transpose(X_Pinch);
  X_Grasp = transpose(X_Grasp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Experiment Dataset %%%%%%%%%%%%%%%%%%%%%%%%
%EMG Flexion Digits I-V
  x_Pinch = X_Pinch(3,:);
  x_Grasp = X_Grasp(3,:);  
  
%Angles are segmented based on manipulating object, reconstruction below
  %Pinch
    P_Pinch1 = EMG_KIN_v4(dK_Pinch).Kinematic_data;
    P_Pinch1 = transpose(P_Pinch1);
    P_Pinch2 = EMG_KIN_v4(dK_Pinch+1).Kinematic_data;
    P_Pinch2 = transpose(P_Pinch2);
    P_Pinch3 = EMG_KIN_v4(dK_Pinch+2).Kinematic_data;
    P_Pinch3 = transpose(P_Pinch3);
    P_Pinch = [P_Pinch1,P_Pinch2,P_Pinch3];
  %Grasp
    P_Grasp1 = EMG_KIN_v4(dK_Grasp).Kinematic_data;
    P_Grasp1 = transpose(P_Grasp1);
    P_Grasp2 = EMG_KIN_v4(dK_Grasp+1).Kinematic_data;
    P_Grasp2 = transpose(P_Grasp2);
    P_Grasp3 = EMG_KIN_v4(dK_Grasp+2).Kinematic_data;
    P_Grasp3 = transpose(P_Grasp3);
    P_Grasp = [P_Grasp1,P_Grasp2,P_Grasp3];
  
%Reconstruction of time vector for angles
  %Pinch Angles
    t_ang1 = EMG_KIN_v4(dK_Pinch).time; 
    t_ang1 = transpose(t_ang1);
    startIdx_Pinch = length(t_ang1) + 1;
    t_ang2 = EMG_KIN_v4(dK_Pinch+1).time;
    t_ang2 = transpose(t_ang2);
    t_start_Pinch = t_ang2(1);
    t_end_Pinch = t_ang2(length(t_ang2));
    endIdx_Pinch = startIdx_Pinch + length(t_ang2);
    t_ang3 = EMG_KIN_v4(dK_Pinch+2).time;
    t_ang3 = transpose(t_ang3);
    t_ang = [t_ang1,t_ang2,t_ang3];
    
  %Grasp Angles
    t_angG1 = EMG_KIN_v4(dK_Grasp).time; 
    t_angG1 = transpose(t_angG1);
    startIdx_Grasp = length(t_angG1) + 1;
    t_angG2 = EMG_KIN_v4(dK_Grasp+1).time;
    t_angG2 = transpose(t_angG2);
    t_start_Grasp = t_angG2(1);
    t_end_Grasp = t_angG2(length(t_angG2));
    endIdx_Grasp = startIdx_Grasp + length(t_angG2);
    t_angG3 = EMG_KIN_v4(dK_Grasp+2).time;
    t_angG3 = transpose(t_angG3);
    t_angG = [t_angG1,t_angG2,t_angG3];
  
%Raw EMG Time Vector
  t_EMG = RAW_EMG(dI_Pinch).time;
  t_EMG = transpose(t_EMG);
  t_EMGG = RAW_EMG(dI_Grasp).time;
  t_EMGG = transpose(t_EMGG);
  fs = 1000;

%%%%%%%%%%%%%%%%%%%%%%%%%% Finger Joint Angles %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Ensemble Finger Motion
    %Pinch
      %Collect joint angles to ensemble
      ensMCP_Pinch = [P_Pinch(6,:);...
                      P_Pinch(8,:);P_Pinch(11,:);P_Pinch(15,:)];
      ensPIP_Pinch = [P_Pinch(7,:);...
                      P_Pinch(9,:);P_Pinch(12,:);P_Pinch(16,:)];
      %Generate Ensemble Averages
      avEnsMCP_Pinch = ensembleAverage(ensMCP_Pinch);
      avEnsPIP_Pinch = ensembleAverage(ensPIP_Pinch);
    %Grasp
      %Collect joint angles to ensemble
      ensMCP_Grasp = [P_Grasp(6,:);...
                      P_Grasp(8,:);P_Grasp(11,:);P_Grasp(15,:)];
      ensPIP_Grasp = [P_Grasp(7,:);...
                      P_Grasp(9,:);P_Grasp(12,:);P_Grasp(16,:)];
      %Generate Ensemble Averages
      avEnsMCP_Grasp = ensembleAverage(ensMCP_Grasp);
      avEnsPIP_Grasp = ensembleAverage(ensPIP_Grasp);
  %Index Finger Motion -  collect joint angles
    %Pinch
      iMCP_Pinch = P_Pinch(6,:);
      iPIP_Pinch = P_Pinch(7,:); 
    %Grasp
      iMCP_Grasp = P_Grasp(6,:);
      iPIP_Grasp = P_Grasp(7,:); 
  %Thumb Motion
    %Pinch
      tMCP_Pinch = P_Pinch(3,:);
      tPIP_Pinch = P_Pinch(4,:);
      tCMCf_Pinch = P_Pinch(2,:);
      tCMCa_Pinch = P_Pinch(1,:);
    %Grasp
      tMCP_Grasp = P_Grasp(3,:);
      tPIP_Grasp = P_Grasp(4,:);
      tCMCf_Grasp = P_Grasp(2,:);
      tCMCa_Grasp = P_Grasp(1,:);
    
%%%%%%%%%%%%%%%%%%%%%%%%% Generate Activation Window %%%%%%%%%%%%%%%%%%%%%%
%%%Jarque Bou Envelope
%Pinch
    X_jePinch1 = EMG_KIN_v4(dK_Pinch).EMG_data; 
    X_jePinch1 = transpose(X_jePinch1);
    X_jePinch2 = EMG_KIN_v4(dK_Pinch+1).EMG_data;
    X_jePinch2 = transpose(X_jePinch2);
    X_jePinch3 = EMG_KIN_v4(dK_Pinch+2).EMG_data;
    X_jePinch3 = transpose(X_jePinch3);
    X_jePinch = [X_jePinch1,X_jePinch2,X_jePinch3];
%Grasp
    X_jeGrasp1 = EMG_KIN_v4(dK_Grasp).EMG_data; 
    X_jeGrasp1 = transpose(X_jeGrasp1);
    X_jeGrasp2 = EMG_KIN_v4(dK_Grasp+1).EMG_data;
    X_jeGrasp2 = transpose(X_jeGrasp2);
    X_jeGrasp3 = EMG_KIN_v4(dK_Grasp+2).EMG_data;
    X_jeGrasp3 = transpose(X_jeGrasp3);
    X_jeGrasp = [X_jeGrasp1,X_jeGrasp2,X_jeGrasp3];    
  
  %Measure Activation Window for Digits I-V Flexion
    eB_PinchF = X_jePinch(3,:);
    eB_GraspF = X_jeGrasp(3,:);  
    
  %Measure Activation Window for Digits II-V Extension
    eB_PinchE = X_jePinch(5,:);
    eB_GraspE = X_jeGrasp(5,:);  
    
  %Measure Activation Window for Digits I Extension
    eB_PinchT = X_jePinch(4,:);
    eB_GraspT = X_jeGrasp(4,:);    

  
    
%%%%%%%%%%%%%%%%%%%%%%%Plotting%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Figure 2: Joint Angles vs Activation and Median Freq Pinch
  figure('Name','Figure 2: Pinch','NumberTitle','off'); 
  %Ensemble Fingers
    %Finger Flexion/ Extension - Average MCP
     subplot(331); 
       plot(t_ang,avEnsMCP_Pinch);
       hold on
        %Plot Start and End Points
         plot(t_start_Pinch,avEnsMCP_Pinch(startIdx_Pinch),'r*');
         plot(t_end_Pinch,avEnsMCP_Pinch(endIdx_Pinch),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Average MCP');
    %Finger Flexion/ Extension - Average PIP
     subplot(332); 
       plot(t_ang,avEnsPIP_Pinch);
       hold on
        %Plot Start and End Points
         plot(t_start_Pinch,avEnsPIP_Pinch(startIdx_Pinch),'r*');
         plot(t_end_Pinch,avEnsPIP_Pinch(endIdx_Pinch),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Average PIP');
    %Intention Extraction Ensemble Fingers
     subplot(333);
       plot(t_ang,eB_PinchF);
       hold on
        %Plot Start and End Points
         plot(t_start_Pinch,eB_PinchF(startIdx_Pinch),'r*');
         plot(t_end_Pinch,eB_PinchF(endIdx_Pinch),'r*');
        hold off
       xlabel('Time [Sec]'); ylabel('Intensity');
       title('Digits I-V Flexion');
  %Index Finger
    %Index Finger Flexion/ Extension - MCP
     subplot(334); 
       plot(t_ang,iMCP_Pinch);
       hold on
        %Plot Start and End Points
         plot(t_start_Pinch,iMCP_Pinch(startIdx_Pinch),'r*');
         plot(t_end_Pinch,iMCP_Pinch(endIdx_Pinch),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Index Finger MCP');
    %Index Finger Flexion/ Extension - PIP
     subplot(335); 
       plot(t_ang,iPIP_Pinch);
       hold on
        %Plot Start and End Points
         plot(t_start_Pinch,iPIP_Pinch(startIdx_Pinch),'r*');
         plot(t_end_Pinch,iPIP_Pinch(endIdx_Pinch),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Index Finger PIP');
    %Heine Activation
     subplot(336);
       plot(t_ang,eB_PinchE);
       hold on
        %Plot Start and End Points
         plot(t_start_Pinch,eB_PinchE(startIdx_Pinch),'r*');
         plot(t_end_Pinch,eB_PinchE(endIdx_Pinch),'r*');
        hold off
       xlabel('Time [Sec]'); ylabel('Intensity');
       title('Digits II-V Extension');
  %Thumb
    %Thumb Flexion/ Extension - MCP
     subplot(337); 
       plot(t_ang,tMCP_Pinch);
       hold on
        %Plot Start and End Points
         plot(t_start_Pinch,tMCP_Pinch(startIdx_Pinch),'r*');
         plot(t_end_Pinch,tMCP_Pinch(endIdx_Pinch),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Thumb MCP');
    %Thumb Flexion/ Extension - PIP
     subplot(338); 
       plot(t_ang,tPIP_Pinch);
       hold on
        %Plot Start and End Points
         plot(t_start_Pinch,tPIP_Pinch(startIdx_Pinch),'r*');
         plot(t_end_Pinch,tPIP_Pinch(endIdx_Pinch),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Thumb PIP');
    %Median Frequency
     subplot(339);
       plot(t_ang,eB_PinchT);
       hold on
        %Plot Start and End Points
         plot(t_start_Pinch,eB_PinchT(startIdx_Pinch),'r*');
         plot(t_end_Pinch,eB_PinchT(endIdx_Pinch),'r*');
        hold off
    xlabel('Time (sec)'); ylabel('Intensity');
    title('Digit I Extension');

%Figure 3: Joint Angles vs Activation and Median Freq Grasp
figure('Name','Figure 3: Grasp','NumberTitle','off'); 
  %Ensemble Fingers
    %Finger Flexion/ Extension - Average MCP
     subplot(331); 
       plot(t_angG,avEnsMCP_Grasp);
       hold on
        %Plot Start and End Points
         plot(t_start_Grasp,avEnsMCP_Grasp(startIdx_Grasp),'r*');
         plot(t_end_Grasp,avEnsMCP_Grasp(endIdx_Grasp),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Average MCP');
    %Finger Flexion/ Extension - Average PIP
     subplot(332); 
       plot(t_angG,avEnsPIP_Grasp);
       hold on
        %Plot Start and End Points
         plot(t_start_Grasp,avEnsPIP_Grasp(startIdx_Grasp),'r*');
         plot(t_end_Grasp,avEnsPIP_Grasp(endIdx_Grasp),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Average PIP');
    %Intention Extraction Ensemble Fingers
     subplot(333);
       plot(t_angG,eB_GraspF);
       hold on
        %Plot Start and End Points
         plot(t_start_Grasp,eB_GraspF(startIdx_Grasp),'r*');
         plot(t_end_Grasp,eB_GraspF(endIdx_Grasp),'r*');
        hold off
       xlabel('Time [Sec]'); ylabel('Intensity');
       title('Digits I-V Flexion');
  %Index Finger
    %Index Finger Flexion/ Extension - MCP
     subplot(334); 
       plot(t_angG,iMCP_Grasp);
       hold on
        %Plot Start and End Points
         plot(t_start_Grasp,iMCP_Grasp(startIdx_Grasp),'r*');
         plot(t_end_Grasp,iMCP_Grasp(endIdx_Grasp),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Index Finger MCP');
    %Index Finger Flexion/ Extension - PIP
     subplot(335); 
       plot(t_angG,iPIP_Grasp);
       hold on
        %Plot Start and End Points
         plot(t_start_Grasp,iPIP_Grasp(startIdx_Grasp),'r*');
         plot(t_end_Grasp,iPIP_Grasp(endIdx_Grasp),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Index Finger PIP');
    %Heine Activation
     subplot(336);
       plot(t_angG,eB_GraspE);
       hold on
        %Plot Start and End Points
         plot(t_start_Grasp,eB_GraspE(startIdx_Grasp),'r*');
         plot(t_end_Grasp,eB_GraspE(endIdx_Grasp),'r*');
        hold off
       xlabel('Time [Sec]'); ylabel('Intensity');
       title('Digits II-V Extension');
  %Thumb
    %Thumb Flexion/ Extension - MCP
     subplot(337); 
       plot(t_angG,tMCP_Grasp);
       hold on
        %Plot Start and End Points
         plot(t_start_Grasp,tMCP_Grasp(startIdx_Grasp),'r*');
         plot(t_end_Grasp,tMCP_Grasp(endIdx_Grasp),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Thumb MCP');
    %Thumb Flexion/ Extension - PIP
     subplot(338); 
       plot(t_angG,tPIP_Grasp);
       hold on
        %Plot Start and End Points
         plot(t_start_Grasp,tPIP_Grasp(startIdx_Grasp),'r*');
         plot(t_end_Grasp,tPIP_Grasp(endIdx_Grasp),'r*');
        hold off
      xlabel('Time [Sec]'); ylabel('Angle');
      title('Thumb PIP');
    %Median Frequency
     subplot(339);
       plot(t_angG,eB_GraspT);
       hold on
        %Plot Start and End Points
         plot(t_start_Grasp,eB_GraspT(startIdx_Grasp),'r*');
         plot(t_end_Grasp,eB_GraspT(endIdx_Grasp),'r*');
        hold off
    xlabel('Time [Sec]'); ylabel('Intensity');
    title('Digit I Extension');