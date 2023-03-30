function [point] = intersectpolygon(mesh, normals, p1, p1mp2)
point = [];

td = ...
    normals(:, 1) .* (p1(1) - mesh(:, 1, 1)) + ...
    normals(:, 2) .* (p1(2) - mesh(:, 1, 2)) + ...
    normals(:, 3) .* (p1(3) - mesh(:, 1, 3));

tn = ...
    normals(:, 1) * p1mp2(1) + ...
    normals(:, 2) * p1mp2(2) + ...
    normals(:, 3) * p1mp2(3);

ta = td ./ tn;

x = find( (ta > 0) & (abs(tn) > eps) );

if ~isempty(x)

    tax = ta(x);
    meshx = mesh(x, :, :);
    
    % Intersection of all faces
    p = [...
        p1(1) - p1mp2(1) .* tax...
        p1(2) - p1mp2(2) .* tax...
        p1(3) - p1mp2(3) .* tax];
    
    dv1 = [(meshx(:, 1, 1) - p(:, 1)) (meshx(:, 1, 2) - p(:, 2)) (meshx(:, 1, 3) - p(:, 3))];
    dv2 = [(meshx(:, 2, 1) - p(:, 1)) (meshx(:, 2, 2) - p(:, 2)) (meshx(:, 2, 3) - p(:, 3))];
    dv3 = [(meshx(:, 3, 1) - p(:, 1)) (meshx(:, 3, 2) - p(:, 2)) (meshx(:, 3, 3) - p(:, 3))];

    dv1k = sqrt(sum(dv1.^2, 2));
    dv2k = sqrt(sum(dv2.^2, 2));
    dv3k = sqrt(sum(dv3.^2, 2));
    
    dv12 = dv1 .* dv2;
    dv23 = dv2 .* dv3;
    dv31 = dv3 .* dv1;

    ac1 = real(acos( sum(dv12, 2) ./ ( dv1k.*dv2k ) ));
    ac2 = real(acos( sum(dv23, 2) ./ ( dv2k.*dv3k ) ));
    ac3 = real(acos( sum(dv31, 2) ./ ( dv3k.*dv1k ) ));

    x = find( abs(ac1 + ac2 + ac3 - 2*pi) < 0.0001 );
    
    if ~isempty(x)
        point = p(x, :);
    end

end
end