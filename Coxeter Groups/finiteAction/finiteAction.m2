

loadPackage "CoxeterGroups";
needsPackage "InvariantRing"


W = dihedralGroup(3)

G1 = id_(QQ^3)
G2 = -1 * G1

matrixGens = {G1, G2}

nnnn := numRows first matrixGens;
RRRR := ring first matrixGens;

fHashtable := hashTable apply(#matrixGens, i -> (gens W)#i => matrixGens#i);

if any(relations W, r -> product apply(r, s -> fHashtable#s) =!= id_(RRRR^nnnn)) then (
	error "map: The given list does not define a group homomorphism from the given 
	Coxeter group."
);

matrixGens = {G1, G1}

nnnn := numRows first matrixGens;
RRRR := ring first matrixGens;

fHashtable := hashTable apply(#matrixGens, i -> (gens W)#i => matrixGens#i);

if any(relations W, r -> product apply(r, s -> fHashtable#s) =!= id_(RRRR^nnnn)) then (
	error "map: The given list does not define a group homomorphism from the given 
	Coxeter group."
)

A = finiteAction(matrixGens, QQ[x..z])

--A.(symbol group) => W;
--return A;



