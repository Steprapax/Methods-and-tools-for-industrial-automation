clc;
clear;
close all;

jobs = [1 2 3 4 5 6 7 8 9 10];
num_jobs = length(jobs);

scheduled_jobs_m1 = [];
scheduled_jobs_m2 = [];
scheduled_jobs_m3 = [];
scheduled_jobs_m4 = [];

start_time = 0;
end_time = [];

p1 = [5 3 6 8 4 12 12 5 3 2];
p2 = [12 6 1 5 6 15 3 2 8 8];
p3 = [1 20 2 5 7 11 12 2 5 4];
p4 = [13 10 1 15 6 12 11 4 4 13];
p5 = [2 6 2 1 5 13 2 7 18 3];

im1 = 1;
im2 = 1;

counter1 = 0;
counter2 = 0;

for i = 1 : num_jobs
    
    if counter1 < counter2 % m1 è libera
        counter1 = counter1 + p1(i);
        scheduled_jobs_m1(im1) = i;
        im1 = im1 + 1;
        end_time(i) = counter1;
        
    elseif counter1 > counter2 % m2 è libera
        counter2 = counter2 + p2(i);
        scheduled_jobs_m2(im2) = i;
        im2 = im2 + 1;
        end_time(i) = counter2;
        
    else % m1 e m2 sono entrambe libere
        
        if p1(i) <= p2(i)
            counter1 = counter1 + p1(i);
            scheduled_jobs_m1(im1) = i;
            im1 = im1 + 1;
            end_time(i) = counter1; %counter aggiornato
        else
            counter2 = counter2 + p2(i);
            scheduled_jobs_m2(im2) = i;
            im2 = im2 + 1;
            end_time(i) = counter2;
        end
    end
end

im3 = 1;
im4 = 1;

counter3 = 0;
counter4 = 0;

end_time2 = [];

for i = 1 : num_jobs
    
    if counter3 < counter4 % m1 è libera
        counter3 = counter3 + p3(i);
        scheduled_jobs_m3(im3) = i;
        im3 = im3 + 1;
        end_time2(i) = end_time(i) + counter3;
        
    elseif counter3 > counter4 % m2 è libera
        counter4 = counter4 + p4(i);
        scheduled_jobs_m4(im4) = i;
        im4 = im4 + 1;
        end_time2(i) = end_time(i) + counter4;
        
    else % m1 e m2 sono entrambe libere
        
        if p3(i) <= p4(i)
            counter3 = counter3 + p3(i);
            scheduled_jobs_m3(im3) = i;
            im3 = im3 + 1;
            end_time2(i) = end_time(i) + counter3;
        else
            counter4 = counter4 + p4(i);
            scheduled_jobs_m4(im4) = i;
            im4 = im4 + 1;
            end_time2(i) = end_time(i) + counter4;
        end
    end
end

counter5 = 0;
end_time3 = [];

[sorted_end_times, scheduled_jobs_m5] = sort(end_time2)

for i = 1 : num_jobs
    
    counter5 = counter5 + p5(scheduled_jobs_m5(i));
    end_time3(scheduled_jobs_m5(i)) = sorted_end_times(i) + counter5;
    
end

makespan = max(end_time3);