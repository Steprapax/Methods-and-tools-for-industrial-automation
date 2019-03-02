clc;
clear;
%linear, time-invaring system. 
sample_time=1;
horizon=100;

A=[0.8 0 0;
   -0.5 1 0
   0 -1 1];

B=[1 0;
    0 1
    1 0];
C=eye(3); %identica di 3 elementi

sys_open=ss(A,B,C,0); %linear system as an object(A,B,C,D,
%se discreto metto istante campionamento)
T=0:sample_time:horizon;

sys= c2d(sys_open, sample_time);

A= sys.A;
B= sys.B;
C= sys.C;
%stabilità del sistema:
disp(abs(eig(A)));
x0=[1; -2; 1];

%evoluzione autonoma del sistema U=0;
U=zeros(2,length(T));
[Y, Tsim, X] = lsim(sys_open,U,T,x0);   % simulate X e Y are the same C=I
subplot (3,1,1);
plot(Tsim,Y)                    % plot the output vs. time
axis('tight');
title('Autonomous system')

%evoluzione in anello chiuso con LQT;
%Q=eye(3); %matrici identiche
Q = [1000 0 0;
    0 1 0;
    0 0 1];
Qf=1*Q;
R=eye(2);
% = [10 10 20]';
for i=1:length(T)
%     z(:,i) = z0;
    z(1,i) = 100;
    z(2,i) = 50;
    z(3,i) = 0;
end;
[L,Lg,g,P]=LQT(A,B,C,Q,Qf,R,T,z);
%evoluzione del sistema
X_o(:,1)=x0;
for i=1:length(T)-1
    X_o(:,i+1)=(A-B*L(:,:,i))*X_o(:,i)+B*Lg(:,:,i)*g(:,i+1);
end
subplot (3,1,2);
%plot(T,X_o(1,:))                    % plot the output vs. time
plot(T,X_o)
axis('tight');
title('LQT state')
subplot (3,1,3);
plot(T,z)                    % plot the output vs. time
axis('tight');
title('LQT track')

