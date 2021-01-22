%% Compare crank power to flywheel power

% set subject cadence and hanging weights
w_crank = meanSub.Fun_cadence(meanSub.condition == 3);
T_1 = meanSub.Fun_hangingWeight(meanSub.condition == 3);

%% no adjustment
for i = 1:numel(w_crank)
    [P_fly(i),T_2(i)] = brakePower(w_crank(i),T_1(i));
end

% calculate drivetrain efficiency
P_crank = meanSub.Fun_power(meanSub.condition == 3)';
E_dt = P_fly ./ P_crank;

%% grouped adjustments
adj = ones(1,19)*2.5;

for i = 1:numel(w_crank)
    switch i
        case {1,3,6,9,10,11,12,17,18,19}
            T_1(i) = T_1(i)-adj(i);
        case {2,4,5,7,8,13,15,16}
            adj(i) = 5;
            T_1(i) = T_1(i)-adj(i);
        case 14
            adj(i) = 0;
            T_1(i) = T_1(i)-adj(i);
    end
    [P_fly(i),T_2(i)] = brakePower(w_crank(i),T_1(i));
end

% calculate drivetrain efficiency
P_crank = meanSub.Fun_power(meanSub.condition == 3)';
E_dt = P_fly ./ P_crank;

%% individual adjustments
% adj = ones(1,19)*2;
% 
% for i = 1:numel(w_crank)
%     switch i
%         case {1,6,17,18,19}
%             T_1(i) = T_1(i)-adj(i);
%         case {2,15,16}
%             adj(i) = 4.5;
%             T_1(i) = T_1(i)-adj(i);
%         case 3
%             adj(i) = 3;
%             T_1(i) = T_1(i)-adj(i);
%         case {4,5}
%             adj(i) = 4;
%             T_1(i) = T_1(i)-adj(i);
%         case {7,8,13}
%             adj(i) = 5;
%             T_1(i) = T_1(i)-adj(i);
%         case 9
%             adj(i) = 2.5;
%             T_1(i) = T_1(i)-adj(i);
%         case {10,11,12}
%             adj(i) = 3.5;
%             T_1(i) = T_1(i)-adj(i);
%         case 14
%             adj(i) = 0.5;
%             T_1(i) = T_1(i)-adj(i);
%     end
%     [P_fly(i),T_2(i)] = brakePower(w_crank(i),T_1(i));
% end
% 
% P_crank = meanSub.Fun_power(meanSub.condition == 3)';
% E_dt = P_fly ./ P_crank;

