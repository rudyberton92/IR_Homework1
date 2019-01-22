%The following is a modification of the code written by teacher Nicola
%Ferro.

%Before to start choose the measure you are using to calculate Anova!
Measure_case= 1;

switch Measure_case
    case 1
        MeasureID = 'Average Precision (AP)';
        TukeyID = 'ap-tukey.pdf';
        BoxplotID =  'ap-boxplot.pdf';
        
    case 2
        MeasureID = 'R-prec';
        TukeyID = 'rprec-tukey.pdf';
        BoxplotID =  'rprec-boxplot.pdf';
        
    case 3
        MeasureID = 'Precision at Document Cut-off with k=10 (P@10)';
        TukeyID = 'P10-tukey.pdf';
        BoxplotID =  'P10-boxplot.pdf';
end



% the mean for each run across the topics
m = mean(measure);

% sort in descending order of mean score
[~, idx] = sort(m, 'descend');

% re-order runs by ascending mean of the measure
measure = measure(:, idx);
runID = runID(idx);

% perform the ANOVA
[~, tbl, sts] = anova1(measure, runID, 'off');

% display the ANOVA table
tbl;

% perform
c = multcompare(sts, 'Alpha', 0.05, 'Ctype', 'hsd'); 

% display the multiple comparisons
c;

%% plots of the data

% get the Tukey HSD test figure
currentFigure = gcf;

    ax = gca;
    ax.FontSize = 20;
    ax.XLabel.String = MeasureID;
    ax.YLabel.String = 'Run';

    currentFigure.PaperPositionMode = 'auto';
    currentFigure.PaperUnits = 'centimeters';
    currentFigure.PaperSize = [42 22];
    currentFigure.PaperPosition = [1 1 40 20];

print(currentFigure, '-dpdf', TukeyID);
    
    
% box plot
currentFigure = figure;
    % need to reverse the order of the columns to have bloxplot displayed
    % as the Tukey HSD plot
    boxplot(measure(:, end:-1:1), 'Labels', runID(end:-1:1), ...
        'Orientation', 'horizontal', 'Notch','off', 'Symbol', 'ro')
    
    ax = gca;
    ax.FontSize = 20;
    ax.XLabel.String = MeasureID;
    ax.YLabel.String = 'Run';
    
    currentFigure.PaperPositionMode = 'auto';
    currentFigure.PaperUnits = 'centimeters';
    currentFigure.PaperSize = [42 22];
    currentFigure.PaperPosition = [1 1 40 20];

print(currentFigure, '-dpdf',BoxplotID);


