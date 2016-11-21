%runNetsforTesting
clear
clc
n = {'Feedforward', 'FitNet', 'Recurrent'};
type = {'Balanced', 'Few Seizures', 'Unbalanced'};
preference = {'detection', 'prediction'};
spec = {'High', 'Medium', 'None'};
neurons = {10,20,30};
postProc = {'5 strict', '10 strict', '15 strict', '10 relaxed'};

for o=1:length(n)
    for p=1:length(type)
        for k=1:length(preference)
            for l=1:length(spec)
                for w=1:length(neurons)
                    for z=1:length(postProc)
                            testNetPostProc(n{o}, type{p}, preference{k}, spec{l}, neurons{w}, postProc{z});
                    end
                 end
            end
        end
    end
end