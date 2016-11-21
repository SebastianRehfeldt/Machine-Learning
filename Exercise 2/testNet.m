function testNet(net, testSet, testTargetMatrix, predictionBoost, detectionBoost, n, type, preference, spec, neurons)
    filename='simulResults112502/';

    testResults = sim(net,testSet);

    %specialize for prediction
    testResults(2,:) = testResults(2,:) * predictionBoost;

    %specialize for detection
    testResults(3,:) = testResults(3,:) * detectionBoost;

    for i=1:length(testResults)
        max = 1;
        for j=2:4
            if(testResults(j,i)>=testResults(max,i))
               max=j; 
            end
        end
        testResults(:,i) = zeros(4,1);
        testResults(max,i)=1;
    end
    
    % true and false positives

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
        if(testResults(2,i)==testTargetMatrix(2,i))
           if(testResults(2,i)==1)
               tpPrediction = tpPrediction+1;
           else
               tnPrediction = tnPrediction+1;
           end
        else
           if(testResults(2,i)==1)
               fpPrediction = fpPrediction+1;
           else
               fnPrediction = fnPrediction+1;
           end
        end

        %detection
        if(testResults(3,i)==testTargetMatrix(3,i))
           if(testResults(3,i)==1)
               tpDetection = tpDetection+1;
           else
               tnDetection = tnDetection+1;
           end
        else
           if(testResults(3,i)==1)
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

        %specificity - how many no seizures did it predict
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

        TruePositivesEditField = strcat(num2str(tpPrediction),' | ',num2str(tpDetection), '\n');
        FalsePositivesEditField = strcat(num2str(fpPrediction),' | ',num2str(fpDetection), '\n');
        TrueNegativesEditField = strcat(num2str(tnPrediction),' | ',num2str(tnDetection), '\n');
        FalseNegativesEditField = strcat(num2str(fnPrediction),' | ',num2str(fnDetection), '\n');

        SpecificityRecallNoSeizEditField = strcat(num2str(specPrediction),' | ',num2str(specDetection), '\n');
        SensitivityRecallSeizuresEditField = strcat(num2str(sensPrediction),' | ',num2str(sensDetection), '\n');
        PrecisionSeizureEditField = strcat(num2str(precPrediction),' | ',num2str(precDetection), '\n');
        PrecisionNoSeizureEditField = strcat(num2str(precPredictionNoSeizure),' | ',num2str(precDetectionNoSeizure), '\n');

        % Normal format
        filename = strcat(filename, n, '_', type, '_', preference, '_', spec, '_', num2str(neurons), '.txt');
        disp(filename)
        fid = fopen(filename,'wt');
        fprintf(fid, 'True Positives\n');
        fprintf(fid, TruePositivesEditField);
        fprintf(fid, '\nTrue Negatives\n');
        fprintf(fid, TrueNegativesEditField);
        fprintf(fid, '\nFalse Positives\n');
        fprintf(fid, FalsePositivesEditField);
        fprintf(fid, '\nFalse Negatives\n');
        fprintf(fid, FalseNegativesEditField);
        fprintf(fid, '\nSensitivity\n');
        fprintf(fid, SensitivityRecallSeizuresEditField);
        fprintf(fid, '\nSpecificity\n');
        fprintf(fid, SpecificityRecallNoSeizEditField);
        fprintf(fid, '\nPrec (Seizure)\n');
        fprintf(fid, PrecisionSeizureEditField);
        fprintf(fid, '\nPrec (No Seizure)\n');
        fprintf(fid, PrecisionNoSeizureEditField);
        fclose(fid);
end