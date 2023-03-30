function [ indexes ] = intersectspheres( p1, p2, c, r )
l = p2(1) - p1(1);
m = p2(2) - p1(2);
n = p2(3) - p1(3);

A = l*l + m*m + n*n;
B = 2*( (p1(1) - c(:, 1))*l + (p1(2) - c(:, 2))*m + (p1(3) - c(:, 3))*n );
C = (p1(1) - c(:, 1)).^2 + (p1(2) - c(:, 2)).^2 + (p1(3) - c(:, 3)).^2 - r.^2;

D = B.^2 - 4.*A.*C;

indexes = find(D >= 0);