export {"getAllTrees","raysOfTreePairCone","raysOfUltrametricCone","maximalTreePairs"}

getAllTrees = method();
--Returns a list of polynomials, each representing a rooted tree,
--leaves given by the argument list.
--All such trees are generated.
getAllTrees(List) := List => L->(
    n := #L;
    if #L==1 or #L==2 then return {fold(L,times)};
    toReturn := {};
    for i from 1 to floor(n/2) do(
    	sets := subsets(L,i);
	if(i == n/2) then(
	    newSets := {};
	    for S in sets do(
		SComplement := select(L,x->not member(x,S));
	    	if (not member(S,newSets)) and (not member(SComplement,newSets)) then newSets = append(newSets,S);
	    );
	    sets = newSets;
	);
	for S in sets do(
	    leftSubtrees := getAllTrees(S);
	    rightSubtrees := getAllTrees(select(L,x->not member(x,S)));
	    for U in leftSubtrees do(
		for T in rightSubtrees do(
		    if i == 1 then toReturn = append(toReturn, T + fold(support(U+T),times))
		    else toReturn = append(toReturn,U+T+fold(support(U+T),times));
		);
	    );
	);
    );
    return toReturn;
);
getAllTrees(ZZ) := List => n->(
    x := getSymbol "x";
    R := QQ[x_1..x_n];
    return getAllTrees(gens R);
)

pairsForClades = method();
--Takes a rooted tree (expressed as a polynomial)
--and for each clade, returns the set of pairs of leaves
--whose distance is given by the weight on the internal node
--corresponding to that clade
pairsForClades(RingElement) := List => T->(
    allPairs := {};
    clades := sort(flatten entries monomials T);
    for clade in clades do(
    	pairSet := apply(subsets(support clade,2),product);
	pairSet = select(pairSet,p->not any(allPairs,Q->member(p,Q)));
	allPairs = append(allPairs,pairSet);
    );
    return allPairs;
)

getLinearHull = method();
--Takes a tree T as input and returns a matrix whose column span
--is the linear hull of the cone containing all ultrametrics
--with topology T. The particular generating set of this linear hull
--is in bijection with the internal nodes of T
--and corresponding to an internal node x is the set of pairs of leaves
--with most recent common ancestor x
getLinearHull(RingElement):=Matrix=>T->(
    cladePairs := pairsForClades(T);
    transpose matrix for L in cladePairs list(
    	for p in subsets(gens ring T,2) list(
	    if member(product(p),L) then 1 else 0
	)
    )
);

getTreePairMatrix = method();
--Takes a pair of trees T1,T2 and
--returns the matrix obtained by concatinating the matrices
--getLinearHull(T1) and getLinearHull(T2)
getTreePairMatrix(RingElement,RingElement):=Matrix=>(T1,T2)->(
    return getLinearHull(T1) | getLinearHull(T2);
)

oneNorm=method();
--Returns the 1-norm of a vector
--If a matrix is inputted, treats it as a vector
oneNorm(Matrix):=RingElement=>v->(
    return sum(apply(flatten entries v,abs))
)

cayleyMengerMatrix=method();
cayleyMengerMatrix(ZZ):=Matrix=>n->(
    d := getSymbol "d"; 
    R := QQ[apply(sort subsets(toList(1..n),2),p->d_p)];
    matrix for i from 1 to n+1 list(
    	for j from 1 to n+1 list(
	    if i == j then 0
	    else if i == n+1 then 1
	    else if j == n+1 then 1
	    else if i<j then d_{i,j}
	    else if j<i then d_{j,i}
	)
    )
);

maximalTreePairs = method();
--Returns all pairs of trees on n leaves
--whose corresponding cone in the tropical PG-variety is full-dimensional
--In other words, the pairs of trees with no common nontrival clade
maximalTreePairs(ZZ):=List=>n->(
    allTrees := getAllTrees(n);
    allTreePairs := subsets(allTrees,2);
    maximalPairs := select(allTreePairs,p->rank getTreePairMatrix(p_0,p_1) == 2*n-3);
    return maximalPairs;
);

cladeIntersectionPoset = method()
--Takes a pair of trees as input and outputs
--the clade intersection poset, expressed as a polynomial
cladeIntersectionPoset(RingElement,RingElement):=RingElement=>(T1,T2)->(
    toReturn := T1+T2;
    for m1 in terms T1 do(
    	for m2 in terms T2 do(
	    toAdd := gcd(m1,m2);
	    if (first degree(toAdd) > 1) then
	        toReturn = toReturn + toAdd;
	)
    );
    toReturn = sum(flatten entries monomials toReturn);
    return toReturn;
)

raysOfUltrametricCone=method();
--Takes a tree T as input and outputs
--rays generating the cone of all ultrametrics
--with topology T, modulo the lineality space
--which is spanned by the all-ones vector
raysOfUltrametricCone(RingElement):=List=>T->(
    coordinates := subsets(gens ring T, 2);
    toReturn := for m in terms T list(
    	for c in coordinates list(
	    if m%c_0==0 and m%c_1==0 then -1 else 0
	)
    );
    return toReturn;
)

raysOfTreePairCone=method();
--Takes a trees T1,T2 as input and outputs
--rays generating the corresponding cone
--in the set of ultrametrics, Minkowski summed with itself.
--Does this modulo the lineality space, which is spanned
--by the all-ones vector
raysOfTreePairCone(RingElement,RingElement):=List=>(T1,T2)->(
    T := T1+T2-product(gens ring T1);
    return raysOfUltrametricCone(T);
)

edgeListToIndices=method();
--Takes a list of edges of a graph, as pairs of integers between 1 and n,
--and returns the positions where they appear in the lexicographic order.
--Assumes each edge is in increasing order
edgeListToIndices(List,ZZ):=List=>(G,n)->(
    allEdges := flatten for i from 1 to n-1 list for j from i+1 to n list {i,j};
    for e in G list(
    	position(allEdges,f->f==e)
    )
)

