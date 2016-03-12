%http://data.worldbank.org/indicator/SH.STA.ACSN
SanitationData = readtable('SanitationData.xls');
%http://data.worldbank.org/indicator/SE.ADT.LITR.ZS
LiteracyRate = readtable('LiteractyRate.xls');
%http://data.worldbank.org/indicator/SP.POP.TOTL
PopulationData = readtable('PopulationData.xls');
%http://data.worldbank.org/indicator/NY.GNP.ATLS.CD
GniData = readtable('GNIData.xls');
%http://data.worldbank.org/indicator/SH.DYN.NMRT
NeonatalMortality = readtable('NeonatalMortality.xls');
%http://data.worldbank.org/indicator/SL.TLF.ACTI.FE.ZS
WomenEmployed = readtable('WomenEmployed.xls');
%http://data.worldbank.org/indicator/SH.MED.PHYS.ZS
PhysDensity = readtable('PhysicianDensity.xls');
%http://data.worldbank.org/indicator/SH.MED.NUMW.P3
NursDensity = readtable('NursesDensity.xls');
%http://data.worldbank.org/indicator/SH.MED.BEDS.ZS
HospitalBeds = readtable('HospitalBeds.xls');
%http://data.worldbank.org/indicator/SH.XPD.PUBL
HealthSpending = readtable('HealthSpending.xls');
%%
%Certain countries appear to have no World Bank data. These seem to be
%mostly small island nations or other countries with a very small
%population. This code identifies them and removes them from the analysis.

%Neonatal Mortality
%columns 35-60 if all are empty
years = 1960:2015;
yearsStr = {};
for i = 1:numel(years),
    yearsStr{i} = strcat('x',num2str(years(i)));
end
temp = [];
for i = 1:248,
    sum = 0;
    for j = 1:56,
        if isnan(NeonatalMortality{i,yearsStr(j)}) == 1,
            sum = sum+1;
            
        end
    end
    if sum == 56,
        temp = [temp i];
    end
end
%Identify by hand data for groupings of countries
temp = [temp 6 35 47 59 60 61 62 65 70 71 91 94 120 126 127 128 131 132 ...
    144 152 161 168 172 173 175 187 193 204 206 207 232 242];
temp = sort(temp);
temp = unique(temp);
countries = NeonatalMortality(temp,'CountryCode');
EditNM = NeonatalMortality;

EditGNI = GniData;
EditLR = LiteracyRate;
EditND = NursDensity;
EditPD = PhysDensity;
EditPop = PopulationData;
EditSan = SanitationData;
EditWE = WomenEmployed;
EditHB = HospitalBeds;
EditHS = HealthSpending;
%Remove countries without data or rows for groupings of countries
EditNM(temp,:) = [];
EditGNI(temp,:) = [];
EditLR(temp,:) = [];
EditND(temp,:) = [];
EditPD(temp,:) = [];
EditPop(temp,:) = [];
EditSan(temp,:) = [];
EditWE(temp,:) = [];
EditHB(temp,:) = [];
EditHS(temp,:) = [];
clear sum;
%%
%Identifies how many countries there are without data for every year
%1990-2015 in each dataset
EditedData = {EditGNI, EditLR, EditND, EditNM, EditPD, ... 
    EditPop, EditSan, EditWE,EditHB,EditHS};
emptyYears = zeros(numel(EditedData),26);
sum = 0;
chooseYears = yearsStr(31:56);
for i = 1:numel(EditedData),
    [m n] = size(EditedData{i});
    currentData = EditedData{i};
    for j = 1:26,
        
        for k = 1:m,
            if isnan(currentData{k,chooseYears{j}}) == 1,
                emptyYears(i,j) = emptyYears(i,j) + 1;
            end
        end

    end
end
clear sum;
worstYears = sum(emptyYears);
%Exclude 2015 for which there is double the amount of missing data
worstData = sum(emptyYears(:,1:25),2);
%%
%Finding countries with most complete data
emptyCountry = zeros(193,numel(EditedData));
for i = 1:numel(EditedData),
    [m n] = size(EditedData{i});
    x = EditedData{i};
    for j = 1:m,
        for k = 1:numel(chooseYears)-1,
            if isnan(x{j,chooseYears{k}}) == 1,
                emptyCountry(j,i) = emptyCountry(j,i) + 1;
            end
        end
    end         
end
worstCountry = sum(emptyCountry,2);
%%
%Missing data by country
figure;
imagesc(emptyCountry)
colorbar;
ax1 = gca;
ax1.XTickLabel = {'GNI','Literacy','Nurse Density',...
    'Neonatal Mortality','Physician Density','Population Density','Improved Sanitation',...
    'Females Employed','Hospital Beds','Health Spending'};
ax1.XTickLabelRotation = 45;
ax1.YTickLabel = {''};
ylabel('Country');
title('Number of Missing Data Points by Country');
%% 
%Missing data by year
figure;
imagesc(emptyYears);
colorbar;
ax2 = gca;
ax2.YTickLabel = {'GNI','Literacy','Nurse Density',...
    'Neonatal Mortality','Physician Density','Population Density','Improved Sanitation',...
    'Females Employed','Hospital Beds','Health Spending'};
ax2.YTickLabelRotation = 45;
ax2.XTickLabel = {'1994','1999','2004','2009','2014'};
xlabel('Year');
title('Number of Countries Without Data by Year');
%%            
EditedData = {EditGNI, EditLR, EditND, EditNM, EditPD, ...
     EditPop, EditSan, EditWE, EditHB,EditHS};
