clc;
clear;

sample_time=1;
horizon=5;

A=[  0  1 ;
   -0.5 1];

B=[ 0 ; 1];

C=eye(2);
sys_open=ss(A,B,C,0,sample_time); %Create state-space model, convert to state-space model
T=0:sample_time:horizon;
x0=[100;-50];

if(abs(eig(A))<1)
    disp('Sistema stabile');
    disp(abs(eig(A)));
else disp('Sistema instabile');
end

U=zeros(1,length(T));
[Y, Tsim, X]=lsim(sys_open,U,T,x0);

j=1;
for R=0.1:0.1:100
    Q=0.5*eye(2);
    Qf=0.39062*Q;
    
    [P,K,K_inf]=riccati_P_K(A,B,Q,Qf,R,T);
    [K_matlab,P,e]=dlqr(A,B,Q,R);
     
    sys_closed_infinite_horizon=ss(A+B*K_inf,B,C,0,sample_time);
    sys_closed_infinite_horizon_matlab=ss(A-B*K_matlab,B,C,0,sample_time);
     
    U=zeros(1,length(T));
    [Y, Tsim, X] = lsim(sys_closed_infinite_horizon,U,T,x0);
    [Y_matlab, Tsim, X_matlab] = lsim(sys_closed_infinite_horizon_matlab,U,T,x0);

    X_fh(:,1)=x0;
    for i=1:length(T)-1
        U_fh(:,i)=K(:,:,i)*X_fh(:,i);
        X_fh(:,i+1)=A*X_fh(:,i)+B*U_fh(:,i);
    end
    
    Jx(:,j) = zeros(3,1);
    Ju(:,j) = zeros(3,1);
    
    for i=1:length(T)-1  
        Jx(1,j) = Jx(1,j) + X(i,:)*Q*(X(i,:)');
        Jx(2,j) = Jx(2,j) + (X_fh(:,i)')*Q*X_fh(:,i);
        Jx(3,j) = Jx(3,j) + X_matlab(i,:)*Q*(X_matlab(i,:)');
    end;
    
    Jx(1,j) = Jx(1,j) + X(size(X,i),:)*Qf*(X(size(X,i),:)');
    Jx(2,j) = Jx(2,j) + (X_fh(:,length(T))')*Qf*X_fh(:,length(T));
    Jx(3,j) = Jx(3,j) + X_matlab(size(X_matlab,i),:)*Qf*(X_matlab(size(X_matlab,i),:)')
    
    for i=1:length(T)-1  
        Ju(1,j) = Ju(1,j) + (K_inf*X(i,:)')^2;
        Ju(2,j) = Ju(2,j) + (K(:,:,i)*X_fh(:,i))^2;
        Ju(3,j) = Ju(3,j) + (K_matlab*X_matlab(i,:)')^2;
    end;
    j=j+1;
end

subplot(3,1,1);
plot(Jx(1,:),Ju(1,:));
xlabel('Jx');
ylabel('Jy');
axis('tight');
title('K a tempo infinito');

subplot (3,1,2);
plot(Jx(3,:),Ju(3,:));                   
axis('tight');
xlabel('Jx');
ylabel('Jy');
title('K calcolato con funzione dlqr');

subplot (3,1,3);
plot(Jx(2,:),Ju(2,:));                   
xlabel('Jx');
ylabel('Jy');
axis('tight');
title('K a tempo finito');
