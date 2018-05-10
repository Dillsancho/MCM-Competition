
filename = 'y1s1.xlsx';
sheet = 1;
xlRange = 'B04:O107';
scores = xlsread(filename,sheet,xlRange)./100;
mm = size(scores,2);
AllFMu = zeros(1,size(scores,1));
FPass = 0;
AllTFinal = zeros(1,size(scores,1));
TPass = 0;
AllWFinal = zeros(1,size(scores,1));
WPass = 0;
AllCompFinal = zeros(1,size(scores,1));
CompPass = 0;
for i = 1:size(scores,1)
    [belief,TFinal,FMu,WFinal] = bayes(scores(i,:));
    [CompInter] = bayesN(scores(i,1:mm-2),mean(scores(i,:)),0.25);
    [CompFinal] = bayesN([CompInter scores(i,mm-1) scores(i,mm)], CompInter, std(scores(i,1:mm-2)));
    if FMu <= 0 || FMu >= 1
        FMU = mean(scores);
        FMu = FMU(mm);
    end
    if FMu >= 0.5
        FPass = FPass + 1;
    end
    if TFinal >= 0.5
        TPass = TPass + 1;
    end
    if WFinal >= 0.5
        WPass = WPass + 1;
    end
    if CompFinal >= 0.5
        CompPass = CompPass + 1;
    end
        
    AllFMu(i) = FMu;
    AllTFinal(i) = TFinal;
    AllWFinal(i) = WFinal;
    AllCompFinal(i) = CompFinal;  
end

f1 = figure('Name', 'Bayens Grade Distribution');
h1 = histogram(AllFMu);
h1.Normalization = 'probability';
h1.BinWidth = 0.025;

f2 = figure('Name', 'Traditional vs Bayens Grade Distribution');
h2 = histogram(AllTFinal);
hold on;
h1 = histogram(AllFMu);
h1.Normalization = 'probability';
h1.BinWidth = 0.025;
h2.Normalization = 'probability';
h2.BinWidth = 0.025;
hold off

f3 = figure('Name', 'Arbitrarily Weighted vs Bayens Grade Distribution');
h3 = histogram(AllWFinal);
hold on
h1 = histogram(AllFMu);
h1.Normalization = 'probability';
h1.BinWidth = 0.025;
h3.Normalization = 'probability';
h3.BinWidth = 0.025;
hold off

f4 = figure('Name', 'Compisite Bayens vs Bayens Grade Distribution');
h4 = histogram(AllCompFinal);
hold on
h1 = histogram(AllFMu);
h1.Normalization = 'probability';
h1.BinWidth = 0.025;
h4.Normalization = 'probability';
h4.BinWidth = 0.025;
hold off

T = table;
T.EvalTypes = {'Traditional';'Arbitrarily Weighted';'Normal Bayes';'Composite Bayens'};
T.Pass = [TPass ; WPass ; FPass ; CompPass];
T.Mean = [mean(AllTFinal) ; mean(AllWFinal) ; mean(AllFMu) ; mean(AllCompFinal)];
T.Std_dev = [std(AllTFinal) ; std(AllWFinal) ; std(AllFMu) ; std(AllCompFinal)]
writetable(T,'MCMTable.xls','Sheet',1,'Range','A1:D5');

