targetVector = Trg;

% change inter-ictal states to 1 and ictal states to 3
targetVector = (targetVector*2)+1;

indicesOf3 = find(targetVector==3);
startIndices = [indicesOf3(1)]; % first element of it, is first start of ictal
endIndices = [];

for i = 2:length(indicesOf3)
   if(indicesOf3(i)-indicesOf3(i-1) > 1)
       startIndices = [startIndices;indicesOf3(i)];       
   end
   
   if(indicesOf3(i)-indicesOf3(i-1) > 1 && Trg(indicesOf3(i-1))==1)
       endIndices = [endIndices;indicesOf3(i-1)];
   end
end

endIndices = [endIndices;indicesOf3(length(indicesOf3))];

%set 600 points before startIndices to 2 - preictal 
%set 300 points after  endindices   to 4 - postictal
for i= 1:length(startIndices)
   targetVector(startIndices(i)-601:startIndices(i)-1) = 2;
   targetVector(endIndices(i)+1:endIndices(i)+301) = 4;
end

targetMatrix = zeros(length(targetVector),4);
for i=1:length(targetVector)
    targetMatrix(i,targetVector(i))=1;
end