

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

matrixGens = apply(gens W, s -> (id_(ZZ^4))_(toList s))

WPolyRep = finiteActionCoxeter(matrixGens, W, QQ[x_1..x_4])

invariants(WPolyRep,2)


-- ********Example 3*********

W = hyperoctahedralGroup 4

typeBpermutationRep = gensofW -> (
	listofGensofW = apply(gensofW, s -> toList s);
	--print(listofGensofW);
	m = #(listofGensofW#0);
	n = #listofGensofW;
	--print(m);
	--print(n);
	listofGensofWAbs = new MutableList from listofGensofW;
	--print(listofGensofWAbs);
	for i from 0 to n-1 do(
		listofGensofWAbs#i = new MutableList from listofGensofWAbs#i;
		for j from 0 to m-1 do(
			listofGensofWAbs#i#j = abs(listofGensofWAbs#i#j);
			listofGensofWAbs#i#j = listofGensofWAbs#i#j - 1;
		);
	);
	listofGensofWAbs = apply(listofGensofWAbs, s -> new List from s);
	listofGensofWAbs = new List from listofGensofWAbs;
	--print("here we go:"|toString(listofGensofWAbs));
	listofmatsW = apply(listofGensofWAbs, s -> mutableMatrix (id_(ZZ^m))_(s));
	--print(listofmatsW);
	listofmatsW = new MutableList from listofmatsW;
	for i from 0 to n-1 do(
		for j from 0 to m-1 do(
			if listofGensofW#i#j < 0 then(
				listofmatsW#i = matrix rowMult(listofmatsW#i, j, -1);
			);
		);
		listofmatsW#i = matrix listofmatsW#i;
	);
	new List from listofmatsW
)

typeBmatrices = typeBpermutationRep(gens W)

WPolyRep = finiteAction(typeBmatrices, QQ[x_1..x_4])

invariants(WPolyRep,6)