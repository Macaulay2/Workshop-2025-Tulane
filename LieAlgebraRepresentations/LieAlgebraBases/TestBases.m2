
-*

    -- invert a permutation sigma
    --apply(sort apply(#sigma, i -> {sigma_i,i}), j -> last j)

*-

loadPackage("LieAlgebraRepresentations");
g = simpleLieAlgebra("B",5);
LAB = lieAlgebraBasis(g);
-- Check the WriteInBasis function
c = apply(#(LAB#"BasisElements"), i -> random(-1000,1000));
B = LAB#"BasisElements";
M = sum(#c, i -> c_i*B_i)
writeInBasis = LAB#"WriteInBasis";
v = writeInBasis(M);
v==c
-- Check the weights of the adjoint representation
Adj = adjointRepresentation(g);
representationWeights(Adj)==LAB#"Weights"
WD = weightDiagram irreducibleLieAlgebraModule(highestRoot(g),g);
WD==new VirtualTally from tally(LAB#"Weights")
-- Check it is semisimple
br = LAB#"Bracket";
ad = X -> transpose matrix apply(B, Y -> writeInBasis br(X,Y));
L = apply(B, X -> ad X);
kappa = matrix apply(L, i-> apply(L, j -> trace(i*j)));
rank kappa == dim g
-- Check the Cartan matrix
CM = cartanMatrix(g);
m = g#"LieAlgebraRank";
CM == matrix apply(m, k -> (LAB#"Weights")_(m+k))
-- Check the dual basis
kinv = inverse kappa;
cstar = entries transpose kinv;
Bstar = apply(#B, i -> sum apply(#B, j -> ((cstar_i)_j*B_j)));

Lstar = apply(Bstar, X -> ad X);
matrix apply(L, i-> apply(Lstar, j -> trace(i*j)))==matrix apply(#L, i -> apply(#L, j -> if i==j then 1/1 else 0/1))






loadPackage("LieAlgebraRepresentations");
g = simpleLieAlgebra("C",5);
LAB = lieAlgebraBasis(g);
-- Check the WriteInBasis function
c = apply(#(LAB#"BasisElements"), i -> random(-1000,1000));
B = LAB#"BasisElements";
M = sum(#c, i -> c_i*B_i)
writeInBasis = LAB#"WriteInBasis";
v = writeInBasis(M);
v==c
-- Check the weights of the adjoint representation
Adj = adjointRepresentation(g);
representationWeights(Adj)==LAB#"Weights"
WD = weightDiagram irreducibleLieAlgebraModule(highestRoot(g),g);
WD==new VirtualTally from tally(LAB#"Weights")
-- Check the dual basis




loadPackage("LieAlgebraRepresentations");
g = simpleLieAlgebra("D",5);
LAB = lieAlgebraBasis(g);
-- Check the WriteInBasis function
c = apply(#(LAB#"BasisElements"), i -> random(-1000,1000));
B = LAB#"BasisElements";
M = sum(#c, i -> c_i*B_i)
writeInBasis = LAB#"WriteInBasis";
v = writeInBasis(M);
v==c
-- Check the weights of the adjoint representation
Adj = adjointRepresentation(g);
representationWeights(Adj)==LAB#"Weights"
WD = weightDiagram irreducibleLieAlgebraModule(highestRoot(g),g);
WD==new VirtualTally from tally(LAB#"Weights")
-- Check the dual basis
