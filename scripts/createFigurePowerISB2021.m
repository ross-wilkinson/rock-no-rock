%% Create figure: Power ISB 2021

%% Initialize
clear; clc; close all

%% Set directories
expDir = "/Users/rosswilkinson/Google Drive/projects/rock-no-rock";
datDir = strcat(expDir, "/data");
docDir = strcat(expDir, "/docs");

%% Load rock-no-rock data
cd(datDir)
load("group_data.mat")
mdl{14}.data(1,:) = [];

%% Calculate subject means
meanSub = varfun(@(x) mean(x,'omitnan'),Tdat,...
    'InputVariables',{'power','torque','cadence','lean'}, ...
    'GroupingVariables',{'subject','condition'});

%% Create data arrays
grpPwr(1,:) = meanSub.Fun_power(meanSub.condition == 3);
grpPwr(2,:) = meanSub.Fun_power(meanSub.condition == 1);
grpPwr(3,:) = meanSub.Fun_power(meanSub.condition == 2);

a = grpPwr';
a0 = a - a(:,1);
aPerc = a0 ./ a(:,1) * 100;
aPerc(:,4) = (a(:,2) - a(:,3)) ./ a(:,3) * 100;

%% Create figure (1x4)
figure('color','w','position',[50 0 900 250])

%% Subplot 1 - absolute
ax1 = subplot(141);

plot(grpPwr)
hold on
set(gca,'ColorOrderIndex',1)
for i = 1:19
    scatter([1 2 3],grpPwr(:,i),20,'filled','o')
end
plot(mean(grpPwr,2,'omitnan'),'k-','LineWidth',2)
scatter([1 2 3],mean(grpPwr,2,'omitnan'),40,'k','filled','o')

xlim([0 4])
ylim([600 1600])
box off
ylabel('Maximal 1-s crank power (W)')
ax1.XTick = [1 2 3];
ax1.XTickLabel = {'Locked','\itad-lib','Minimal'};
ax1.YAxis.MinorTick = 'on';

%% Subplot 2 - ad-lib vs locked
ax2 = subplot(142);

%Calculate PD 
meas = aPerc(:,2); % data
[meas_pdf, x_pdf, CI95, mu] = calculatePd(meas);

% Violin plot
violinPlot(meas, meas_pdf, x_pdf, CI95, mu, 'o')

% Edit axes
xlim([0.8 1.2])
ylim([-20 20])
ax2.XTick = [];
ax2.XAxisLocation = 'origin';
ax2.YMinorTick = 'on';
ylabel('% Difference')
title('ad-lib vs. Locked')
ax2.TitleHorizontalAlignment = 'left';

text(1.05,14,{'Mean = –0.4%','Effect Size = –0.1','p = .740'},'FontSize',8)

%% Subplot 3 - ad-lib vs minimal
ax3 = subplot(143);

%Calculate PD 
meas = aPerc(:,4); % data
[meas_pdf, x_pdf, CI95, mu] = calculatePd(meas);

% Violin plot
violinPlot(meas, meas_pdf, x_pdf, CI95, mu, 'o')

% Edit axes
xlim([0.8 1.2])
ylim([-20 20])
ax3.XTick = [];
ax3.XAxisLocation = 'origin';
ax3.YMinorTick = 'on';
title('ad-lib vs. Minimal')
ax3.TitleHorizontalAlignment = 'left';

text(1.05,14,{'Mean = 5.6%','Effect Size = 1.2','p < .001'},'FontSize',8)

%% Subplot 4 - locked vs minimal
ax4 = subplot(144);

%Calculate PD 
meas = -aPerc(:,3); % data
[meas_pdf, x_pdf, CI95, mu] = calculatePd(meas);

% Violin plot
violinPlot(meas, meas_pdf, x_pdf, CI95, mu, 'o')

% Edit axes
xlim([0.8 1.2])
ylim([-20 20])
ax4.XTick = [];
ax4.XAxisLocation = 'origin';
ax4.YMinorTick = 'on';
title('Locked vs. Minimal')
ax4.TitleHorizontalAlignment = 'left';

text(1.05,14,{'Mean = 5.6%','Effect Size = 1.7','p < .001'},'FontSize',8)

%% Save figure
cd(docDir)
export_fig('fig_maxP_isb2021','-png','-cmyk','-r1200')
