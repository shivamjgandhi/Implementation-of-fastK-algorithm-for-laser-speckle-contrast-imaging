function K = fastK(Raw)

%This algorithm produces a Kmap for an input image from LSCI.

%Step 1
sumAc = Raw(1,:);
sqSumAc = sumAc.*sumAc;
w = 7;
for i = 2:w
    sumAc = sumAc + Raw(i, :);
    sqSumAc = sqSumAc + Raw(i,:).*Raw(i,:);
end

%%
%Step 2

[m,n,~] = size(Raw);
sum = zeros(m,n);
sqSum = zeros(m,n);
sum(1,:) = sumAc;
sqSum(1,:) = sqSumAc;
for i = w+1:m
    sumAc = sumAc - Raw(i-w,:) + Raw(i,:);
    sqSumAc = sqSumAc - Raw(i-w,:).*Raw(i-w,:)+Raw(i,:).*Raw(i,:);
    sum(i-w+1,:) = sumAc;
    sqSum(i-w+1,:) = sqSumAc;
end

%%
%Step 3

sumAc = sum(:,1);
sqSumAc = sqSum(:,1);
for j=2:w
    sumAc = sumAc + sum(:,j);
    sqSumAc = sqSumAc + sqSum(:,j);
end

%%
%Step 4

for j = w+1:n
    B = sumAc;
    sqB = sqSumAc;
    sumAc = sumAc - sum(:,j-w) +sum(:,j);
    sqSumAc = sqSumAc - sqSum(:,j-w) + sqSum(:,j);
    sum(:,j-w) = B;
    sqSum(:,j-w) = sqB;
end
sum(:,n-w+1) = sumAc;
sqSum(:,n-w+1) = sqSumAc;

%%
%Step 5

K = zeros(m-w+1,n-w+1);
for i = 1:m-w+1
    for j = 1:n-w+1
        K(i,j) = sqrt((w.^2*sqSum(i,j) - sum(i,j).^2)/(w.^2*(w.^2-1)))/(sum(i,j)/w.^2);
    end
end

%step 6
K = K/median(median(K))

end