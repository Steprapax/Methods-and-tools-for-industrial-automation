clc;
clear;

A=[0 1;
   2 -2.5];

B=[0 1]';

C=eye(2);

Q=[1 -2;
   -2 4];

Qf=0.39*Q;
R=0.1;

horizon=100;
sample_time=1;
T=1:sample_time:horizon;

sys=ss(A,B,C,[0 0]');
sys=c2d(sys,sample_time);
[A,B,C,D]=ssdata(sys);
disp(abs(eig(sys.A)));

[P,K,K_infinito] = riccati_P_K(A,B,Q,Qf,R,T)

X_fh(:,1)=[-1 100]';
    for i=1:length(T)-1
        U_fh(:,i)=K(:,:,i)*X_fh(:,i);
        X_fh(:,i+1)=A*X_fh(:,i)+B*U_fh(:,i);
    end
    
plot(T, X_fh);