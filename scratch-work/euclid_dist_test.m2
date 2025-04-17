restart 
load "../GaussianMixtureModels/Code.m2"

A = matrix {{9, 0,0,0,0}, {0,8,0,0,0}, {6,0,7,0,0},{0,4,0,5,0},{1,0,2,0,3}}
m = {4,5,5.8,4,2}

point = solvePowerSystem(A,m)
F = getPowerSystem(A,{0,0,0,0,0})

apply(F, f->f(toSequence point))

pointreal = apply(point, p->realPart(p))

lattice = makeLattice(pointreal, 1., 0.5)
newpoint = minimizeDistance(point, lattice, F)

lattice = makeLattice(newpoint, 0.5, 0.25)
newpoint = minimizeDistance(point, lattice, F)

lattice = makeLattice(newpoint, 0.25, 0.125)
newpoint = minimizeDistance(point, lattice, F)

lattice = makeLattice(newpoint, 0.125, 0.0625)
newpoint = minimizeDistance(point, lattice, F)

lattice = makeLattice(newpoint, 0.0625, 0.031);
newpoint = minimizeDistance(point, lattice, F);

lattice = makeLattice(newpoint, 0.031, 0.015);
newpoint = minimizeDistance(point, lattice, F);

newm = apply(F, f->f(toSequence newpoint))
norm(newm-m)
