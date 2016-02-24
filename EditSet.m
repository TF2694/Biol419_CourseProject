%this function takes a World Bank-type dataset in a table (first column is
%list of country names) and a table of country names. It deletes the
%countries listed in the CountrySet from the DataSet.
function DataSet = EditSet(DataSet, CountrySet)
    [m1 n1] = size(CountrySet);
    indices = zeros(m1,1);
    [m, n] = size(DataSet);
    for i = 1:m,
        for j = 1:numel(CountrySet),
            if strcmp(DataSet{i,'DataSource'},CountrySet{j,'DataSource'})==1,
                CountrySet{j,'DataSource'}
                DataSet{i,'DataSource'}
                indices(j) = i;
            end
        end
    end
    for i = 1:numel(indices),
        DataSet(i,:) = [];
    end
end