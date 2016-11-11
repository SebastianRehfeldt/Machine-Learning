function [trainingSet,trainingTargetMatrix, testSet, testTargetMatrix] = build_sets(trainPercentage, unbalance)
    % trainPercentage - percentage of seizures that will be on the trainingset
    % unbalance - how many more interictal points will there be compared to the seizure points
    
    % equilibrate the nº of points of the several classes in the training set
    dataset = load('54802.mat');
    TRG = dataset.Trg;
    dataset = dataset.FeatVectSel;

    targetVector = load('targetVector.mat');
    targetVector = targetVector.targetVector;

    targetMatrix = load('targetMatrix.mat');
    targetMatrix = targetMatrix.targetMatrix;


    seizures = diff(TRG);
    start_seizures = find(seizures == 1)-600;          % indexes of the 1st preictal ('2') of every seizure
    end_seizures = find(seizures == -1)+301;             % indexes of the last postictal ('4') of every seizure
    
    
    % -- BUILD TRAINING SET --
    total_seizures = length(start_seizures);                 % total nº of seizures in the dataset
    n_seizures_training = round(trainPercentage*total_seizures);         % 70% of seizures will be in the training set
    
    
    seizureIndexes = [];
    % indexes of all 2,3 and 4 points for training
    for i=1:n_seizures_training
        seizureIndexes = [seizureIndexes start_seizures(i):1:end_seizures(i)];
    end

    % Now we've got all the seizure points necessary for the dataset
    % Now for the interictal (normal) points
    % Nº is at most equal to the sum of the points of the seizure
    totalNormalPoints = length(seizureIndexes)*unbalance; % unbalance needs to have more 
    if (totalNormalPoints > length(dataset)-length(seizureIndexes))
        totalNormalPoints = length(dataset)-length(seizureIndexes);
    end
    
    % (make it random)
    %half = totalSeizurePoints/2;
    %totalNormalPoints = randi([half, totalSeizurePoints],1,1);

    normalIndexes = find(targetVector == 1)';
    normalIndexes = normalIndexes(1:totalNormalPoints);

    %join normal and seizure points indexes = all the training set
    trainingIndexes = horzcat(normalIndexes,seizureIndexes);
    trainingIndexes = sort(trainingIndexes);

    %Training and target set
    trainingSet = dataset(trainingIndexes,:)';
    trainingTargetMatrix = targetMatrix(trainingIndexes,:)';

    %remaining points (30% seizures) will be used for testing
    allIndexes = 1:length(dataset);
    testIndexes = setdiff(allIndexes,trainingIndexes);

    testSet = dataset(testIndexes,:)';
    testTargetMatrix = targetMatrix(testIndexes,:)';
end
