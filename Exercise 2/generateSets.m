dataset = load('54802.mat');
TRG = dataset.Trg;

% typical trainingset -> 70% seizures, with n� seizure points = n� interictal points
[trainingSet, trainingTargetMatrix, testSet, testTargetMatrix] = build_sets(0.7, 1);

% only 10% seizures on trainingset, n� seizure points = n� interictal points
[trainingSet2, trainingTargetMatrix2, testSet2, testTargetMatrix2] = build_sets(0.1, 1);

% 70% seizures, n� interictal points is 10x larger than the seizure points
[trainingSet3, trainingTargetMatrix3, testSet3, testTargetMatrix3] = build_sets(0.7, 10);
