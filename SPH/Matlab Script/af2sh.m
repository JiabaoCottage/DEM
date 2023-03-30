function [A, B] = af2sh(r, theta, phi, N)
tic;
ntheta = length(theta);
nphi = length(phi);
dphi = 2*pi / (nphi - 1);
[x, w] = legzo(ntheta);
tic;
Qkm = schmidt(x, N - 1);
toc
r2 = interp2(phi, theta, r, phi, acos(x)');
wi = ones(nphi, 1); wi(1) = 0.5; wi(nphi) = 0.5;

for k = 1 : ntheta 
    r2(k, :) = r2(k, :) .* wi';
end

for k = 1 : nphi
    r2(:, k) = r2(:, k) .* w';
end

A = zeros(N, N);
B = zeros(N, N);

k2 = 2*(0:N-1) + 1;

ksi = 1;
for m = 0 : N - 1
    m1 = m + 1;
    A(:, m1) = ksi * cos(m*phi) * r2' * Qkm(:, :, m1) .* k2;
    B(:, m1) = ksi * sin(m*phi) * r2' * Qkm(:, :, m1) .* k2;
    if m == 0, ksi = ksi * 2; end
end

A = A * dphi * 0.25 / pi;
B = B * dphi * 0.25 / pi;

toc