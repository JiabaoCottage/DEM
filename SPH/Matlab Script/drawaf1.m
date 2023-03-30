function [ ] = drawaf( r, theta, phi, center, facecolor, facealpha, edgecolor, edgealpha )

figure1 = figure('NumberTitle','off','Name','shexpansion','Color',[1 1 1]);
colormap(jet);
axes1 = axes('Parent',figure1);
if ( nargin < 4 )
    center = [0 0 0];
end

if ( nargin < 5 )
    facecolor = [.5 .5 .5];
end

if ( nargin < 6 )
    facealpha = .5;
end

if ( nargin < 7 )
    edgecolor = [.5 .5 .5];
end

if ( nargin < 8 )
    edgealpha = .5;
end

nt = length(theta);
np = length(phi);

[x, y, z] = sph2cart(repmat(phi, nt, 1), pi/2 - repmat(theta', 1, np), r);

[f, v] = surf2patch(x + center(1), y + center(2), z + center(3));

rmax = max(max(r));
rmin = min(min(r));
nf = size(f, 1);
facecolor1 = zeros(nf, 3);
colorindex = jet(64);

for iloop=1:nf
    radius = sqrt((v(f(iloop,1),1)-center(1))^2+...
        (v(f(iloop,1),2)-center(2))^2+...
        (v(f(iloop,1),3)-center(3))^2);
    if(abs(rmax-rmin)>1.0e-4)
        facecolor1(iloop, 1) = colorindex(ceil((radius-rmin)/(rmax-rmin)*62+1),1);
        facecolor1(iloop, 2) = colorindex(ceil((radius-rmin)/(rmax-rmin)*62+1),2);
        facecolor1(iloop, 3) = colorindex(ceil((radius-rmin)/(rmax-rmin)*62+1),3);
    else
        facecolor1(iloop, 1) = colorindex(ceil((radius)/(rmax)*1),1);
        facecolor1(iloop, 2) = colorindex(ceil((radius)/(rmax)*1),2);
        facecolor1(iloop, 3) = colorindex(ceil((radius)/(rmax)*1),3);
    end
end
patch('Parent',axes1,'Faces', f, 'Vertices', v,...
    'FaceVertexCData', facecolor1,...
    'FaceColor','flat',...
    'FaceAlpha', facealpha, ...    
    'EdgeColor', edgecolor, ...
    'EdgeAlpha', edgealpha);

zlabel('z','FontWeight','bold','FontName','Times New Roman');

ylabel('y','FontWeight','bold','FontName','Times New Roman');

xlabel('x','FontWeight','bold','FontName','Times New Roman');

view(axes1,[-46.4215053004566 6.59132812130142]);
box(axes1,'on');
grid(axes1,'on');

set(axes1,'BoxStyle','full','CLim',[-0.25 0.25],'CameraViewAngle',...
    8.45502351158921,'DataAspectRatio',[1 1 1],'FontName','Times New Roman',...
    'FontSize',19,'FontWeight','bold','GridAlpha',0.25,'MinorGridAlpha',0.5,...
    'PlotBoxAspectRatio',[2 1 1.1098632859579],'TickDir','out','XMinorGrid',...
    'on','XTick',[-10 -5 0 5 10 15 20],'YMinorGrid','on','YTick',[-5 0 5],...
    'YTickLabel',{'-5','0','5'},'ZMinorGrid','on','ZTick',[-10 -5 0 5 10]);
