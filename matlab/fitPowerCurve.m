function [c, y1, yOpt, xOpt] = fitPowerCurve(x,y)
%FITPOWERCURVE Use hanging weights and power outputs from intial sprint
%trials to predict the hanging weight that will maximize power output using
%a 2nd order polynomial fit.
% 
%   Inputs:
%           - x = column vector of hanging weight values in pounds (lbs)
%           - y = column vector of power output values in watts (W)
%
%   Outputs:
%           - c = fit object (see documentation on "fit" function)
%           - y1 = power output as a function of hanging weights from 0 to
%           50 lbs
%           - yOpt = predicted maximal power output in Watts
%           - xOpt = predicted optimal hanging weight in Lbs
%           - figure = figure showing the data and curve
%
%   Written by Ross Wilkinson (University of Colorado Boulder)
%   (c) Ross Wilkinson
%
%% Fit 2nd order polynomial
[c, ~, ~] = fit(x,y,'poly2','Robust','on');

%% Remove outliers from data
% UNCOMMENT THIS SECTION TO REMOVE OUTLIERS
% [~,TF] = rmoutliers(o.residuals);
% x = x(~TF);
% y = y(~TF);

%% Fit again with updated bounds
%UNCOMMENT THIS SECTION TO ENFORCE BOUNDS
% options = fitoptions(c);
% options.Lower = [-Inf -Inf 0];
% options.Upper = [Inf Inf 0];
% [c, ~, ~] = fit(x,y,'poly2',options);

%% Create figure
fig = figure('name','Hanging weight vs Power Output');
set(fig,'Color','w')

x1 = 0:0.5:50;
sz = 25;
c1 = 'k';

%% Calculate optimal hanging weight and display
y1 = c.p1*x1.^2+c.p2*x1+c.p3;
[yOpt,I] = max(y1);
formatSpec = 'Predicted maximal power output = %4.2f Watts \n';
fprintf(formatSpec,yOpt)

xOpt = x1(I);
formatSpec = 'Predicted optimal hanging weight = %4.2f Lbs \n';
fprintf(formatSpec,xOpt)

%% Plot curve
scatter(x,y,sz,c1);
hold on
plot(x1,y1,'k--')

%% Edit figure
box off
xlabel('Hanging weight (lbs)')
ylabel('Power (W)')
xlim([0 50])
ylim([0 1500])

end
