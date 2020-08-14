% rock-no-rock fit power curve

%% Insert data
x = [12.5; 22.5; 32.5]; % weight
y = [1025; 1196; 439]; % power

%% Fit 2nd order polynomial
[c, ~, o] = fit(x,y,'poly2','Robust','on');
% [~,TF] = rmoutliers(o.residuals);
% x = x(~TF);
% y = y(~TF);

%% Fit again with updated bounds
% options = fitoptions(c);
% options.Lower = [-Inf -Inf 0];
% options.Upper = [Inf Inf 0];
% [c, ~, ~] = fit(x,y,'poly2',options);

%% Create figure
fig = figure;
set(fig,'Position',[0 0 500 300],'Color','w')

x1 = 0:0.5:50;
sz = 25;
c1 = 'k';
c2 = 'r';

%% Plot curve
scatter(x,y,sz,c1);
hold on
plot(x1,c.p1*x1.^2+c.p2*x1+c.p3,'k--')

%% Edit figure
box off
xlabel('Hanging weight (lbs)')
ylabel('Power (W)')
xlim([0 50])
ylim([0 1500])
