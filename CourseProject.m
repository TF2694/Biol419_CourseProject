%Reading in data
%http://data.worldbank.org/indicator/SH.STA.ACSN
SanitationData = readtable('SanitationData.xls');
%http://apps.who.int/gho/data/node.main.A1444?lang=en
HealthInfrastructure = readtable('HealthInfrastructure.xlsx');
%http://data.worldbank.org/indicator/SE.ADT.LITR.ZS
LiteracyRate = readtable('LiteractyRate.xls');
%http://data.worldbank.org/indicator/SP.POP.TOTL
PopulationData = readtable('PopulationData.xls');
%http://data.worldbank.org/indicator/NY.GNP.ATLS.CD
GniData = readtable('GNIData.xls');
%http://data.worldbank.org/indicator/SH.DYN.NMRT
NeonatalMortality = readtable('NeonatalMortality.xls');
%%
%Certain countries appear to have no World Bank data. These seem to be
%mostly small island nations or other countries with a very small
%population. This code identifies them and removes them from the analysis.

%Neonatal Mortality
%columns 35-60 if all are empty
temp = [];
for i = 4:251,
    sum = 0;
    for j = 35:60,
        if strcmp(NeonatalMortality{i,strcat('Var',num2str(j))},'') == 1,
            sum = sum+1;
            
        end
    end
    if sum == 26,
        temp = [temp i];
    end
end
countries = NeonatalMortality(temp,'DataSource')
EditNM = NeonatalMortality;
EditNM(temp,:) = [];