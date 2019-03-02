clc;
clear;
close all;

j=[];
jd=[];
jc=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
duedate=[38 48 35 38 18 33 57 28 54 53 38 35 34 53 24 21 17 16 44 55];
p=[9 2 3 9 1 8 8 3 4 6 5 6 1 6 1 8 7 4 6 6];
[sorted_job,index]=sort(duedate);

i=1;
for t=1:length(jc)
    sum=0;
    j(i)= jc(index(t));
    for k= 1: length(j)
        sum= sum + p(j(k));
        p1(k)= p(j(k));
    end
    if sum > duedate(index(t))
        [M,I]=max(p1);
        jd=[jd,j(I)];
        j(I)=[];
        i=i-1;    
    end
    i=i+1;
end

j_tot=[j,jd]