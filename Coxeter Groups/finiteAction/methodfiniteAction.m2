

restart
needsPackage "CoxeterGroups";
needsPackage "InvariantRing";



finiteActionCoxeter = method()
finiteActionCoxeter (List, CoxeterGroup, PolynomialRing):= (L,W,S)  ->(
	N := numRows first L;
	R := ring first L;

	f := hashTable apply(#L, i -> (gens W)#i => L#i);
	if numgens W =!= #L then (
		error "Length of list does not match number of generators of the Coxeter group."
	)
	else if any(relations W, r -> product apply(r, s -> f#s) =!= id_(R^N)) then (
	error "map: The given list does not define a group homomorphism from the given 
	Coxeter group."
	);
	A = finiteAction(L, S);
	--A.cache#(symbol Group) = W; 
	return A

);

-- ********Example 1*********

W = dihedralGroup(3)

G1 = id_(QQ^3)
G2 = G1

matrixGens = {G1, G2}

peek finiteActionCoxeter(matrixGens, W, QQ[x..z])


-- ********Example 2*********

W = symmetricGroup 4

rho = reflectionRep W

matrixGens = apply(gens W, s -> rho s)

WPolyRep = finiteActionCoxeter(matrixGens, W, QQ[x..z])

invariants WPolyRep



