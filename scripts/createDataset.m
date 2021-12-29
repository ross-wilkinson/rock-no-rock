%% Sit-Stand - Create 0D and 1D datasets (.csv)

% Condition key:
% * Posture:
%   * 1 = Seated
%   * 2 = Standing
% * Cadence:
%   * 1 = 70 RPM
%   * 2 = 120 RPM
%
% Dataset columns:
% Subject, Posture, Cadence, Measure 1, ..., Measure n
% {'crankForce','crankVelocity','crankTorque','crankPower',...
% 'jointAngle','jointVelocity','jointMoment','jointPower','EMG','EMA',CoM}

%% Create 0D dataset
df = [];

nSubjects = 19;
nConditions = 3;

measure1 = 'power';
measure2 = 'torque';
measure3 = 'cadence';

% Subjects 1-15
for subId = 1:15
    % Conditions 1-12
    for i = 3:3:12    
        if i > 9
            condition = ['c' num2str(i)];
        else
            condition = ['c0' num2str(i)];
        end

        nCycles = size(SITSTAND.(condition)(subId).(measure1),2);

        subject = ones(nCycles,1)*subId;

        switch i         
            case 3
                posture = ones(nCycles,1);
                cadence = ones(nCycles,1);
            case 6
                posture = ones(nCycles,1);
                cadence = ones(nCycles,1)*2;            
            case 9
                posture = ones(nCycles,1)*2;
                cadence = ones(nCycles,1);                        
            case 12
                posture = ones(nCycles,1)*2;
                cadence = ones(nCycles,1)*2;            
        end      

        trialInfo = [subject posture cadence];
        result1 = mean(SITSTAND.(condition)(subId).(measure1));
        result2 = mean(SITSTAND.(condition)(subId).(measure2));
        result3 = mean(SITSTAND.(condition)(subId).(measure3));
        
        newRange = length(df)+1:length(df)+nCycles;
        df(newRange,:) = [trialInfo result1' result2' result3'];
    end
end

%% Convert array to table
dfT = array2table(df, 'VariableNames',...
    {'Subject','Posture','Cadence','HipPower','KneePower','AnklePower'});

%% Write table to .csv
cd('/Users/rosswilkinson/Google Drive/projects/sit-stand/results')
writetable(dfT,'sitStand.csv')
cd('/Users/rosswilkinson/Google Drive/projects/datasets')
writetable(dfT,'sitStand.csv')

