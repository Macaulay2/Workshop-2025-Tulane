restart 
load "code.m2"

A = matrix {{9, 0,0,0,0}, {0,8,0,0,0}, {6,0,7,0,0},{0,4,0,5,0},{1,0,2,0,3}}
m = {1,2,3,4,5}
solveGaussianSystem(A,m)

n = 150
numTrials = 100

trialTimes = for i from 1 to numTrials list  (
    B := random(ZZ^n, ZZ^n);
    m := flatten entries random(ZZ^n,ZZ^1);
    (timing(solvePowerSystem(B, m)))#0
)

averageTime = sum(trialTimes)/numTrials

profile(solvePowerSystem(random(ZZ^n, ZZ^n),flatten entries random(ZZ^n,ZZ^1)))
