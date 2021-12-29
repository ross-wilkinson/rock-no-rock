% Plot time series of power output and lean angle

subplot(311)
% plot(T_.tP{1}.watts)
% hold on
t = seconds( (1:numel(T_.tP{1}.watts))/500 );
plot(t,T_.tP{1}.watts)
box off
ylabel('Power output (W)')
% plot(T_.tP{7}.watts)
subplot(312)
% plot(T_.tC{1}.acc)
% hold on
t = seconds( (1:numel(T_.tC{1}.acc))/500 );
plot(t,T_.tC{1}.acc)
box off
ylabel('Crank radial acceleration (m/s^2)')
% plot(T_.tC{7}.acc)
subplot(313)
% plot(T_.tF{1}.thetaPos)
% hold on
t = seconds( (1:numel(T_.tF{1}.thetaPos))/500 );
plot(t,T_.tF{1}.thetaPos)
box off
ylabel('Lean angle (deg)')
% plot(T_.tF{7}.thetaPos)