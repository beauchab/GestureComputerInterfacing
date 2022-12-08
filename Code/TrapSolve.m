%{
Function     - [total] = TrapSolve(data,x1, x2, stepsize)
Filename     - TrapSolve.m
Description  - This function implements the Trapezoidal rule to estimate
               the input data between the span of x1 and x2.
Author       - Brendan P. Beauchamp
Date         - 9/11/2022
Instructor   - Dr. Samhita Rhodes
@param       - data
                    This is the input data, it is a two column vector <t,x>
@param       - x1
                    This is the lower limit of integration
@param       - x2
                    This is the upper limit of integration
@return      - total
                    This is the evaluation of the integral
%}
function [total] = TrapSolve(data,time,x1, x2)

    %Variable Declarations
        sum = zeros(1,length(time));        %Sum is initially zero
        stepsize = time(2) - time(1);       %Calculate the step size
        sum0 = 0;

  %Loop between the limits of integration
  for i = x1:x2
    %First and last values in the sequence are weighted 1
      if(i == x1)
        sum(i) = sum0 + data(i);
      elseif(i == x2)
       sum(i) = sum(i-1) + data(i);       %Add to sum
       
    %Middle values in sequence are weighted 2
     else
       sum(i) = sum(i-1) + (2*data(i));   %Add to sum
     end    
  end
  
 total = (stepsize/2) .* sum;        %Divide the sum by half the step size

end

