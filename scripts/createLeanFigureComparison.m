% create lean figure

% Set directories
expDir = '/Users/rosswilkinson/Google Drive/projects/rock-no-rock';
datDir = [expDir '/data'];
resDir = [expDir '/results'];
docDir = [expDir '/docs'];

% load data
cd(datDir)
load('group_data.mat')

% create lean ensemble averages
for i = 1:19
    td1 = Tdat.leanArray(Tdat.condition == 1 & Tdat.subject == i);
    td2 = Tdat.leanArray(Tdat.condition == 2 & Tdat.subject == i);
    td3 = Tdat.leanArray(Tdat.condition == 3 & Tdat.subject == i);

    for j = 1:3
        
        if isempty(td1{j})
            td1{j} = NaN(361,1);
        end

        if isempty(td2{j})
            td2{j} = NaN(361,1);
        end

        if isempty(td3{j})
            td3{j} = NaN(361,1);
        end
    end
    
    try
        lean{1}(:,i) = mean([td1{1} td1{2} td1{3}],2,'omitnan');
        lean{2}(:,i) = mean([td2{1} td2{2} td2{3}],2,'omitnan');
        lean{3}(:,i) = mean([td3{1} td3{2} td3{3}],2,'omitnan');
    catch
        lean{1}(:,i) = NaN(361,1);
        lean{2}(:,i) = NaN(361,1);
        lean{3}(:,i) = NaN(361,1);
    end
end

% clean data
lean{1}(:,12) = -lean{1}(:,12);
lean{1} = rmoutliers(rmmissing(lean{1},2),2);

for i = 1:size(lean{1},2)
    if lean{1}(180,i) < 0
        lean{1}(:,i) = -lean{1}(:,i);
    end
end

% import hull and soden data
cd(docDir)
lean_hull = readtable('data_lean_hull.csv');
xNew = linspace(0,360,361);
hullNew = interp1(lean_hull.Var1,lean_hull.Var2,xNew,"pchip");
lean_soden = readtable('data_lean_soden.csv');
sodenNew = interp1(lean_soden.Var1,lean_soden.Var2,xNew,"pchip");

% import wilkinson data
load('/Users/rosswilkinson/Google Drive/projects/bicycle-lean-rollers/results/group_data.mat')
run createBikeLeanEnvelopes.m
lean_wilkinson = mean(S.bikeLean.c01,2,'omitnan');

figure('color','w','position',[50 0 375 200])

% ad lib
plot(mean(-lean{1},2,'omitnan'),'k','linewidth',2)
hold on
plot(lean_wilkinson,'k-')
plot(xNew,-hullNew,'k--')
plot(xNew,-sodenNew,'k:')

box off
xlim([0 380])
ylim([-12 12])
ax = gca;
ax.XAxisLocation = 'origin';
ax.XTick = 0:90:360;
xlabel('Crank angle (deg.)')
ylabel({'Lean angle (deg.)','CCW \leftrightarrow CW'})

leg = legend('\itad libitum','rollers (Wilkinson et al. 2020)','treadmill (Hull et al. 1993)','overground (Soden & Adeyefa 1979)');
leg.Box = 'off';
leg.Location = 'north';
leg.Position = [0.45 0.82 0 0];
