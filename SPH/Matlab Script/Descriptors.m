close all;
clear;

%I = imread('leaf.jpg');
I = imread('14.png');
I = rgb2gray(I);


[c,I]=fdescriptors(I);

% c=c+(40+50*(1i));
%c=c*exp(pi/2*1i);
%c=c*0.5;


%Num, number of descriptors. Give 1,2,4,8,..,256,512,..3499
Num2=100;
[an,bn,a0,d1]= reconstruct(c,Num2);
t = -pi:pi/100:pi;
%t = -pi:2.*pi/(length(d1)-1):pi;
f = a0;
for n = 1:Num2
    f = f+ an(n).*cos(n*t)+bn(n).*sin(n*t);
end
ischema = f.*(cos(t)+i*sin(t));
%ischema = d1.*(cos(t)+i*sin(t));
figure, imshow(imcomplement(bwperim(I)));
hold on, plot(ischema,'b');

figure ;
plot(ischema,'g');