function [leanAngle, leanRange, leanArray, tP_, tF_, tC_] = calculateLeanAngle(tP,tF,tC)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Sync Garmin and IMU data
% convert imu accelerations into resultant acceleration

x = tC.accel_x_m_s2_; % vertical axis
y = tC.accel_y_m_s2_;
z = tC.accel_z_m_s2_;
tC.accel_res = sqrt(x.^2 + y.^2 + z.^2);

x = tF.accel_x_m_s2_; % vertical axis
y = tF.accel_y_m_s2_;
z = tF.accel_z_m_s2_;
tF.accel_res = sqrt(x.^2 + y.^2 + z.^2);

% Find sync spike in crank and frame IMU
[~,syncC] = findpeaks(tC.accel_res,'minPeakHeight',50,"NPeaks",1);
[~,syncF] = findpeaks(tF.accel_res,'minPeakHeight',50,"NPeaks",1);

% Crop signals to sync spike
tC_ = tC(syncC:end,:);
tF_ = tF(syncF:end,:);
tC_.timestamp = tC_.timestamp - tC_.timestamp(1);
tF_.timestamp = tF_.timestamp - tF_.timestamp(1);

% Lowpass filter acceleration signal of crank x axis (vertical axis) and
% frame y axis (medio-lateral axis)
freq = 500;
pass = 2;
tC_.accel_x_m_s2_ = lowpass(tC_.accel_x_m_s2_,pass,freq);
tF_.accel_y_m_s2_ = lowpass(tF_.accel_y_m_s2_,pass,freq);

% Interpolate power data to match IMU sampling frequency
x = 0:height(tP)-1;
v = table2array(tP);
xq = 0:1/500:height(tP)-1;
temp = interp1(x',v,xq',"linear");
tP_ = array2table(temp,"VariableNames",tP.Properties.VariableNames);

% Crop all signals to when power is being produced
k = tP_.watts > 0;
t1 = min(tP_.secs(k));
t2 = max(tP_.secs(k));

tP_ = tP_(k,:);
tC_ = tC_(tC_.timestamp > t1 & tC_.timestamp < t2,:);
tF_ = tF_(tF_.timestamp > t1 & tF_.timestamp < t2,:);

% Check if IMU data is empty due to poor sync


% Smooth frame acceleration signal in y-axis.
dt = 1/500;
window = 50; % 100 ms
acc = smoothdata(tF_.accel_y_m_s2_,'gaussian',window);

% Detrend frame acceleration signal
acc = detrend(acc);

% Convert to angular acceleration.
r = 0.53; % height of IMU above pivot in meters
acc = rad2deg(acc./r); % deg/s^2

% Differentiate to angular displacement.
vel = cumtrapz(acc)*dt;
vel = smoothdata(vel,'gaussian',window);
%vel = interp1(1:length(vel),vel,1:length(vel)/(length(acc)+1):length(vel));
dvel = vel-mean(vel);
pos = cumtrapz(dvel)*dt;
pos = smoothdata(pos,'gaussian',window);
%pos = interp1(1:length(pos),pos,1:length(pos)/(length(vel)+1):length(pos));

% Detrend frame position signal (nonlinear)
t = 1:numel(pos);
pos_nl = pos';
opol = 12;
[p,~,mu] = polyfit(t,pos_nl,opol);
f_y = polyval(p,t,[],mu);
dt_pos = pos_nl - f_y;

% Store angular displacement in table
tF_.thetaAcc = acc;
tF_.thetaVel = vel;
tF_.thetaPos = dt_pos';

% Smooth crank acceleration signal
accC = smoothdata(tC_.accel_x_m_s2_,'gaussian',window);

% Detrend crank acceleration signal (nonlinear)
t = 1:numel(accC);
acc_nl = accC';
opol = 6;
[p,~,mu] = polyfit(t,acc_nl,opol);
f_y = polyval(p,t,[],mu);
dt_acc = acc_nl - f_y;
tC_.acc = dt_acc';

% Find peaks in crank signal
[~,locs] = findpeaks(tC_.acc,"MinPeakProminence",5,"MinPeakDistance",150);

% Calculate range of bicycle lean during each crank cycle
for i = 1:numel(locs)-1
    a = detrend(tF_.thetaPos(locs(i):locs(i+1)));
%     a = tF_.thetaPos(locs(i):locs(i+1));
    a = interp1(1/length(a):1/length(a):1,a,1/length(a):1/362:1);
    leanArray(:,i) = a(1:361);
    leanRange(i) = range(a);
end

leanRange = rmoutliers(leanRange);
leanAngle = max(leanRange);

end

