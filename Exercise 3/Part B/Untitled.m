% discrete transfer function
num = [2];
den = [1 4.1 5.1 1.8];
[num, den]= c2dm(num,den, 1,'zoh');

% compute matrix
discreteOut = load('discreteOut.mat');
discreteOut = discreteOut.DiscreteOut.Data;
input = load('inputRand.mat');
input = input.inputRandom.Data;
%length(input.Data)
matrix = [];

% build matrix
for i=4:length(discreteOut)
    temp = [discreteOut(i-1) discreteOut(i-2) discreteOut(i-3) input(i-1) input(i-2) input(i-3) discreteOut(i)];
    matrix = [matrix; temp];
end

training = matrix(1:round(length(matrix)*0.7),:);
testing = matrix(round(length(matrix)*0.7)+1:length(matrix),:);
%training
%testing

fismat = genfis3(training(:,1:6), training(:,7), 'sugeno',5)