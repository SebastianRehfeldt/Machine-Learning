function testNetPostProc(n, type, preference, spec, neurons, postProc)
    
    filename = 'simulPostProc112502/';
    predictionBoost=1;
    detectionBoost=1;
    
    % loads the neural network
    filenameNet='simulSavedNets112502/';
    variableName = strcat(filenameNet, 'net_', n, '_', type, '_', preference, '_', spec, '_', num2str(neurons), '.mat');
    if (exist(variableName, 'file') == 2)
        net = load(variableName, 'net');
        net = net.net;

        % choose testSet
        if(strcmp(type,'Balanced'))
            [trainingSet,trainingTargetMatrix, testSet, testTargetMatrix ] = build_sets(0.7, 1);

        elseif(strcmp(type,'Few Seizures'))
            [trainingSet,trainingTargetMatrix, testSet, testTargetMatrix] = build_sets(0.1, 1);

        elseif(strcmp(type,'Unbalanced'))
            [trainingSet,trainingTargetMatrix, testSet, testTargetMatrix] = build_sets(0.7, 10);
        end



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

        %post-processing

        if(strcmp(postProc, '10 relaxed'))
            %checks if following 5 out of the next 10 are the same as the actual
            %if not -> inter-ictal (as it is just positive and negative -> no difference)

            for i=1:length(testResults)-10
                followingAreTheSame = 0;
                 for j=1:10
                     if(isequal(testResults(:,i),testResults(:,i+j)))
                         followingAreTheSame = followingAreTheSame+1;
                     end
                 end

                 if(followingAreTheSame < 5)
                     testResults(:,i)=[1;0;0;0];
                 end
             end
        else
            if(strcmp(postProc, 'None'))

            else
                %checks if following 5 or 10 are the same as the actual
                %if all pre-ictal -> keep as pre-ictal
                %if all ictal -> keep as ictal
                %if following not the same -> inter-ictal (as it is just positive and negative -> no difference)

                checkFollowing = str2num(postProc(1:2));
                for i=1:length(testResults)-checkFollowing
                    followingAreTheSame = 1;
                     for j=1:checkFollowing
                         if(isequal(testResults(:,i),testResults(:,i+j)))

                         else
                             followingAreTheSame = 0;
                         end
                     end

                     if(followingAreTheSame == 0)
                         testResults(:,i)=[1;0;0;0];
                     end
                 end 
            end                                   
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
            
            filename = strcat(filename, n, '_', type, '_', preference, '_', spec, '_', num2str(neurons), '_', postProc, '.txt');
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
    
    else
        strcat(variableName, ' doesnt exist')
    end
end