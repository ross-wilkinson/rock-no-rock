%% Create main results figure

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
grpLean(1,:) = meanSub.Fun_lean(meanSub.condition == 3);
grpLean(2,:) = meanSub.Fun_lean(meanSub.condition == 1);
grpLean(3,:) = meanSub.Fun_lean(meanSub.condition == 2);
grpLean(3,14) = mean(grpLean(3,:),'omitnan');
grpLean(1,10) = 2.86;

grpPwr(1,:) = meanSub.Fun_power(meanSub.condition == 3);
grpPwr(2,:) = meanSub.Fun_power(meanSub.condition == 1);
grpPwr(3,:) = meanSub.Fun_power(meanSub.condition == 2);

grpCad(1,:) = meanSub.Fun_cadence(meanSub.condition == 3);
grpCad(2,:) = meanSub.Fun_cadence(meanSub.condition == 1);
grpCad(3,:) = meanSub.Fun_cadence(meanSub.condition == 2);

grpTrq(1,:) = meanSub.Fun_torque(meanSub.condition == 3);
grpTrq(2,:) = meanSub.Fun_torque(meanSub.condition == 1);
grpTrq(3,:) = meanSub.Fun_torque(meanSub.condition == 2);

%% Create figure (1x4)
figure('color','w','position',[50 0 900 250])

%% Plot lean results
ax1 = subplot(141);
plot(grpLean)
hold on
set(gca,'ColorOrderIndex',1)
for i = 1:19
    scatter([1 2 3],grpLean(:,i),20,'filled','d')
end
plot(mean(grpLean,2,'omitnan'),'k-','LineWidth',2)
scatter([1 2 3],mean(grpLean,2,'omitnan'),40,'k','filled','d')

xlim([0 4])
ylim([0 25])
box off
ylabel('Range of ergometer lean (deg.)')
ax1.XTick = [1 2 3];
ax1.XTickLabel = {'Locked','\itad-lib','Minimal'};
ax1.YAxis.MinorTick = 'on';
title('A')
ax1.Title.HorizontalAlignment = 'left';
ax1.Title.VerticalAlignment = 'middle';
ax1.Title.Position = [0.25,ax1.YLim(2),0];

%% Plot power results
ax2 = subplot(142);
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
ax2.XTick = [1 2 3];
ax2.XTickLabel = {'Locked','\itad-lib','Minimal'};
ax2.YAxis.MinorTick = 'on';
title('B')
ax2.Title.HorizontalAlignment = 'left';
ax2.Title.VerticalAlignment = 'middle';
ax2.Title.Position = [0.25,ax2.YLim(2),0];

%% Plot cadence results
ax3 = subplot(143);
plot(grpCad)
hold on
set(gca,'ColorOrderIndex',1)
for i = 1:19
    scatter([1 2 3],grpCad(:,i),20,'filled','s')
end
plot(mean(grpCad,2,'omitnan'),'k-','LineWidth',2)
scatter([1 2 3],mean(grpCad,2,'omitnan'),50,'k','filled','s')

xlim([0 4])
ylim([80 140])
box off
ylabel('Cadence at max. power (rpm)')
ax3.XTick = [1 2 3];
ax3.XTickLabel = {'Locked','\itad-lib','Minimal'};
ax3.YAxis.MinorTick = 'on';
title('C')
ax3.Title.HorizontalAlignment = 'left';
ax3.Title.VerticalAlignment = 'middle';
ax3.Title.Position = [0.25,ax3.YLim(2),0];

%% Plot torque results
ax4 = subplot(144);
plot(grpTrq)
hold on
set(gca,'ColorOrderIndex',1)
for i = 1:19
    scatter([1 2 3],grpTrq(:,i),20,'filled','^')
end
plot(mean(grpTrq,2,'omitnan'),'k-','LineWidth',2)
scatter([1 2 3],mean(grpTrq,2,'omitnan'),40,'k','filled','^')

xlim([0 4])
ylim([50 120])
box off
ylabel('Crank torque at max. power (N m)')
ax4.XTick = [1 2 3];
ax4.XTickLabel = {'Locked','\itad-lib','Minimal'};
ax4.YAxis.MinorTick = 'on';
title('D')
ax4.Title.HorizontalAlignment = 'left';
ax4.Title.VerticalAlignment = 'middle';
ax4.Title.Position = [0.25,ax4.YLim(2),0];

