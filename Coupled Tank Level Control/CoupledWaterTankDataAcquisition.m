clc; clear;
%% PI Controller
i = 1;
input = 7; %centimeters
figure(1)
for file = ["PI_0_001.mat", "PI_0_01.mat", "PI_0_05.mat", "PI_0_3.mat", "PI_1_5.mat", "PI_5.mat", "PI_10.mat"]
    graphTitle = ["0.001" "0.01" "0.05" "0.3" "1.5" "5" "10"];
    load(file);
    t=simout.time;
    y=simout.Data;
    final_output=y(end);
    subplot(4,2,i)
    hold on
    plot(t,y)
    plot(t, 7*ones(length(t)), 'r:')
    title(["PI Gain of 1 & " + graphTitle(i) "(Respectively)"])
    ylabel("Height (cm)")
    xlabel("Time (s)")
    s = stepinfo(y, t, final_output);
    pos = 1;
    for l = 1:length(y)
        if(y(l) >= y(end)*0.9)
            break;
        end
        pos = pos + 1;
    end
    arr(i,1) = t(pos);
    [~, maxi] = max(y);
    arr(i,2) = t(maxi);
    arr(i,3) = s.SettlingTime;
    arr(i,4) = s.Overshoot;
    arr(i,5) = (input - final_output)/input*100;
    i=i+1;
end

%% PID controller
input = 7; %centimeters
figure(2)
k=9;
i=1;
for file = ["PID_0.mat", "PID_0_001.mat", "PID_0_04.mat", "PID_0_05.mat", "PID_0_2.mat"]
    graphTitle = ["0" "0.001" "0.04" "0.05" "0.2"];
    load(file);
    t=simout.time;
    y=simout.Data;
    final_output=y(end);
    subplot(3,2,i)
    hold on
    plot(t,y)
    plot(t, 7*ones(length(t)), 'r:')
    title(["PID Gain of 1, 0.1, & " + graphTitle(i) "(Respectively)"])
    ylabel("Height (cm)")
    xlabel("Time (s)")
    s = stepinfo(y, t, final_output);
    pos = 1;
    for l = 1:length(y) % loop to calculate rise time
        if(y(l) >= y(end)*0.9)
            break;
        end
        pos = pos + 1;
    end
    arr(k,1) = t(pos); % Rise time
    [~, maxi] = max(y); % finding max value's index
    arr(k,2) = t(maxi); % assigning peak time from max value index
    arr(k,3) = s.SettlingTime;
    arr(k,4) = s.Overshoot;
    arr(k,5) = (input - final_output)/input*100; % steady state error
    i=i+1;
    k=k+1;
end