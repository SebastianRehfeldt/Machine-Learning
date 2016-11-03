function plot_from_xlsx(xlRanges, num_fig, graph_title, label)
    % plots the information in an Excel File specified in the cells xlRanges
    figure(num_fig);
    sheet = 1;
    A = zeros(3,length(xlRanges));

    for i=1:length(xlRanges)
        A(:,i) = xlsread('Results.xlsx', sheet, xlRanges{i});
    end
    
    %A(isnan(A)) = 0 ;
    
    bar(A');
    title(graph_title);
    legend('purelin', 'logsig', 'hardlim');
    set(gca, 'XTickLabel',label, 'XTick',1:numel(label))

%   to write
%   for i=1:length(xlRanges)
%       A(:,i) = xlswrite('Results.xlsx', xlRanges{i});
%   end
end