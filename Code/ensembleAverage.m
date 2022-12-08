%{
Function    - averageArr = ensembleAverage(arrayIn)
Description - This function will perform an average of the vectors input
Author      - Brendan P. Beauchamp
Date        - 9/13/2021
Instructor  - Dr. Samhita Rhodes
@param      - arrayIn
                This is the ERP array which the user would like to average.
@param      - numAv
                This is the number of ERP which the user would like to
                average.
@return     - averageArr
                This is the array which has been averaged and returned to
                the usedr
%}
function averageArr = ensembleAverage(arrayIn)
    %Fined the dimensions of the array
      aInSize = size(arrayIn);
      numVec = aInSize(1);
      numPts = aInSize(2);

    %Verify first dimension of the array >= the number of signals averaged
      if(numVec < 2)
        error('ERROR: ONLY ONE VECTOR INPUT');
      else
        %Generate output array
          averageArr = zeros(1,numPts);

            %Sum of the number of ERP desired
              for i=1:numVec
                averageArr = averageArr + arrayIn(i,:);
              end
            %Divide by the number of Vectors
              averageArr = averageArr./numVec;

      end
end
%END FUNCTION