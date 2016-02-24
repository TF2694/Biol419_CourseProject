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
%%

%%
%Remove the omitted countries from the other datasets
EditSan = SanitationData;
[m, n] = size(EditSan);
for i = 1:251,
	for j = 1:23,
        if strcmp(EditSan{i,'DataSource'},countries{j,'DataSource'})==1,
            countries{j,'DataSource'}
            EditSan{i,'DataSource'}
            EditSan(i,:) = [];
        end
        [m,n] = size(EditSan);
    end
end
%for some reason, American Samoa will not delete in the above for loop nor
%in a for loop that searches only for the string 'American Samoa' (copy and
%pasted from the EditSan table!).
%EditSan(12,:) = [];
%%
EditPop = PopulationData;
[m, n] = size(EditPop);
for i = 1:23,
	for j = 1:m,
        if strcmp(SanitationData{j,'DataSource'},countries{i,'DataSource'})==1,
            countries{i,'DataSource'}
            SanitationData{j,'DataSource'}
            EditSan(j,:) = [];
        end
    [m,n] = size(EditSan);
    end
    i
end
%%   
for i = 1:229,
    if strcmp(EditNM{i,'DataSource'},EditSan{i,'DataSource'})==0
        i
    end
end