Titles = {'Gross National Income by Country in 2010','Literacy Rate by Country in 2010', ...
    'Density of Nurses by Country in 2010', 'Neonatal Mortality Rate by Country in 2010',...
    'Density of Physicians by Country in 2010','Population Density by Country in 2010',...
    'Access to Improved Sanitation by Country in 2010'...
    'Female Employment by Country in 2010','Hospital Beds 2010','Health Spending in 2010'};
XLabels = {'Gross National Income (US Dollars)','Adult Literacy Rate (%)',...
    'Nurses and Midwives (per 1000 people)','Neonatal Mortality Rate (per 1000 live births',...
    'Density of Physicians (per 1000 people)','Total Population','Access to Improved Sanitation (%)'...
    'Percent of Female Population Employed','Hosptial Beds (per 1000)','Health Expenditure. public (% of total)'};
for i = 1:numel(EditedData),
    figure;
    x = EditedData{i};
    histogram(x{:,'x2010'},15);
    title(Titles{i});
    xlabel(XLabels{i});
    ylabel('Number of Countries');
end
%% Calculating change between years from 2000 to 2010
%time points to check that the indicator is reliable over a decade, not
%just the best predictor for that year.

%First, remove 2000 to 2010 from the data sets and store separately
%X = (country,year,dataset)
X = zeros(m,11,numel(EditedData));
for i = 1:numel(EditedData),
    x = EditedData{i};
    X(:,:,i) = x{:,45:55};
end
%Second, calculate the change between years and store
Xchange = NaN(m,10,numel(EditedData));
[n1] = size(X,2);
for i = 1:numel(EditedData),
    for j = 1:(n1 - 1),
    Xchange(:,j,i) = X(:,j+1,i) - X(:,j,i);
    end
end
%% LDA for health
Y25 = prctile(X(:,:,4),25);
Y50 = prctile(X(:,:,4),50);
Y75 = prctile(X(:,:,4),75);
%Sort the countries into percentiles for each year.
Percentiles = NaN(m,11);
for i = 1:m,
    for j = 1:n1,
        if X(i,j,4)> Y75(j)
            Percentiles(i,j) = 4;
        elseif X(i,j,4)> Y50(j)
            Percentiles(i,j) = 3;
        elseif X(i,j,4) > Y25(j)
            Percentiles(i,j) = 2;
        else
            Percentiles(i,j) = 1;
        end
    end
end

%Do LDA for each indicator every year
%First, identify the NaNs. These mess up the classifer because they change
%the effective dimensions of the training matrix, disrupting how the known
%labels are applied.
IDnans = isnan(X(:,1,1));
%find the indices where isnan = 1
Idxnans = find(IDnans);
%delete these rows in a copy of the percentiles matrix
p1 = Percentiles(:,1);
p1(Idxnans) = [];
%delete NaNs from a copy of the indicator data for that year
currentIn = X(:,1,1);
currentIn(Idxnans) = [];
%run the classifier
predictedclasses = classify(currentIn, currentIn,p1);
%cross validate
crossval = mean(predictedclasses == p1)
%store cross val in matrix for plotting
%all predicted classes go here for storage
predclas = cell(size(X,3),size(X,2));
crossval = NaN(size(X,3),size(X,2));
%store predicted classes in cell matrix
trials = 1000;
%fraction of dataset to test with
testfrac = 0.2;

for i = 1:size(X,3),
    for j = 1:size(X,2),
        crossval1 = 0;
        IDnans = isnan(X(:,j,i));
        Idxnans = find(IDnans);
        p1 = Percentiles(:,j);
        p1(Idxnans) = [];
        currentIn = X(:,j,i);
        currentIn(Idxnans) = [];
      
        for k = 1:trials,
            permuted = randperm(numel(currentIn));
            test = permuted(1:floor(numel(currentIn)*testfrac));
            train = permuted(ceil((numel(currentIn)*testfrac)):end);
            predictedclasses = classify(currentIn(test), currentIn(train),p1(train));
            predclas{i,j} = predictedclasses;
            crossval1 = crossval1 + mean(predictedclasses == p1(test));
        end
        crossval(i,j) = crossval1/trials;
    end
end
crossval = vertcat(crossval(1:3,:), crossval(5:size(crossval,1),:));
Time = 2000:2010;
figure;
Title2 = {'GNI','Literacy Rate', ...
    'Density of Nurses',...
    'Density of Physicians','Population Density',...
    'Access to Improved Sanitation'...
    'Percent of Females Employed','Hospital Beds (per 1000 people)','Health expenditure,public (% of total)'};
for i = 1:size(crossval,1),
    subplot(3,3,i);
    plot(Time,crossval(i,:));
    title(Title2{i});
    axis([2000 2010 0 1])
    a1 = gca;
    a1.XMinorTick = 'on';
    a1.YMinorTick = 'on';
    xlabel('Year');
    ylabel('Cross-validated accuracy')
end
suptitle('Mean Cross-Validated Accuracy (n = 100) for LDA Classifiers Predicting Neonatal Mortality');
%%
IS = squeeze(X(:,:,7));
HS = squeeze(X(:,:,10));
p2 = Percentiles;
%store predicted classes in cell matrix
for i = 1:11,
    Nantime = isnan(IS(:,i));
    nonans = find(Nantime);
    p2(nonans,:) = [];
    IS(nonans,:) = [];
    HS(nonans,:) = [];
end
for i = 1:11,
    Nantime = isnan(HS(:,i));
    nonans = find(Nantime);
    p2(nonans,:) = [];
    IS(nonans,:) = [];
    HS(nonans,:) = [];
end

ISHS = cat(3,IS,HS);
ISHS = squeeze(ISHS(:,1,:));
predictedclasses = classify(ISHS,ISHS,p2(:,1))
crossval = mean(predictedclasses == p2(:,1))
%%
figure;
histogram(X(:,1,7),10);
hold on;
histogram(X(:,11,7),10);
