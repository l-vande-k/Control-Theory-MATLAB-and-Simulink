clc;

% original state space model

A = [0, 1; 0, -0.5696];
B = [0; 1];
C = [0.07843, 0];
D = 0;

% -------------------------- Calculating the Controller Gains --------------------------

PercentOvershoot = 0.25;
SettlingTime = 1;
DampingRatio = (-log(PercentOvershoot)/sqrt(3.14159^2+log(PercentOvershoot)^2))
NaturalFrequency = 4/(DampingRatio*SettlingTime)

syms k1 k2 k3 s
multiplier = 1;
pole_1 = multiplier*(-DampingRatio*NaturalFrequency) + 1i*NaturalFrequency*sqrt(1-DampingRatio^2);
pole_2 = multiplier*(-DampingRatio*NaturalFrequency) - 1i*NaturalFrequency*sqrt(1-DampingRatio^2);
CE_1 = ((s - pole_1)*(s - pole_2));
CE_1 = vpa(expand(CE_1),6)

Ac = A - B*[k1 k2]
CE_2 = det(s*eye(2) - Ac);
CE_2 = vpa(CE_2)

% compare CE's manually to yield:

K1 = 98.169
K2 = 8.0 - 0.5696

% -------------------------- Calculating the Observer Gains --------------------------

syms L1 L2

multiplier = 10;
pole_1 = multiplier*((-DampingRatio*NaturalFrequency) + 1i*NaturalFrequency*sqrt(1-DampingRatio^2));
pole_2 = multiplier*((-DampingRatio*NaturalFrequency) - 1i*NaturalFrequency*sqrt(1-DampingRatio^2));
CE_1 = (s - pole_1)*(s - pole_2);
CE_1 = vpa(expand(CE_1),8)

Ao = [0 1; 0 -0.5696];
Bo = [0; 1];
Co = [0.07843 0];
Do = 0;
L = [L1; L2];

CE_2 = det(s*eye(2) - (Ao - L*Co));
vpa(CE_2)

% compare CE's manually to yield:


L1 = (80-0.5696)/0.07843
L2 = 9816.9015/0.07843

% -------------------------- Calculating the Integrator Gains --------------------------

clear("k1", "k2");
syms k1 k2 ke 

multiplier = 1;
%pole_multiplier = 10.389;
pole_multiplier = 10;
pole_1 = multiplier*(-DampingRatio*NaturalFrequency) + 1i*NaturalFrequency*sqrt(1-DampingRatio^2)
pole_2 = multiplier*(-DampingRatio*NaturalFrequency) - 1i*NaturalFrequency*sqrt(1-DampingRatio^2)
pole_3 = pole_multiplier*real(pole_1) % this makes the third pole a function of the other two
CE_1 = ((s - pole_1)*(s - pole_2))*(s - pole_3)
CE_1 = vpa(expand(CE_1),8)

K = [k1, k2];
Aic = [A-B*K B*ke; -C 0];
CE_2 = det(s*eye(3) - Aic);
CE_2 = vpa(CE_2, 8)

% compare CE's manually to yield:
 
ke = 3926.7606/0.07843
k1 = 418.169
k2 = 48 - 0.5696

%% Checking the % overshoot
clc; clear;

disp("Simulation 1")
load("simulation1.mat")
output = squeeze(out.simout.Data(1,2,:));
sim1Data = stepinfo(output, out.tout)
sim1Ess = (abs(1-output(end))/1)*100

disp("Simulation 2")
load("simulation2.mat")
output = squeeze(out.simout.Data(1,2,:));
sim2Data = stepinfo(output, out.tout)
sim2Ess = (abs(1-output(end))/1)*100

disp("Simulation 3")
load("simulation3.mat")
output = out.simout.Data;
sim3Data = stepinfo(output, out.tout)
sim3Ess = (abs(1-output(end))/1)*100

disp("Simulation 4")
load("simulation4.mat")
output = out.simout.Data;
sim4Data = stepinfo(output, out.tout)
sim4Ess = (abs(1-output(end))/1)*100
