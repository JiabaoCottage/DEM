clear;
clc;
starttime = tic;
% File names for reading and writing
filenamefrom='cylinder.stl';

% Open the file in binary to read the original file
fid1 = fopen(filenamefrom, 'rb');
 
% Read Header Write File
data = fread(fid1, 80, 'uint8');

%% Initial parameters
N = 15;                 % Harmonic number 
ntheta = 64;            % Theta angle division
nphi = 64;              % Fi angle division
n_write = 15;

%% Calculation
% Read the number of triangular matrices
N1 = fread(fid1, 1, 'uint32')
objects(1).mesh = zeros(N1, 3, 3);

% Write triangular matrix
for iloop=1:N1
    vector = fread(fid1, 12, 'float');
    objects(1).mesh(iloop,1,1)=vector(4);
    objects(1).mesh(iloop,1,2)=vector(5);
    objects(1).mesh(iloop,1,3)=vector(6);
    objects(1).mesh(iloop,2,1)=vector(7);
    objects(1).mesh(iloop,2,2)=vector(8);
    objects(1).mesh(iloop,2,3)=vector(9);
    objects(1).mesh(iloop,3,1)=vector(10);
    objects(1).mesh(iloop,3,2)=vector(11);
    objects(1).mesh(iloop,3,3)=vector(12);
    attribute = fread(fid1, 1, 'uint16');
end

% Close file
fclose(fid1);
%Calculate the center of the falling rock
objects(1).center = squeeze( sum(sum(objects(1).mesh)) / (3*size(objects(1).mesh, 1)) )';
% We get an angle vector
[theta, phi] = gettp(ntheta, nphi);
% Expand the mesh of the first object relative to the center into an angular function 
[r] = mesh2af(objects(1).mesh, objects(1).center, theta, phi, 'full');

% Calculate A and B
[A, B] = af2sh(r, theta, phi, N);
%Record A
fid = fopen('cylinder.dat','wt');
for iloop=1:n_write
    for jloop=1:n_write
        fprintf(fid,'%f\n',A(iloop,jloop)); 
    end
end
fclose(fid);

% Get a new angle function array
r = sh2af(A, B, N, theta, phi);
endtime = toc
%% Calculation results
% Draw a breakdown
drawaf1(r, theta, phi, [0 0 0], [.0 .8 .0], .5, [0 0 0], .0 );
%Storing images
savefigure2img('cylinder.jpg')
% Drawing angular functions
%drawmesh(objects(1).mesh, [.5 .5 .5], .5, [0 0 0], .5);