%Reading in data
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
WomenEmployed = readtable('WomenEmployed.xls');
PhysDensity = readtable('PhysicianDensity.xls');
NursDensity = readtable('NursesDensity.xls');

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
%Remove countries without data or rows for groupings of countries
EditNM(temp,:) = [];
EditGNI(temp,:) = [];
EditLR(temp,:) = [];
EditND(temp,:) = [];
EditPD(temp,:) = [];
EditPop(temp,:) = [];
EditSan(temp,:) = [];
EditWE(temp,:) = [];
%%
% EditedData = {EditGNI, EditLR, EditND, EditNM, EditPD, ... 
%     EditPop, EditSan, EditWE};
% for i = 1:numel(EditedData),
%     [m n] = size(EditedData{i});
%     for j = 31:56,
%         for k = 1:m,
%             if isnan(EditedData{i{m,yearsStr{j}}} == 1,

%% 
EditedData = {EditGNI, EditLR, EditND, EditNM, EditPD, ... 
     EditPop, EditSan, EditWE};
Titles = {'Gross National Income by Country in 2010','Literacy Rate by Country in 2010', ...
    'Density of Nurses by Country in 2010', 'Neonatal Mortality Rate by Country in 2010',...
    'Density of Physicians by Country in 2010','Population Density by Country in 2010',...
    'Access to Improved Sanitation by Country in 2010'...
    'Female Employment by Country in 2010'};
XLabels = {'Gross National Income (US Dollars)','Adult Literacy Rate (%)',...
    'Nurses and Midwives (per 1000 people)','Neonatal Mortality Rate (per 1000 live births',...
    'Density of Physicians (per 1000 people)','Total Population','Access to Improved Sanitation (%)'...
    'Percent of Female Population Employed'}
for i = 1:numel(EditedData),
    figure;
    x = EditedData{i};
    histogram(x{:,'x2010'},15);
    title(Titles{i});
    xlabel(XLabels{i});
    ylabel('Number of Countries');
end



