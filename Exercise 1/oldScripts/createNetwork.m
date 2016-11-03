x = intRes31; %dataset %bigDataSet %intRes11 %intRes21 %intRes31
t = Target; %datasetTarget %Target

net = perceptron;

net.performParam.lr = 0.5;
net.trainParam.epochs = 1000;
net.trainParam.show = 35;
net.trainParam.goal = 1e-6;
net.performFcn = 'mse';
net.trainFcn = 'traingd';
net.layers{1}.transferFcn = 'purelin'; %hardlim %purelin %logsig

[trainInd,valInd,testInd] = divideblock(1000,0.85,0.15,0);
net.divideFcn = 'divideblock';

net = train(net,x,t);
view(net);