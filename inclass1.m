matx1 = randi([-4,4],100000,1);
matx2 = randi([-4,4],100000,1);
figure;
for i = 1:1000,
    y = sum_of_squares(matx1(i),matx2(i));
    if abs(y-5) < 0.01,
        plot(matx1(i),matx2(i));
        hold on;
    end
end

%%
newx1 = [];
newx2 = [];

for i = 1:100000,
    y = sum_of_squares(matx1(i),matx2(i));
        if abs(y-5) < 0.01,
        newx1 = [newx1 matx1(i)];
        newx2 = [newx2 matx2(i)];
        end
end

figure;
plot(newx1,newx2);

