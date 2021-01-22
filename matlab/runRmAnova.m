function [c, statstbl, r, n2g, tbl, rm, t, cond, meanSub] = runRmAnova(Tdat, measure)
% run repeated measures one-way anova

meanSub = varfun(@(x) mean(x,'omitnan'),Tdat,'InputVariables',{measure}, ...
'GroupingVariables',{'subject','condition'});

t = table();
t.cond1 = meanSub.(strcat('Fun_',measure))(meanSub.condition == 1);
t.cond2 = meanSub.(strcat('Fun_',measure))(meanSub.condition == 2);
t.cond3 = meanSub.(strcat('Fun_',measure))(meanSub.condition == 3);

% within design
cond = table([1 2 3]','VariableNames',{'Condition'});   
% fit repeated measures model
rm = fitrm(t,'cond1-cond3~1','WithinDesign',cond);
% mean and sd
statstbl = grpstats(rm,'Condition'); % time == condition
% repeated measures analysis of variance
r = ranova(rm);
% calculate generalized eta squared
n2g = r.SumSq(1) / (r.SumSq(1) + r.SumSq(2));
% test for sphericity
tbl = mauchly(rm);
% multiple comparisons test
c = multcompare(rm, 'Condition', 'ComparisonType', 'dunn-sidak');
% calculate effect sizes for multiple comparisons
for i = 1:size(c,1)
    A = t(:,c.Condition_1(i));
    B = t(:,c.Condition_2(i));
    c.SdDiff(i) = std(A{:,1} - B{:,1},'omitnan');
end

n = statstbl.GroupCount(1);
df = n-1;
c.d_av = c.Difference ./ c.SdDiff;
c.t = c.Difference ./ c.StdErr;
c.d_z = c.t/sqrt(n);
c.g_av = c.d_av * (1-(3/(4*df-1)));
c.CL = normcdf(c.d_z);

end

