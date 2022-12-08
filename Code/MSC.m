%{
Function     - [msc, t, f] = MSC(x, y, nfft, noverlap, fs)
Filename     - MSC.m
Description  - This function calculates the time frequency magnitude 
               squared coherence between two signals x and y
Author       - Brendan P. Beauchamp
Date         - 11/12/2021
Instructor   - Dr. Samhita Rhodes
@param       - x
                Input signal x to the MSC
@param       - y
                Input signal y to the MSC
@param       - nfft
                Size of the windows for x and y
@param       - noverlap
                Amount of overlap between windows
@param       - fs
                Sampling frequency of both datasets x and y
@return      - msc
                The magnitude squared coherence matrix for input signals
                x and y.
@return      - t
                Time vector for the MSC matrix (columns)
@return      - f
                Frequency vector for MSC matrix (rows)
%}
function [msc, t, f] = MSC(x, y, nfft, noverlap, fs)
 
  incr = nfft - noverlap;                %Calculate window increment
  hwin = fix(nfft/2);                    %Half window size
  col = floor(length(x)/incr);
  
 % disp((length(x)-1)/incr);
  
  %Initialize Vectors
  spX = zeros(hwin,col);
  spY = zeros(hwin,col);
  msc = zeros(hwin, col);
  Sxx = zeros(hwin, col);
  Syy = zeros(hwin, col);
  Sxy = zeros(hwin, col);
 
  f = (1:hwin) * (fs/nfft);           %Calculate frequency vector
 
  %Zero pad data array to handle edge effects
    x_mod = [zeros(hwin,1); x; zeros(hwin,1)];
    y_mod = [zeros(hwin,1); y; zeros(hwin,1)];
 
%DPSS FUNCTION
  [dps_seq,~] = dpss(nfft,2.5,7);
 
%Calculate spectra for each window position
for k = 1:7
    window = dps_seq(:,k);   
    j = 1;
  for i = 1:incr:(length(x)-incr)
    %Windowing Data   
      xDat = x_mod(i:i+nfft-1) .* window;
      yDat = y_mod(i:i+nfft-1) .* window;
  
    % FOURIER TRANSFORMS    
      ftX = fft(xDat, nfft);                           
      ftY = fft(yDat, nfft);
  
    % Limits spectrum to meaningful points  
      spX(:,j) = ftX(1:hwin);                        
      spY(:,j) = ftY(1:hwin);
  
    %Get auto and cross power spectra
    %disp(j);
      Sxx(:,j) = Sxx(:,j) + (spX(:,j) .* conj(spX(:,j)));
      Syy(:,j) = Syy(:,j) + (spY(:,j) .* conj(spY(:,j)));
      Sxy(:,j) = Sxy(:,j) + (spX(:,j) .* conj(spY(:,j)));
  
    t(j) = i/fs;                             % Calculate the time vector
    j = j + 1;                               % Increment index
  end
end
 
  Sxx = Sxx/7;
  Syy = Syy/7;
  Sxy = Sxy/7;
 
%Calculate MSC 
  num = abs(Sxy).^2;
  den = (Sxx.*Syy);
  %FIXME THIS VALUE IS ALWAYS 1
  msc = num ./ den;
      
%END OF FUNCTION