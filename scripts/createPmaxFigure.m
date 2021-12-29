% create Pmax figure

% initialize script
clear;clc;close all

% load data
datDir = '/Users/rosswilkinson/Google Drive/projects/rock-no-rock/data';
load([datDir '/group_data.mat'])

% set exemplar subject
sub = 13;

% calculate mass-torque-power-cadence relationship for subject
lim = 300;
cad = 0:lim;
trq = mdl{sub}.c1(cad);
vel = (cad / 60 * (2*pi))';
pwr = trq .* vel;

% find optimal x and y
[maxPwr,optCad] = max(pwr);

% calculate mechanical advantage of drivetrain
g = 9.80665;
lb2kg = 2.205;
r_crank = 0.1725;
r_rear = 18;
r_front = 50;
r_wheel = 0.275;
MA = (r_crank * r_rear) / (r_wheel * r_front);

% calculate hanging mass at 250 Nm and optimal hanging mass
maxHang = MA * (lim/r_crank) / g;
hang = MA * (trq/r_crank) / g;
optHang = hang(optCad);

figure('color','w','position',[300 300 600 500])

% subject cad v trq
ax1 = subplot(221);
yyaxis left
scatter(mdl{sub}.data.cad,mdl{sub}.data.trq,10,'k','filled')
hold on
xlim([0 lim])
ylim([0 lim])
plot(trq,'k-')
legend off
xlabel('Cadence (rpm)')
ylabel('Torque (Nm)')
set(gca,'YColor','k')
title('A')
ax1.Title.HorizontalAlignment = 'left';
ax1.Title.VerticalAlignment = 'middle';
ax1.Title.Position = [10, ax1.YLim(2), 0];

str1 = strcat("R^2 = ", string(round(mdl{sub}.gof.rsquare,2)));
str2 = strcat("RMSE = ", string(round(mdl{sub}.gof.rmse,1)));
str3 = strcat("H_{opt} = ", string(round(optHang,1)), " kg");
text(140,250,{str1,str2,str3})

yyaxis right
ylim([0 maxHang])
ylabel('Hanging mass (kg)')
set(gca,'YColor',[1 1 1]*0.5)
line([optCad lim],[optHang optHang],'Color',[1 1 1]*0.5,'LineStyle','-')

% subject cad v pwr
ax2 = subplot(222);
line([optCad optCad],[0 maxPwr],'Color',[1 1 1]*0.5,'LineStyle','-')
hold on
line([0 optCad],[maxPwr maxPwr],'Color',[1 1 1]*0.5,'LineStyle','-')
scatter(mdl{sub}.data.cad,mdl{sub}.data.pwr,10,'k','filled')
xlim([0 lim])
ylim([0 2000])
plot(cad,pwr,'k')
legend off
xlabel('Cadence (rpm)')
ylabel('Power output (W)')
title('B')
ax2.Title.HorizontalAlignment = 'left';
ax2.Title.VerticalAlignment = 'middle';
ax2.Title.Position = [10, ax2.YLim(2), 0];

str1 = strcat("P_{max} = ", string(round(maxPwr,1)), " W");
str2 = strcat("C_{opt} = ", string(round(optCad,1)), " rpm");
text(140,1600,{str1,str2})

% group cad v trq
ax3 = subplot(223);

yyaxis right
for i = 1:19
    line([mdl{i}.optCad lim],[mdl{i}.optHang mdl{i}.optHang],'Color',[1 1 1]*0.5,'LineStyle','-')
    hold on
end
ylim([0 maxHang])
ylabel('Hanging mass (kg)')
set(gca,'YColor',[1 1 1]*0.5)

yyaxis left
for i = 1:19
    scatter(mdl{i}.data.cad,mdl{i}.data.trq,10,'k','filled')
    hold on
    xlim([0 lim])
    ylim([0 lim])
    trq = mdl{i}.c1(cad);
    plot(trq,'k-')
end

legend off
xlabel('Cadence (rpm)')
ylabel('Torque (Nm)')
set(gca,'YColor','k')
title('C')
ax3.Title.HorizontalAlignment = 'left';
ax3.Title.VerticalAlignment = 'middle';
ax3.Title.Position = [10, ax3.YLim(2), 0];

for i = 1:19
    rsq(i) = mdl{i}.gof.rsquare; 
    rmse(i) = mdl{i}.gof.rmse;
    Hopt(i) = mdl{i}.optHang;
    Pmax(i) = mdl{i}.maxPower;
    Vopt(i) = mdl{i}.optCad;
end

str1 = strcat("Mean R^2 = ", string(round(mean(rmoutliers(rsq)),2)));
str2 = strcat("Mean RMSE = ", string(round(mean(rmoutliers(rmse)),1)));
str3 = strcat("Mean H_{opt} = ", string(round(mean(Hopt),1)), " kg");
text(140,250,{str1,str2,str3})

% group cad v pwr
ax4 = subplot(224);

for i = 1:19
    line([mdl{i}.optCad mdl{i}.optCad],[0 mdl{i}.maxPower],'Color',[1 1 1]*0.5,'LineStyle','-')
    hold on
    line([0 mdl{i}.optCad],[mdl{i}.maxPower mdl{i}.maxPower],'Color',[1 1 1]*0.5,'LineStyle','-')
end

for i = 1:19
    scatter(mdl{i}.data.cad,mdl{i}.data.pwr,10,'k','filled')
    xlim([0 lim])
    ylim([0 2000])
    trq = mdl{i}.c1(cad);
    pwr = trq .* vel;
    plot(pwr,'k-')
end

legend off
xlabel('Cadence (rpm)')
ylabel('Power output (W)')
title('D')
ax4.Title.HorizontalAlignment = 'left';
ax4.Title.VerticalAlignment = 'middle';
ax4.Title.Position = [10, ax4.YLim(2), 0];

str1 = strcat("Mean P_{max} = ", string(round(mean(Pmax),1)), " W");
str2 = strcat("Mean C_{opt} = ", string(round(mean(Vopt),1)), " rpm");
text(140,1600,{str1,str2})

annotatePmaxFigure(gcf)

