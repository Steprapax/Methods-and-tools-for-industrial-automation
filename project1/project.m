clc;
clear;
close all;

m1 = 1; % [kg]
m2 = 0.5; % [kg]
theta = 50; % [kg/s^2]
beta = 0.1; % [kg/s]

sample_time = 1; % tempo di campionamento
horizon = 10;

A = [0 1 0 0;
    -theta/m1 -beta/m1 theta/m1 0;
    0 0 0 1;
    theta/m2 0 -theta/m2 -beta/m2];

B = [0 1/m1 0 0]';
C = eye(4);
D = [0 0 0 0]';

sys = ss(A, B, C, D);

sysd = c2d(sys, sample_time);

A = sysd.A;
B = sysd.B;
C = sysd.C;

if abs(eig(A)) < 1
    disp('Sistema stabile');
else
    disp('Sistema instabile');
end

T = 0 : sample_time : horizon;

for i = 1 : length(T)
    x_ref(:, i) = [5*i 5 5*i 5]'; % questo è il riferimento
end

Q = 100*eye(4); % (ny * ny)
Qf = Q; % (ny * ny)
R = 0.01; % (nu * nu)

[K, Lg, g] = riccati_Lg(A, B, C, Q, Qf, R, T, x_ref);

% i due carrelli all'inizio sono fermi
x(:, 1) = [0 0 0 0]';

for i = 1 : horizon
    u(:, i) = -K(:, :, i)*x(:, i) + Lg(:, :, i)*g(:, i+1);
    x(:, i+1) = A*x(:, i) + B*u(:, i);
end

plot(T, x);
legend('x1', 'v1', 'x2', 'v2');