from __future__ import print_function
from asyncio import FIRST_EXCEPTION
from yade import pack,ymport,plot,timing,qt
import time
from scipy import special
import numpy as np
from math import *
import re


O.dt = 25*1.e-6

O.materials.append(FrictViscoMat(density=2630,frictionAngle=radians(20),betan=0.3,label='fvm'))
p=50
grid = RegularGrid(-1.1,1.1,p) 

axis = numpy.linspace(-1.1,1.1,p)
X,Y,Z = numpy.meshgrid(axis,axis,axis,indexing='ij')
R = (X**2+Y**2+Z**2)**0.5
Phi = numpy.zeros([p,p,p])
Phi = numpy.arctan2((X**2+Y**2)**0.5,Z)

Theta = numpy.zeros([p,p,p])
Theta = numpy.arctan2(Y,X)

N = 15
f="cylinder.dat"
file=open(f,'r')
stri = file.read()
aList = re.findall('([-+]?\d+(\.\d*)?|\.\d+)([eE][-+]?\d+)?',stri)
count = 0

A = numpy.zeros([N,N])
for iloop in range(N):
    for jloop in range(N):
        A[iloop,jloop] = float(aList[count][0]+aList[count][2])
        count = count+1
file.close()

R1 = numpy.zeros([p,p,p])
for iloop in range(N) :
    for jloop in range(iloop) :
        R1 = R1 + 0.1*A[iloop,jloop]*special.sph_harm(jloop,iloop,Theta,Phi).real

distField = R-R1

O.bodies.append(levelSetBody(center=(0,-28.9,30.0),grid=grid,distField=distField.tolist(),material='fvm',dynamic=True,orientation = (Vector3(0,1,0),23.5*pi/180))) 
O.bodies.append(levelSetBody(shape='box',center=(0,-27.65,23.895),extents=(30,6.841676008,0.1),spacing=1,material='fvm',dynamic=False,orientation = (Vector3(1,0,0),-68.94676824*pi/180)))
O.bodies.append(levelSetBody(shape='box',center=(0,-24.3,17.79),extents=(30,1.1,0.1),spacing=1,material='fvm',dynamic=False))
O.bodies.append(levelSetBody(shape='box',center=(0,-21.7,13.79),extents=(30,4.408131846,0.1),spacing=1,material='fvm',dynamic=False,orientation = (Vector3(1,0,0),-68.19859051*pi/180)))
O.bodies.append(levelSetBody(shape='box',center=(0,-19.1,9.79),extents=(30,1.1,0.1),spacing=0.1,material='fvm',dynamic=False))
O.bodies.append(levelSetBody(shape='box',center=(0,-16.55,5.79),extents=(30,4.389813516,0.1),spacing=1,material='fvm',dynamic=False,orientation = (Vector3(1,0,0),-68.8186505*pi/180)))
O.bodies.append(levelSetBody(shape='box',center=(0,-14,1.79),extents=(30,1.1,0.1),spacing=0.1,material='fvm',dynamic=False))
O.bodies.append(levelSetBody(shape='box',center=(0,-8.9,1.79),extents=(30,4.2,0.1),spacing=0.1,material='fvm',dynamic=False))
O.bodies.append(levelSetBody(shape='box',center=(0,-2.8,0.895),extents=(30,2.291124141,0.1),spacing=1,material='fvm',dynamic=False,orientation = (Vector3(1,0,0),-24.1085159*pi/180)))
O.bodies.append(levelSetBody(shape='box',center=(0,100,0),extents=(30,102,0.1),spacing=1,material='fvm',dynamic=False))

O.engines = [ForceResetter()
             ,InsertionSortCollider([Bo1_LevelSet_Aabb()],verletDist=0) 
             ,InteractionLoop([Ig2_LevelSet_LevelSet_ScGeom()],
                              [Ip2_FrictViscoMat_FrictViscoMat_FrictViscoPhys(kn = MatchMaker(algo = 'val',val = 1.e9),kRatio = MatchMaker(algo = 'val',val = 7e8))],
                              [Law2_ScGeom_FrictViscoPhys_CundallStrackVisco(sphericalBodies=False)],
                              )
             ,NewtonIntegrator(kinSplit=True,damping=0,label='newton',gravity = (0,0,0-9.8))
             ]

O.run()  