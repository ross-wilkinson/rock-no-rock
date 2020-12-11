function tP = calculateFlywheelFriction(wgt,cad,pwr)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

tP = table();
tP.wgt = wgt;
tP.cad = cad;
tP.pwr = pwr;

tP.trq = tP.pwr ./ (tP.cad / 60 * (2*pi));

g = 9.80665;
lb2kg = 2.205;
r_crank = 0.1725;
r_rear = 16;
r_front = 50;
r_wheel = 0.300;
MA = (r_crank * r_rear) / (r_wheel * r_front);

for i = 1:numel(tP.wgt)
    syms x    
    Fout = (tP.wgt(i) / lb2kg) * g * x;
    Fin = (tP.trq(i) / r_crank);
    eqn = MA == Fout / Fin;
    tP.mu(i) = double(solve(eqn,x));
end

fprintf('Estimated coefficient of friction on flywheel = %4.1f \n', mean(tP.mu))

end

