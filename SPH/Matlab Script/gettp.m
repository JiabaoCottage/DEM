function [ theta, phi ] = gettp( ntheta, nphi )
theta = 0 : ( pi / (ntheta - 1) ) : pi;
phi = 0 : ( 2*pi / (nphi - 1) ) : 2*pi;