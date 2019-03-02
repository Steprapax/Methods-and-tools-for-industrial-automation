clc; 
clear;
close all;

sample_time=1;
horizon=100;
T=1:sample_time:horizon;

A=[  1   0  0 ;
   -0.5  1  0 ;
     1   1 -1];

B=[1 0 ;
   0 1 ;
   1 0];

C=[1 1  0 ; 
   0 1 -1];

D=[0];

Rn=0.01*[5 0  0   ;
         0 2  0   ;
         0 0 0.1;];

Qn=0.1*[0.5 0 ;
        0 1.2];

xsi = mvnrnd([0 0],Qn,horizon-1)';
eta=mvnrnd([0 0 0],Rn,horizon-1);
eta=eta(:,1)';
Q=eye(size(A,1));
Qf=0.39*Q;
R=0.7;
alfa=[2; 3; -2];
sigma=[1.2 0 0;
        0 0.7 0;
        0  0 1.2];
[P,K,K_infinito] = riccati_P_K(A,B,Q,Qf,R,T);
[x_hat]= kalman(A,B,C,Rn,Qn,eta,xsi,K,alfa,sigma,T);
T1=1:sample_time:horizon-1;
plot(T1,x_hat);
