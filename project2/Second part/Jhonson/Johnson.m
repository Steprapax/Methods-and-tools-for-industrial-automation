clear;
clc;
close all;

jobs=[1 2 3 4 5 6 7];
scheduled_jobs=[];

a=[6 2 4 1 7 4 7];
b=[3 9 3 8 1 5 6];
K=1;
L=7;
M=1000;
% a e b con i appartenente al numero di jobs -> processing_time;
% start_time con i appartenente al numero di jobs;
%completion_time con i appartenente al numero di jobs;

[sorted_a,prec_a]= sort(a);
[sorted_b,prec_b]= sort(b);

for i=1 : length(jobs)
    if(sorted_a(1)<=sorted_b(1))
        scheduled_jobs(K)=prec_a(1);
        a(prec_a(1))=M;
        b(prec_a(1))=M;
        K=K+1;
        [sorted_a,prec_a]= sort(a);
        [sorted_b,prec_b]= sort(b);
    else
        scheduled_jobs(L)= prec_b(1);
        a(prec_b(1))=M;
        b(prec_b(1))=M;
        L=L-1;
        [sorted_a,prec_a]= sort(a);
        [sorted_b,prec_b]= sort(b);
        jobs(1)= [];
    end
end
