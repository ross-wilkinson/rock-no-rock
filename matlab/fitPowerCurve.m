% rock-no-rock fit power curve

%% Insert data
x = [90 110 130]; % cadence
y = [800 1000 800]; % power

%% Fit 2nd order polynomial
[c, ~, o] = fit(x,y,'poly2','Robust','on');
[~,TF] = rmoutliers(o.residuals);
x = x(~TF);
y = y(~TF);

%% Fit again with updated bounds
options = fitoptions(c);
options.Lower = [-Inf -Inf 0];
options.Upper = [Inf Inf 0];
[c, ~, ~] = fit(x,y,'poly2',options);

%% Plot curve
scatter(x,y,sz,c1); 
plot(x1,c.p1*x1.^2+c.p2*x1+c.p3,'k--')