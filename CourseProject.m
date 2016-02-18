%Reading in data
%http://apps.who.int/gho/data/node.main.46?lang=en
SanitationData = readtable('SanitationData.xlsx');
%http://apps.who.int/gho/data/node.main.A1444?lang=en
HealthInfrastructure = readtable('HealthInfrastructure.xlsx');
%http://data.worldbank.org/indicator/SE.ADT.LITR.ZS
LiteracyRate = readtable('LiteractyRate.xls');
