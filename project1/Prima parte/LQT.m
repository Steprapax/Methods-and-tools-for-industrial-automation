function [L,Lg,g,P] = LQT(A,B,C,Q,Qf,R,T,z)
N=length(T)-1;

%calcolo P
P(:,:,N+1)=C'*Qf*C; %P è settata come matrice a 3 dimensioni per far avere evoluzione temporale
E=B/R*B';
V=C'*Q*C; 
W=C'*Q;
for i=N:-1:1 
P(:,:,i)=A'*P(:,:,i+1)*(inv(eye(3)+E*P(:,:,i+1)))*A+V;
end

%calcolo g(k)
g(:,N+1)=C'*Qf*z(:,N+1);
for i=N:-1:1
g(:,i)=A'*(eye(3)-(inv(inv(P(:,:,i+1))+E))*E)*g(:,i+1)+W*z(:,i);
end

%calcolo L(k)
for i=1:N
    L(:,:,i) = (inv(R+B'*P(:,:,i+1)*B))*B'*P(:,:,i+1)*A;
end;

%calcolo Lg(k)
for i=1:N
    Lg(:,:,i) = (inv(R+B'*P(:,:,i+1)*B))*B';
end;