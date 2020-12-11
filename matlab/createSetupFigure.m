%% Create Figure 1 for Rock-No-Rock manuscript

%% Set directories
expDir = "/Users/rosswilkinson/Google Drive/projects/rock-no-rock";
datDir = strcat(expDir, "/data");
docDir = strcat(expDir, "/docs");

%% Load experimental setup image
cd(docDir)
filename = "fig_setup_vector_labelled.png";
A = imread(filename);

%% Load rock-no-rock data
cd(datDir)
load("group_data.mat")
mdl{14}.data(1,:) = [];

%% Create group data arrays
[x1, grpCad, grpTrq, grpPwr, grpPwr2] = deal(NaN(101,19));
[r2cad, r2trq, r2pwr] = deal(NaN(19,1));
[wgt, cad, trq, pwr] = deal(cell(19,1));
x2 = 0:0.25:25;
lb2n = 4.44822;

for i = 1:19
    switch i
        case {12,16}
        otherwise
            wgt{i} = mdl{i}.data.wgt * lb2n ./ (Tsub.mass(i) * lb2n) * 100;
            cad{i} = mdl{i}.data.cad;
            trq{i} = mdl{i}.data.trq;
            pwr{i} = mdl{i}.data.pwr;
            x1(:,i) = linspace(min(wgt{i}),max(wgt{i}),101);
            [fitCad, gofCad] = fit(wgt{i},cad{i},"poly1");
            [fitTrq, gofTrq] = fit(wgt{i},trq{i},"poly1","Lower",[-Inf 0],"Upper",[Inf 0]);
            [fitPwr, gofPwr] = fit(wgt{i},pwr{i},"poly2");
            grpCad(:,i) = fitCad(x1(:,i));
            grpTrq(:,i) = fitTrq(x1(:,i));
            grpPwr(:,i) = fitPwr(x1(:,i));
            grpPwr2(:,i) = fitPwr(x2);
            r2cad(i) = gofCad.rsquare;
            r2trq(i) = gofTrq.rsquare;
            r2pwr(i) = gofPwr.rsquare;        
    end
end

[Pmax,I] = max(grpPwr);
for i = 1:19
    Wopt(i) = x1(I(i),i);
    Copt(i) = grpCad(I(i),i);
    Topt(i) = grpTrq(I(i),i);  
end

mean_Pmax = mean(Pmax,'omitnan');
mean_Wopt = mean(Wopt,'omitnan');
mean_Copt = mean(Copt,'omitnan');
mean_Topt = mean(Topt,'omitnan');

%% Create figure (3x3) 
figure('color','w','position',[50 50 750 750])
ax1 = subplot(3,3,[1:2 4:5]);

%% Set color combination (colorbrewer2.org)
c1 = [27,158,119]/255; % green
c2 = [217, 95, 2]/255; % purple

%% A. Plot image
imshow(A(10:end-10,15:end-10,:))
title('A')
ax1.Title.HorizontalAlignment = 'left';
ax1.Title.VerticalAlignment = 'middle';
ax1.Title.Position = [-25, -25, 0];

%% B. Plot subject power v mass
subplot(3,3,3);
yyaxis left
plot(x1(:,13),grpPwr(:,13),'color',c1)
hold on
scatter(wgt{13},pwr{13},20,c1,'filled')
xlabel('Hanging weight (% b.w.)')
ylabel('Maximal 1-s power output (W)')
ax2 = gca;
ax2.XColor = 'k';
ax2.YColor = c1;
ax2.Box = 'off';
ax2.XLim = [0 max(x2)];
ax2.XTick = x2(1:20:end);
ax2.XTickLabels = x2(1:20:end);
ax2.YLim = [0 1500];
ax2.YTick = 0:300:1500;
ax2.Title.String = 'B';
ax2.Title.HorizontalAlignment = 'left';
ax2.Title.VerticalAlignment = 'middle';
ax2.Title.Position = [1, ax2.YLim(2), 0];

%% Plot Pmax and Mopt line
line([0 Wopt(13)],[Pmax(13) Pmax(13)],'color',c1,'linestyle','-.')
line([Wopt(13) Wopt(13)],[0 Pmax(13)],'color','k','linestyle','--')

%% Plot Pmax text
str = strcat("P_{max} = ", string(round(Pmax(13))), " W");
text(4,1416,str,'FontSize',8,'Color',c1)

%% C. Plot subject cadence v mass 
yyaxis right % 2nd y-axis
ax3 = gca;
plot(x1(:,13),grpCad(:,13),'color',c2)
ax3.XLim = [0 max(x2)];
ax3.YLim = [0 300];
ax3.YTick = 0:60:300;
ax3.YColor = c2;
hold on
scatter(wgt{13},cad{13},20,c2,'filled','s')
ylabel('Cadence at max. power (rpm)')

%% Plot Copt line
line([Wopt(13) max(x2)],[Copt(13) Copt(13)],'color',c2,'linestyle',':')

%% Plot Copt text
str = strcat("C_{opt} = ", string(round(Copt(13))), " rpm");
text(15.5,129,str,'FontSize',8,'Color',c2)

%% Plot Wopt text
str = strcat("W_{opt} = ", string(round(Wopt(13),1)), "%");
text(15,20,str,'FontSize',8)

