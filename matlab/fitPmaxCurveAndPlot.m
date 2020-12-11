function f = fitPmaxCurveAndPlot(wgt,cad,pwr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    tP.wgt = wgt;
    tP.cad = cad;
    tP.pwr = pwr;
    
    tP.trq = tP.pwr ./ (tP.cad / 60 * (2*pi));
    tP.tan = tP.trq / 0.1725;
       
    % fit curve: cad vs trq
    [c1, gof] = fit(tP.cad,tP.trq,'poly1','Lower',[-1.1 -Inf],'Upper',[-0.6 Inf]);
    
    % fit curve: cad vs pwr
    % [c2, ~, ~] = fit([0; tP.cad],[0; tP.pwr],'poly3','Lower',[-Inf -Inf -Inf 0],'Upper',[Inf Inf Inf 0]);
    x = 0:250;
    trq = c1(x);
    vel = (x / 60 * (2*pi))';
    pwr = trq .* vel;
    
    set(gcf,'color','w','position',[300 300 644 230])
    % cad v trq
    subplot(121)
    yyaxis left
    scatter(tP.cad,tP.trq,10,'k','filled')
    hold on
    xlim([0 250])
    ylim([0 250])
    plot(c1,'k-')
    legend off
    xlabel('Cadence (rpm)')
    ylabel('Crank torque (Nm)')
    set(gca,'YColor','k')
    
    % calculate mechanical advantage of drivetrain
    g = 9.80665;
    lb2kg = 2.205;
    r_crank = 0.1725;
    r_rear = 16;
    r_front = 50;
    r_wheel = 0.300;
    MA = (r_crank * r_rear) / (r_wheel * r_front);
    
    Mhang = MA * (250/r_crank) / g;
    yyaxis right
    ylim([0 Mhang])
    ylabel('Hanging mass (kg)')
    set(gca,'YColor',[1 1 1]*0.5)
    
    % cad v pwr
    subplot(122)
    scatter(tP.cad,tP.pwr,10,'k','filled')
    hold on
    xlim([0 250])
    ylim([0 2000])
    plot(0:250,pwr,'k')
    legend off
    xlabel('Cadence (rpm)')
    ylabel('Power output (W)')
    
    % find optimal x and y
    [yOpt,xOpt] = max(pwr);
    
    temp = MA * (feval(c1,0:250)/r_crank) / g;
    fprintf('Predicted maximal power output = %4.1f Watts \n', yOpt)
    fprintf('Predicted optimal cadence = %4.1f rpm \n', xOpt)
    fprintf('Predicted optimal hanging mass = %4.1f kg (%4.1f lb) \n', temp(xOpt),temp(xOpt)*lb2kg)
    line([xOpt xOpt],[0 yOpt],'Color','k','LineStyle','-')
    subplot(121)
    yyaxis right
    line([xOpt 250],[temp(xOpt) temp(xOpt)],'Color',[1 1 1]*0.5,'LineStyle','-')
    hold on
    
    f.c1 = c1;
    f.gof = gof;
    f.maxPower = yOpt;
    f.optCad = xOpt;
    f.optHang = temp(xOpt);
    f.maxTorque = max(trq);

end

