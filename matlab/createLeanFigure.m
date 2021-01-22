%% Create lean figure

%% Set directories
expDir = '/Users/rosswilkinson/Google Drive/projects/rock-no-rock';
datDir = [expDir '/data'];
resDir = [expDir '/results'];
docDir = [expDir '/docs'];

%% load data
cd(datDir)
load('group_data.mat')

%% Extract subject data

[adlib, minimal, locked] = deal(cell(19,1));

nA = 0;
nM = 0;
nL = 0;

for sub = 1:19
    
adlib{sub} = Tdat.leanArray(Tdat.condition == 1 & Tdat.subject == sub);

switch sub
    case {5,7,10,14,16,17,18,19}
        adlib{sub} = cellfun(@(x) -x, adlib{sub},'UniformOutput',0);
    case {9,11} 
        adlib{sub}{2} = -adlib{sub}{2};
end

adlib{sub}{4} = [adlib{sub}{~cellfun(@isempty,adlib{sub})}];
idx = isoutlier(range(adlib{sub}{4}));
adlib{sub}{4}(:,idx) = [];

nA = nA + size(adlib{sub}{4},2);

minimal{sub} = Tdat.leanArray(Tdat.condition == 2 & Tdat.subject == sub);
minimal{sub}{4} = [minimal{sub}{~cellfun(@isempty,minimal{sub})}];
idx = isoutlier(range(minimal{sub}{4}));
minimal{sub}{4}(:,idx) = [];

nM = nM + size(minimal{sub}{4},2);

locked{sub} = Tdat.leanArray(Tdat.condition == 3 & Tdat.subject == sub);
locked{sub}{4} = -[locked{sub}{~cellfun(@isempty,locked{sub})}];
idx = isoutlier(range(locked{sub}{4}));
locked{sub}{4}(:,idx) = [];

nL = nL + size(locked{sub}{4},2);

end

%% Create figure
% figure('color','w','position',[50 0 900 450])
figure('color','w','position',[50 0 900 250])
c1 = [1 1 1]*0.75;

%% Plot locked
% subplot(231)
subplot(131)
for sub = 1:19    
    plot(locked{sub}{4},'color',c1)
    hold on
end

grpLocked = NaN(361,15);

for sub = 5:19
    plot(mean(locked{sub}{4},2,'omitnan'),'linewidth',1)
    grpLocked(:,sub) = mean(locked{sub}{4},2,'omitnan');
end

plot(mean(grpLocked,2,'omitnan'),'k','linewidth',3);

str = strcat('n_{cycles}=', string(nL));
text(15,-12,str)

box off
xlim([0 360])
ylim([-15 15])
ax1 = gca;
ax1.XTick = 0:90:360;
ax1.YTick = -15:3:15;
ax1.YAxis.MinorTick = 'on';
ax1.YAxis.MinorTickValues = -15:1:15;
xlabel({'Right crank angle (deg.)','TDC to TDC'})
ylabel({'Lean angle (deg.)','CCW \leftrightarrow CW'})
title('A. \rmLocked')
ax1.Title.HorizontalAlignment = 'left';
ax1.Title.VerticalAlignment = 'middle';
ax1.Title.Position = [15, ax1.YLim(2), 0];

%% Plot ad-lib
% subplot(232)
subplot(132)
for sub = 1:19    
    plot(adlib{sub}{4},'color',c1)
    hold on
end

grpAdlib = NaN(361,15);

for sub = 5:19
    plot(mean(adlib{sub}{4},2,'omitnan'),'linewidth',1)
    grpAdlib(:,sub) = mean(adlib{sub}{4},2,'omitnan');
end

plot(mean(grpAdlib,2,'omitnan'),'k','linewidth',3);

str = strcat('n_{cycles}=', string(nA));
text(15,-12,str)

box off
xlim([0 360])
ylim([-15 15])
ax1 = gca;
ax1.XTick = 0:90:360;
ax1.YTick = -15:3:15;
ax1.YAxis.MinorTick = 'on';
ax1.YAxis.MinorTickValues = -15:1:15;
xlabel({'Right crank angle (deg.)','TDC to TDC'})
ylabel({'Lean angle (deg.)','CCW \leftrightarrow CW'})
title('B. \rm\itad libitum')
ax1.Title.HorizontalAlignment = 'left';
ax1.Title.VerticalAlignment = 'middle';
ax1.Title.Position = [15, ax1.YLim(2), 0];

%% Plot minimal
% subplot(233)
subplot(133)
for sub = 1:19    
    plot(minimal{sub}{4},'color',c1)
    hold on
end

grpMinimal = NaN(361,15);

for sub = [5:13 15:19]
    plot(mean(minimal{sub}{4},2,'omitnan'),'linewidth',1)
    grpMinimal(:,sub) = mean(minimal{sub}{4},2,'omitnan');
end

plot(mean(grpMinimal,2,'omitnan'),'k','linewidth',3);

str = strcat('n_{cycles}=', string(nM));
text(15,-12,str)

