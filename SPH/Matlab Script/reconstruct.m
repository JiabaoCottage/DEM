function [an,bn,a0,d1] = reconstruct(c,Num2)
    Period=floor(length(c)/200);
    d=c(1:Period:length(c));
    temp = sum(d)/length(d);
    d=d-temp;
    d1 = abs(d);
    Num1=length(d);
    [an,bn,a0] = fseries(d1,Num1,Num2);
end

