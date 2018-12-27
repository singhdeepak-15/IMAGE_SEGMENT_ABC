function [ch1,ch2] = Crossover(ch1,ch2)
if rand > 0.5
    tmp = ch1(1,2);
    ch1(1,2) = ch2(1,2);
    ch2(1,2) = tmp;
else
    tmp = ch1(1,1);
    ch1(1,1) = ch2(1,1);
    ch2(1,1) = tmp;
end