function [crossvals] = buildclass(indicators,percentiles,trials)
    for i = 1:size(indicators,3),
        [row col] = find(isnan(indicators(:,:,i)));
        row = unique(row);
        percentiles(row,:) = [];
        indicators(row,:,:) = [];
    end
    testfrac = 0.2;
    cvatotal = 0;
    crossvals = NaN(1,size(indicators,2));
    ind_row = size(indicators,1);
    for i = 1:size(indicators,2),
        current_year = squeeze(indicators(:,i,:));
        for k = 1:trials,
            permuted = randperm(ind_row);
            test = permuted(1:floor(ind_row*testfrac));
            train = permuted(ceil((ind_row*testfrac)):end);
            predictedclasses = classify(current_year(test,:), current_year(train,:),percentiles(train));
            cvatotal = cvatotal + mean(predictedclasses == percentiles(test)');
        end
        crossvals(i) = cvatotal/trials;
        cvatotal = 0;
end