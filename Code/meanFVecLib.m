function [fVec, t] = meanFVecLib(x,nfft, fs)
  %ERROR CHECK Ensure that the input vector is a row vector (if not already)
  [N, xcol] = size(x);
  if N < xcol
    x = x';			
    N = xcol;			
  end
  
  x(isnan(x)) = 0;

  incr = floor(N/fs);		%Calculate window increment
  hwin = fix(nfft/2);		%Half window size
  
  fVec = zeros(1, ceil(N/incr));
  %Zero pad data array to handle edge effects
  x_mod = [x; zeros(nfft,1)];

  j = 1;				%Used to index time vector

  %Calculate spectra for each window position
  %Apply Hamming window
  for i = 1:incr:N
    data = x_mod(i:i+nfft-1);
    [Pxx, F] = periodogram(data,hanning(nfft),[],fs);
    fVec(j) = meanfreq(Pxx,F);
    t(j) = i/fs;			    % Calculate the time vector
    j = j + 1;
  end
  
  fVec(isnan(fVec)) = 0;
end

