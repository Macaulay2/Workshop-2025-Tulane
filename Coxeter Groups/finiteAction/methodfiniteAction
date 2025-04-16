

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
	A.cache#(symbol group) => W; 
	return A

);



needsPackage "CoxeterGroups";
needsPackage "InvariantRing";

