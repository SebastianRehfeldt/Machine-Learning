% Read the DC and AM values
label=0;
num_fig = 3;
xlRanges = {'B5:B7', 'B9:B11', 'C5:C7', 'C9:C11', 'E5:E7', 'E9:E11', 'F5:F7', 'F9:F11', 'H5:H7', 'H9:H11', 'I5:I7', 'I9:I11'};
graph_title = 'Number of digits correctly classified';
label = 1:length(xlRanges);
plot_from_xlsx(xlRanges, num_fig, graph_title, label);

% Plot the DC and AM summed values
num_fig = 4;
xlRangesSum = {'B13:B15', 'C13:C15', 'E13:E15', 'F13:F15', 'H13:H15', 'I13:I15'};
graph_title = 'Total number of digits classified';
label = {'DC-Bad', 'AM-Bad', 'DC-Good', 'AM-Good', 'DC-Comb', 'AM-Comb'};
plot_from_xlsx(xlRangesSum, num_fig, graph_title, label);

