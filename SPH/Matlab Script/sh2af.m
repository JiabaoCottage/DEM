function [r] = sh2af(A, B, N, theta, phi)
Qkm = schmidt(cos(theta), N - 1);

if ( length(theta) == 1 && length(phi) == 1 )
    
    r = 0;
    for m = 0 : N - 1
        m1 = m + 1;
        r = r + sum(Qkm(:, m1) .* (A(:, m1)*cos(m*phi) + B(:, m1)*sin(m*phi)));
    end
    
else
    r = zeros(length(theta), length(phi));

    for m = 0 : N - 1
        m1 = m + 1;
        r = r + Qkm(:, :, m1) * (A(:, m1)*cos(m*phi) + B(:, m1)*sin(m*phi));
    end
    
end