box off
xlim([0 360])
ylim([-15 15])
ax1 = gca;
ax1.XTick = 0:90:360;
ax1.YTick = -15:3:15;
ax1.YAxis.MinorTick = 'on';
ax1.YAxis.MinorTickValues = -15:1:15;
xlabel({'Right crank angle (deg.)','TDC to TDC'})
ylabel({'Lean angle (deg.)','CCW \leftrightarrow CW'})
title('C. \rmMinimal')
ax1.Title.HorizontalAlignment = 'left';
ax1.Title.VerticalAlignment = 'middle';
ax1.Title.Position = [15, ax1.YLim(2), 0];

%% Check for nan values
% idx = isnan(grpMinimal);
% 
% grpLocked(idx) = [];
% grpAdlib(idx) = [];
% grpMinimal(idx) = [];
% Y1 = reshape(grpLocked,361,[])';
% Y2 = reshape(grpAdlib,361,[])';
% Y3 = reshape(grpMinimal,361,[])';
% 
% %% Run SPM analysis
% t21        = spm1d.stats.ttest_paired(Y2, Y1);
% t23        = spm1d.stats.ttest_paired(Y2, Y3);
% t31        = spm1d.stats.ttest_paired(Y3, Y1);
% 
% alpha      = 0.05;
% nTests     = 3;
% p_critical = spm1d.util.p_critical_bonf(alpha, nTests);
% t21i       = t21.inference(p_critical, 'two_tailed', true, 'interp',true);
% t23i       = t23.inference(p_critical, 'two_tailed', true, 'interp',true);
% t31i       = t31.inference(p_critical, 'two_tailed', true, 'interp',true);
% 
% disp(t21i)
% disp(t23i)
% disp(t31i)
% 
% %% Plot SPM - Ad-lib vs Locked
% subplot(234); 
% t21i.plot(); 
% xlim([0 360])
% ylim([-10 10]); 
% title('D. \rm\itad-lib vs \rmLocked');
% ax1 = gca;
% ax1.XTick = 0:90:360;
% xlabel({'Right crank angle (deg.)','TDC to TDC'})
% ax1.Title.HorizontalAlignment = 'left';
% ax1.Title.VerticalAlignment = 'middle';
% ax1.Title.Position = [15, ax1.YLim(2), 0];
% 
% str1 = 'p<0.001';
% x1 = t21i.clusters{1}.xy(1);
% y1 = t21i.clusters{1}.xy(2)+2;
% text(x1,y1,str1)
% 
% str2 = 'p<0.001';
% x2 = t21i.clusters{2}.xy(1);
% y2 = t21i.clusters{2}.xy(2)-2;
% text(x2,y2,str2)
% 
% str3 = 'p<0.001';
% x3 = t21i.clusters{3}.xy(1);
% y3 = t21i.clusters{3}.xy(2)+2;
% text(x3,y3,str3)
% 
% str4 = '{\alpha}={0.02}, t*=4.234';
% x4 = 15;
% y4 = -8.5;
% text(x4,y4,str4,'color','r')
% 
% %% Plot SPM - Ad-lib vs Minimal
% subplot(235);  
% t23i.plot();
% xlim([0 360])
% ylim([-10 10]); 
% title('E. \rm\itad-lib vs \rmMinimal');
% ax1 = gca;
% ax1.XTick = 0:90:360;
% xlabel({'Right crank angle (deg.)','TDC to TDC'})
% ax1.Title.HorizontalAlignment = 'left';
% ax1.Title.VerticalAlignment = 'middle';
% ax1.Title.Position = [15, ax1.YLim(2), 0];
% 
% str1 = 'p<0.001';
% x1 = t23i.clusters{1}.xy(1);
% y1 = t23i.clusters{1}.xy(2)+2;
% text(x1,y1,str1)
% 
% str2 = 'p<0.001';
% x2 = t23i.clusters{2}.xy(1);
% y2 = t23i.clusters{2}.xy(2)-2;
% text(x2,y2,str2)
% 
% str3 = 'p<0.001';
% x3 = t23i.clusters{3}.xy(1);
% y3 = t23i.clusters{3}.xy(2)+2;
% text(x3,y3,str3)
% 
% str4 = '{\alpha}={0.02}, t*=4.234';
% x4 = 15;
% y4 = -8.5;
% text(x4,y4,str4,'color','r')
% 
% %% Plot SPM - Minimal vs Locked
% subplot(236);  
% t31i.plot();
% xlim([0 360])
% ylim([-10 10]); 
% title('F. \rmMinimal \itvs \rmLocked');
% ax1 = gca;
% ax1.XTick = 0:90:360;
% xlabel({'Right crank angle (deg.)','TDC to TDC'})
% ax1.Title.HorizontalAlignment = 'left';
% ax1.Title.VerticalAlignment = 'middle';
% ax1.Title.Position = [15, ax1.YLim(2), 0];
% 
% str4 = '{\alpha}={0.02}, t*=4.234';
% x4 = 15;
% y4 = -8.5;
% text(x4,y4,str4,'color','r')