%% C. Plot subject torque v mass
subplot(3,3,6);
plot(x1(:,13),grpTrq(:,13),'k')
hold on
scatter(wgt{13},trq{13},20,'k','filled','^')
xlabel('Hanging weight (% b.w.)')
ylabel('Crank torque at max. power (N\cdotm)')
xlim([0 max(x2)])
ylim([0 200])
ax4 = gca;
ax4.Box = 'off';
ax4.XTick = x2(1:20:end);
ax4.XTickLabels = x2(1:20:end);
ax4.YTick = 0:40:200;
title('C')
ax4.Title.HorizontalAlignment = 'left';
ax4.Title.VerticalAlignment = 'middle';
ax4.Title.Position = [1, ax4.YLim(2), 0];

%% Plot Topt and Wopt lines
line([Wopt(13) Wopt(13)],[0 Topt(13)],'color','k','linestyle','--')
line([0 Wopt(13)],[Topt(13) Topt(13)],'color','k','linestyle','-.')

%% Plot Topt text
str = strcat("T_{opt} = ", string(round(Topt(13))), " N\cdotm");
text(2,130,str,'FontSize',8)

%% D. Plot group power v mass
subplot(3,3,7);
plot(x1,grpPwr)
hold on
set(gca,'ColorOrderIndex',1)
for i = 1:19
    scatter(Wopt(i),Pmax(i),20,'filled')
end

xlabel('Hanging weight (% b.w.)')
ylabel('Maximal 1-s power output (W)')
ax7 = gca;
ax7.XColor = 'k';
% ax7.YColor = c1;
ax7.Box = 'off';
ax7.XLim = [0 max(x2)];
ax7.XTick = x2(1:20:end);
ax7.XTickLabels = x2(1:20:end);
ax7.YLim = [0 1500];
ax7.YTick = 0:300:1500;
ax7.Title.String = 'D';
ax7.Title.HorizontalAlignment = 'left';
ax7.Title.VerticalAlignment = 'middle';
ax7.Title.Position = [1, ax7.YLim(2), 0];

%% Plot Pmax and Wopt points and line
hold on
scatter(mean_Wopt, mean_Pmax,40,'k','filled','o')
line([mean_Wopt mean_Wopt],[0 mean_Pmax],'color','k','linestyle','--')
line([0 mean_Wopt],[mean_Pmax mean_Pmax],'color','k','linestyle','-.')

%% Plot Pmax and Wopt text
str1 = strcat("Mean P_{max} = ", string(round(mean_Pmax)), " W");
str2 = strcat("Mean W_{opt} = ", string(round(mean_Wopt,1)), "%");
text(7,1600,str1,'FontSize',8)
text(13,150,str2,'FontSize',8)

%% Plot group cadence v mass
subplot(3,3,8);
plot(x1,grpCad)
hold on
set(gca,'ColorOrderIndex',1)
for i = 1:19
    scatter(Wopt(i),Copt(i),20,'filled','s')
end

xlabel('Hanging weight (% b.w.)')
ylabel('Cadence at max. power (rpm)')
ax8 = gca;
ax8.XColor = 'k';
ax8.Box = 'off';
ax8.XLim = [0 max(x2)];
ax8.XTick = x2(1:20:end);
ax8.XTickLabels = x2(1:20:end);
ax8.YLim = [0 300];
ax8.YTick = 0:60:300;
ax8.Title.String = 'E';
ax8.Title.HorizontalAlignment = 'left';
ax8.Title.VerticalAlignment = 'middle';
ax8.Title.Position = [1, ax8.YLim(2), 0];

%% Plot Copt points and line
hold on
scatter(mean_Wopt, mean_Copt,60,'k','filled','s')
line([0 mean_Wopt],[mean_Copt mean_Copt],'color','k','linestyle','-.')

%% Plot Copt text
mean_Copt = string(round(mean(Copt,'omitnan')));
str1 = strcat("Mean C_{opt} = ", mean_Copt, " rpm");
text(7,200,str1,'FontSize',8)

%% Plot group torque v mass
ax9 = subplot(3,3,9);
plot(x1,grpTrq)
hold on
set(gca,'ColorOrderIndex',1)
for i = 1:19
    scatter(Wopt(i),Topt(i),20,'filled','^')
end

xlabel('Hanging weight (% b.w.)')
ylabel('Crank torque at max. power (N\cdotm)')
xlim([0 max(x2)])
ylim([0 200])
ax9.Box = 'off';
ax9.XTick = x2(1:20:end);
ax9.XTickLabels = x2(1:20:end);
ax9.YTick = 0:40:200;
title('F')
ax9.Title.HorizontalAlignment = 'left';
ax9.Title.VerticalAlignment = 'middle';
ax9.Title.Position = [1, ax9.YLim(2), 0];

%% Plot Topt points and line
hold on
scatter(mean_Wopt, mean_Topt,40,'k','filled','^')
line([0 mean_Wopt],[mean_Topt mean_Topt],'color','k','linestyle','-.')

%% Plot Topt text
mean_Topt = string(round(mean(Topt,'omitnan')));
str2 = strcat("Mean T_{opt} = ", mean_Topt, " N\cdotm");
text(7,170,str2,'FontSize',8)
