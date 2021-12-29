function [power,T2] = brakePower(cadence,w_hang)
%BRAKEPOWER Calculate rotary flywheel power based on crank cadence and
%hanging weight.
% 
%   INPUTS:
%       - cadence:  angular velocity of crank in rpm
%       - w_hang:   hanging weight in lbs
% 
% For those researchers without a crank-based power meter, the 
% measurement of cadence can be used to approximate the rotary 
% power of the flywheel.

% velocity of crank
v_crank = cadence * 2 * pi / 60;

% mechanical advantage of drive train
r_crank = 0.1725;
r_rear = 14;
r_front = 50;
r_wheel = 0.255;
MA = (r_crank * r_rear) / (r_wheel * r_front);

% velocity of flywheel
v_wheel = v_crank / MA;

% T1 in newtons
T1 = w_hang / 2.205 * 9.80665;

% T2 in newtons
B = deg2rad(720-60);
mu = 0.2;
T2 = T1 / exp(mu*B);

% torque on flywheel
t_wheel = (T1-T2) * r_wheel;

% power
power = t_wheel * v_wheel;

end

% MA is the mechanical advantage of the ergometer drivetrain, 
% lcrank is the length of the crank in meters, Csprocketis the 
% circumference of the rear sprocket in teeth, rflywheel is the 
% radius of the flywheel in meters, Cchainring is the 
% circumference of front chainring in teeth, flywheel is the 
% angular velocity of the flywheel in radians per sec, T2 is the 
% tension at the fixed (slack) end of the rope in newtons, T1 is 
% the tension at the hanging end of the rope in newtons,  is the 
% dynamic coefficient of friction between the rope and the 
% flywheel,  is the angle of contact between the rope and the 
% flywheel in radians, flywheel is the torque on the flywheel in 
% newton meters, Pflywheel is the rotary power of the flywheel 
% in watts. 
% 
% To compare our estimate of Pflywheel to Pcrank, we have 
% assumed a value of 0.2 for  and that the flywheel was at a 
% constant angular velocity when maximal 1-s power was produced. 
% We have included a supplementary figure showing the linear 
% regression results between Pflywheel and Pcrank. Briefly, the 
% linear regression analysis estimated an ergometer drivetrain 
% efficiency of 96.5% (r2=0.97). After accounting for drivetrain 
% efficiency, the root-mean-square-error between Pflywheel and 
% Pcranks was 44 W (4.5%). These errors were likely due to the 
% assumptions that  and chain tension were constant between 
% testing sessions.
