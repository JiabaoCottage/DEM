function [r] = mesh2af(mesh, c, theta, phi, optimize)
if ( nargin < 5 )
    optimize = 'full';
end
useoptimization = strcmp(optimize, 'full');
ms = size(mesh, 1);
np = length(phi);
nt = length(theta);
r = zeros(nt, np);
[x, y, z] = sph2cart(repmat(phi, nt, 1), pi/2 - repmat(theta', 1, np), 1);
p1 = squeeze(mesh(:, 1, :));
p2 = squeeze(mesh(:, 2, :));
p3 = squeeze(mesh(:, 3, :));
meshN = cross(p2 - p1, p3 - p1);
N2 = repmat(sqrt(sum(meshN.^2, 2)), 1, 3);

% Mesh face normals
meshN = meshN ./ N2;

% Center of face
meshc = (p1 + p2 + p3) / 3;

tmp = [...
    sqrt(sum((p1 - meshc).^2, 2))...
    sqrt(sum((p2 - meshc).^2, 2))...
    sqrt(sum((p3 - meshc).^2, 2))];

% Circumcircle radius
meshr = max(tmp,[], 2);

if ( useoptimization )
    meshq = zeros(ms, 1);
    for k = 1 : ms
        index1 = quadrant(p1(k, :) - c);
        index2 = quadrant(p2(k, :) - c);
        index3 = quadrant(p3(k, :) - c);

        if ( index1 == index2 ) && ( index1 == index3 ) && ( index1 ~= 0 )
            meshq(k) = index1;
        end
    end
    mq = struct('mesh', [], 'N', [], 'c', [], 'r', []);
    for l = 1:8
        mq(l).mesh = mesh(meshq == 0 | meshq == l, :, :);
        mq(l).N = meshN(meshq == 0 | meshq == l, :);
        mq(l).c = meshc(meshq == 0 | meshq == l, :);
        mq(l).r = meshr(meshq == 0 | meshq == l);
    end
end


%% Beam crossing calculation
for it = 1 : nt
    for ip = 1 : np

        p1mp2 = -[x(it, ip) y(it, ip) z(it, ip)];
        
        % Second point
        p2 = c - p1mp2;

        if ( useoptimization )
            
            quadindex = quadrant(-p1mp2);
            
            if ( quadindex ~= 0 )
                
                [ indexes ] = intersectspheres( c, p2, mq(quadindex).c, mq(quadindex).r );

                mesh2 = mq(quadindex).mesh(indexes, :, :);
                meshN2 = mq(quadindex).N(indexes, :);

                [p] = intersectpolygon(mesh2, meshN2, c, p1mp2);
            else
                [p] = intersectpolygon(mesh, meshN, c, p1mp2);
            end
        else
            [p] = intersectpolygon(mesh, meshN, c, p1mp2);
        end
        
        if ~isempty(p)
            r(it, ip) = max(sqrt((p(:, 1) - c(1)).^2 + (p(:, 2) - c(2)).^2 + (p(:, 3) - c(3)).^2));
        end
    end
end