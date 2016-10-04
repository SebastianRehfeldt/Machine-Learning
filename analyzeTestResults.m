classifiedResults = [];
for i = 1:50
    max = 0;
    for j = 1:10
       if testResults(j,i) > max
        max = testResults(j,i);
       end
    end
    
    for j = 1:10
       if(testResults(j,i)== max)
           classifiedResults = [classifiedResults,j];
           break;
       end
    end
end

trueDigits=0;
for i = 1:50
   should = mod(i,10);
   if should == classifiedResults(i)
       trueDigits = trueDigits + 1;
   end
end