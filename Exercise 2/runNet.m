function runNet(n, type, preference, spec, neurons)
    %clear
    %clc
    % trains net
    % run simulations
    dataset = load('G4/112502.mat');
    dataset = dataset.FeatVectSel;

    targetMatrix = load('targetMatrix.mat');
    targetMatrix = targetMatrix.targetMatrix;

    predictionBoost = 1;
    detectionBoost = 1;



    st = strcat(n, type, preference, spec);
    disp(st);
    % choose training set
    if(strcmp(type,'Balanced'))
        [trainingSet,trainingTargetMatrix, testSet, testTargetMatrix ] = build_sets(0.7, 1);

    elseif(strcmp(type,'Few Seizures'))
        [trainingSet,trainingTargetMatrix, testSet, testTargetMatrix] = build_sets(0.1, 1);

    elseif(strcmp(type,'Unbalanced'))
        [trainingSet,trainingTargetMatrix, testSet, testTargetMatrix] = build_sets(0.7, 10);
    end

    % -- compute error weights --

    % the weight of the error is the nº of times there are
    % more interictal points than preictal | ictal points
    errorWeights = ones(1,length(trainingSet));

    indexesNormal = find(trainingTargetMatrix(1,:) == 1);
    indexesPreIctal = find(trainingTargetMatrix(2,:) == 1);
    indexesIctal = find(trainingTargetMatrix(3,:) == 1);
    %indexesPostIctal = find(targetMatrix(4,:) == 1); % never used

    % Specialization
    if (strcmp(preference, 'prediction')==1)

        if(strcmp(spec,'High'))
            eWeight = (length(indexesNormal)/length(indexesPreIctal))*1.25;
            errorWeights(indexesPreIctal) = eWeight;
        elseif (strcmp(spec,'Medium'))
            % weight is equal to how many times the normal points are larger than preIctal
            eWeight = (length(indexesNormal)/length(indexesPreIctal));
            errorWeights(indexesPreIctal) = eWeight;
        elseif (strcmp(spec,'None'))
            % preIctal points are worth as much as the others
            errorWeights(indexesPreIctal) = 1;
        end

    elseif (strcmp(preference, 'detection')==1)
        if(strcmp(spec,'High'))
            eWeight = (length(indexesNormal)/length(indexesIctal))*1.25;
            errorWeights(indexesIctal) = eWeight;
        elseif (strcmp(spec,'Medium'))
            eWeight = (length(indexesNormal)/length(indexesIctal));
            errorWeights(indexesIctal) = eWeight;
        elseif (strcmp(spec,'None'))
            errorWeights(indexesIctal) = 1;
        end
    end

    % choose type of network
    if(strcmp(n,'Feedforward'))
        % divide by index

        net = feedforwardnet(neurons);

        net.divideFcn = 'divideind';
        [net.divideParam.trainInd,~,~] = divideind(length(trainingSet),1:length(trainingSet),[],[]);

        net.trainParam.epochs= 1000;

        net = train(net, trainingSet, trainingTargetMatrix, [], [], errorWeights, 'useGPU','yes');


    elseif(strcmp(n,'Recurrent'))

        net = layrecnet(1:2,neurons);
        net.divideFcn = 'divideind';
        [net.divideParam.trainInd,~,~] = divideind(length(trainingSet),1:length(trainingSet),[],[]);

        net.trainFcn = 'trainscg';
        net.trainParam.epochs= 1000;
        % with delays
        %trainingSet = tonndata(trainingSet,true,false);%con2seq(trainingSet);
        %trainingTargetMatrix = tonndata(trainingTargetMatrix,true,false);%con2seq(trainingTargetMatrix);
        %errorWeights = tonndata(errorWeights);


        %[Xs,Xi,Ai,Ts,EWs, ~] = preparets(net,trainingSet,trainingTargetMatrix, {}, errorWeights);
        %net = train(net,Xs,Ts,Xi,Ai, EWs); %,'useGPU','yes','showResources','yes'

        %net = configure(net,trainingSet,trainingTargetMatrix);
        %net = init(net);
        %view(net)

        net = train(net,trainingSet,trainingTargetMatrix, {}, {},errorWeights);

        %X = tonndata(trainingSet,true,false);
        %T = tonndata(trainingTargetMatrix,true,false);
        %trainFcn = 'trainscg';
        %inputDelays = 1:2;
        %feedbackDelays = 1:2;
        %net = narxnet(inputDelays,feedbackDelays,neurons,'closed',trainFcn);
        %net.divideFcn = 'divideind';
        %[net.divideParam.trainInd,~,~] = divideind(length(trainingSet),1:length(trainingSet),[],[]);

        %[x,xi,ai,t,ew] = preparets(net,X,{},T,errorWeights);

        % Train the Network
        %[net,tr] = train(net,x,t,xi,ai,ew); %,'useGPU','yes','showResources','yes'


    elseif(strcmp(n,'FitNet'))
        net = fitnet(neurons,'trainscg');
        net.divideFcn = 'divideind';
        [net.divideParam.trainInd,~,~] = divideind(length(trainingSet),1:length(trainingSet),[],[]);

        net = train(net, trainingSet, trainingTargetMatrix, [], [], errorWeights,'useGPU','yes','showResources','yes');

    end
    
    variableName = strcat('net_', n, '_', type, '_', preference, '_', spec, '_', num2str(neurons), '.mat');
    strcat('saving...', variableName)
    save(variableName, 'net');
    % aqui escrever

    %view(net)
    testNet(net, testSet, testTargetMatrix, predictionBoost, detectionBoost, n, type, preference, spec, neurons);
    
        
end