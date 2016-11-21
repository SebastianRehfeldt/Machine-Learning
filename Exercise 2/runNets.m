clear;
clc;

gpuDeviceCount;
gpuDevice(1);


n = {'Feedforward', 'Recurrent', 'FitNet'};
type = {'Balanced', 'Few Seizures', 'Unbalanced'};
preference = {'detection', 'prediction'};
spec = {'High', 'Medium', 'None'};
neurons = {10,20,30};

for o=1:length(n)
    for p=1:length(type)
        for k=1:length(preference)
            for l=1:length(spec)
                for w=1:length(neurons)
                        runNet(n{o}, type{p}, preference{k}, spec{l}, neurons{w});
                 end
            end
        end
    end
end