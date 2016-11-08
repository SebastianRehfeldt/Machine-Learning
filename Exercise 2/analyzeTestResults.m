testResults = transpose(sim(network1,testSetTransposed));

testResults(:,1) = testResults(:,1) * 0.5;
testResults(:,2) = testResults(:,2) * 500;

for i=1:length(testResults)
    max = 1;
    for j=2:4
        if(testResults(i,j)>=testResults(i,max))
           max=j; 
        end
    end
    testResults(i,:) = zeros(4,1);
    testResults(i,max)=1;
end

tpPrediction = 0;
tnPrediction = 0;
fnPrediction = 0;
fpPrediction = 0;

tpDetection = 0;
tnDetection = 0;
fnDetection = 0;
fpDetection = 0;

for i=1:length(testResults)
    %prediction
    if(testResults(i,2)==testTargetMatrix(i,2))
       if(testResults(i,2)==1)
           tpPrediction = tpPrediction+1;
       else
           tnPrediction = tnPrediction+1;
       end
    else
       if(testResults(i,2)==1)
           fpPrediction = fpPrediction+1;
       else
           fnPrediction = fnPrediction+1;
       end
    end

    %detection
    if(testResults(i,3)==testTargetMatrix(i,3))
       if(testResults(i,3)==1)
           tpDetection = tpDetection+1;
       else
           tnDetection = tnDetection+1;
       end
    else
       if(testResults(i,3)==1)
           fpDetection = fpDetection+1;
       else
           fnDetection = fnDetection+1;
       end
    end
end

%sensitivity - how many true seizures did it predict  - should be high
%               if we have a seizure, how sure can we be to detect it
%               it is really bad if fn occur (a real seizure would not be
%               detected)
%recall of seizures...
sensPrediction = tpPrediction/(tpPrediction+fnPrediction);
sensDetection  = tpDetection /(tpDetection +fnDetection);

%specificity - how many false seizures did it predict - should be low???
%               if we do not have a seizure, how sure can we be that we
%               will not predict a seizure
%               it is not bad if we have false alarms, but it should not be
%               too bad
%recall for no seizures
specPrediction = tnPrediction/(tnPrediction+fpPrediction);
specDetection  = tnDetection /(tnDetection +fpDetection);

%precision of seizures - how many of the predicted seizures are seizures
%               can be seen as false alarm probability
%               does not need to be very high, but should not be very low
precPrediction = tpPrediction/(tpPrediction+fpPrediction);
precDetection  = tpDetection/ (tpDetection +fpDetection);

%precision of no seizure - should be high
%               how sure can we be that we have really no seizure if we
%               predict no seizure
precPredictionNoSeizure = tnPrediction/(tnPrediction+fnPrediction);
precDetectionNoSeizure  = tnDetection/ (tnDetection +fnDetection);

resPrediction = [sensPrediction,specPrediction,precPrediction,precPredictionNoSeizure];
resDetection  = [sensDetection,specDetection,precDetection,precDetectionNoSeizure];

resPrediction
%resDetection