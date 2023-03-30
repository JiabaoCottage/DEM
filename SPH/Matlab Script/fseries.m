function [an,bn,a0]=fseries(fx,Num1,N)
 
T = 2*pi;
dt = T/(Num1-1);
t = -pi:dt:pi;
%tao = -0.5:dt:0.5;
a0 = trapz(fx)/T*dt;
%f = a0;
an = zeros(1,N);
bn = zeros(1,N);
for n = 1:N
    fcos = fx.*cos(n*t);
    an(n)=trapz(t,fcos)/T;
    fsin = fx.*sin(n*t);
    bn(n)=trapz(t,fsin)/T;
%    f = f+ an(n)*cos(n*w1*t)+bn(n)*sin(n*w1*t);
end
