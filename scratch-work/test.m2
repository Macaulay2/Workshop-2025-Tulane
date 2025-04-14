restart 
load "code.m2"

A = matrix {{9, 0,0,0,0}, {0,8,0,0,0}, {6,0,7,0,0},{0,4,0,5,0},{1,0,2,0,3}}
m = {1,2,3,4,5}
solveGaussianSystem(A,m)