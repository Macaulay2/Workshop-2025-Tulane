

dynkinToPartition = method(
    TypicalValue=>List
);

dynkinToPartition(List) := v -> (
    n:=#v;
    append(apply(n, i -> sum apply(n-i, j -> v_(n-1-j))),0)
);

---------------------------------
-- 1. Define the GTPattern type
---------------------------------

GTPattern = new Type of HashTable 

-- Lighten the return output
net GTPattern := G -> net(G#"entries")


gtIndices = (n) -> (
    flatten apply(n, i -> apply(n-i,j -> (n-i,j+1)))
);




---------------------------------
-- 2. Basic properties of a GTPattern
---------------------------------

-- This is for a list of entries
isValidEntryList = (L) -> (
    n:=1;
    while n*(n+1)/2<#L do n=n+1;
    if #L!=n*(n+1)/2 then error "#L is not a triangular number";
    gtI:=gtIndices(n);
    -- Check the inequalities I*x <= v
    -- -l_(k,i) + l_(k-1,i) <= 0 for i=1,...,k-1;, k=2,...,n
    -- -l_(k-1,i) + l_(k,i+1) <= 0 for i=1,...,k-1; k=2,...,n
    H:=new HashTable from apply(#gtI, t -> gtI_t => L_t);
    for k from 2 to n do (
      for i from 1 to k-1 do (
	if -(H#(k,i)) + H#(k-1,i) > 0 then return false;
	if -(H#(k-1,i)) + H#(k,i+1) > 0 then return false;
      )
    );
    return true
);


gtContent = (n,H) -> (
    sums:=apply(toList(1..n), i -> sum apply(toList(1..i), j -> H#(i,j)));
    sums=prepend(0,sums);
    apply(n, i->sums_(i+1)-sums_i)
);


gtWeight = (n,H) -> (
    mu:=gtContent(n,H);
    mu=prepend(0,mu);
    apply(toList(1..(n-1)),i -> mu_i-mu_(i+1))
);



-- Construct a GTPattern from a list of entries
gtp = (L) -> (
    if not isValidEntryList(L) then error "Invalid entries" << endl;
    n:=0;
    while n*(n+1)/2<#L do n=n+1;
    if n*(n+1)/2!=#L then error "#L is not a triangular number" << endl;
    lambda:=apply(n, i -> L_i);
    gtI:=gtIndices(n);
    H:=new HashTable from apply(#gtI, t -> gtI_t => L_t);
    mu:=gtContent(n,H);
    nu:=gtWeight(n,H);
    new GTPattern from join({"shape"=>lambda,"entries"=>L,"content"=>mu,"weight"=>nu},apply(#gtI, t -> gtI_t => L_t))
);

gtPatternFromEntries = method(
    TypicalValue=>List
);

gtPatternFromEntries(List) := L -> gtp(L)




-* Test
isValidEntryList {2, 1, 0, 2, 1, 2}
isValidEntryList {2, 1, 0, 2, 1}
isValidEntryList {2, 1, 0, 2, 1, 3}
GTP0=gtp({2, 1, 0, 2, 1, 2})
peek GTP0

*-



--------------------------------------
-- 3. List the GTPatterns of shape lambda
--------------------------------------


-- First, create the Gelfand-Tsetlin polytope
-- Its lattice points give the patterns

-- polyhedronFromHData(I, v, E, w)
-- encodes {x in R | Ix <= v, Ex = w}

-- Following Molev 2018 pages 8-9

gtPolytope = method(
    TypicalValue=>List
);

gtPolytope(List) := (lambda) -> (
    n:=#lambda;
    gtI:=gtIndices(n);
    gtItoZ:=new HashTable from apply(#gtI, t -> {gtI_t,t});
    -- Step 1: Create the inequalities I*x <= v
    -- -l_(k,i) + l_(k-1,i) <= 0 for i=1,...,k-1;, k=2,...,n
    -- -l_(k-1,i) + l_(k,i+1) <= 0 for i=1,...,k-1; k=2,...,n
    I:={};
    for k from 2 to n do (
      for i from 1 to k-1 do (
	I = append(I,apply(#gtI, j -> if j==gtItoZ#(k,i) then -1 else if  j==gtItoZ#(k-1,i) then 1 else 0));
	I = append(I,apply(#gtI, j -> if j==gtItoZ#(k-1,i) then -1 else if  j==gtItoZ#(k,i+1) then 1 else 0));
      )
    );
    I = matrix I;
    v:=matrix apply(numrows I, t -> {0});
    -- Step 2: Create the equations
    -- l_(n,i) = lambda_i for i=1,...,n
    E:=matrix apply(n, i -> apply(#gtI, j -> if  j==gtItoZ#(n,i+1) then 1 else 0));
    w:=transpose matrix {lambda};
    polyhedronFromHData(I, v, E, w)
);


-- This returns a list of the entries

gtPatterns = method(
    TypicalValue=>List
);

gtPatterns(List) := memoize((lambda) -> (
    P:=gtPolytope(lambda);
    lp:=latticePoints(P);
    reverse sort apply(lp, M -> flatten entries M)
));



-*
Example: 

P = gtPolytope({2,1,0})
dim P
lp = latticePoints(P)
gtPatterns({2,1,0})

o46 = {{2, 1, 0, 1, 0, 0}, {2, 1, 0, 1, 0, 1}, {2, 1, 0, 1, 1, 1}, {2,
      ------------------------------------------------------------------
      1, 0, 2, 0, 0}, {2, 1, 0, 2, 0, 1}, {2, 1, 0, 2, 0, 2}, {2, 1, 0,
      ------------------------------------------------------------------
      2, 1, 1}, {2, 1, 0, 2, 1, 2}}


-- This agrees with the Sage output:

GTP: [[2, 1, 0], [1, 0], [0]], SSYT: [[2, 3], [3]], Wt: (0, 1, 2)
GTP: [[2, 1, 0], [1, 0], [1]], SSYT: [[1, 3], [3]], Wt: (1, 0, 2)
GTP: [[2, 1, 0], [1, 1], [1]], SSYT: [[1, 3], [2]], Wt: (1, 1, 1)
GTP: [[2, 1, 0], [2, 0], [0]], SSYT: [[2, 2], [3]], Wt: (0, 2, 1)
GTP: [[2, 1, 0], [2, 0], [1]], SSYT: [[1, 2], [3]], Wt: (1, 1, 1)
GTP: [[2, 1, 0], [2, 0], [2]], SSYT: [[1, 1], [3]], Wt: (2, 0, 1)
GTP: [[2, 1, 0], [2, 1], [1]], SSYT: [[1, 2], [2]], Wt: (1, 2, 0)
GTP: [[2, 1, 0], [2, 1], [2]], SSYT: [[1, 1], [2]], Wt: (2, 1, 0)

*-





---------------------------------
-- 5. Raising and lowering operators
---------------------------------




gtpPMDeltakiEntries = (GTP,pm,k,i) -> (
    n:=#(GTP#"shape");
    gtI:=gtIndices(n);
    apply(gtI, p -> if p==(k,i) then GTP#(k,i)+pm else GTP#p)
);



Ekk = (V, GTP, k) -> (
    c:=sum apply(toList(1..k), i -> GTP#(k,i));
    c = c - sum apply(toList(1..(k-1)), i-> GTP#(k-1,i));
    L := {{GTP,c}};
    lieAlgebraModuleElement(V,L)
);

-- N.B. l_(k,i) = lambda_(k,i)-i+1
Xk = (V, GTP, k) -> (
    L:={};
    num:=1;
    denom:=1;
    GTPPlusDeltakiEntries:={};
    GTPPlusDeltaki:={};
    for i from 1 to k do (
	GTPPlusDeltakiEntries:=gtpPMDeltakiEntries(GTP,1,k,i);
	if not isValidEntryList(GTPPlusDeltakiEntries) then continue;
	GTPPlusDeltaki=gtp(GTPPlusDeltakiEntries);
	num = product apply(toList(1..(k+1)), j -> (GTP#(k,i)-i+1)-(GTP#(k+1,j)-j+1));
	denom = product apply(toList(1..k), j -> if j==i then 1 else (GTP#(k,i)-i+1)-(GTP#(k,j)-j+1));
	L = append(L,{GTPPlusDeltaki,-num/denom})
    );
    lieAlgebraModuleElement(V,L)
);


-- N.B. l_(k,i) = lambda_(k,i)-i+1
Yk = (V, GTP, k) -> (
    L:={};
    num:=1;
    denom:=1;
    GTPMinusDeltakiEntries:={};
    GTPMinusDeltaki:={};
    for i from 1 to k do (
	GTPMinusDeltakiEntries:=gtpPMDeltakiEntries(GTP,-1,k,i);
	if not isValidEntryList(GTPMinusDeltakiEntries) then continue;
	GTPMinusDeltaki=gtp(GTPMinusDeltakiEntries);
	num = product apply(toList(1..(k-1)), j -> (GTP#(k,i)-i+1)-(GTP#(k-1,j)-j+1));
	denom = product apply(toList(1..k), j -> if j==i then 1 else (GTP#(k,i)-i+1)-(GTP#(k,j)-j+1));
	L = append(L,{GTPMinusDeltaki,num/denom})
    );
    lieAlgebraModuleElement(V,L)
);

writeInGTBasis = (f,BGT) -> (
    T:=f#"Terms";
    apply(BGT, p -> sum apply(T, t -> if (t_0)#"entries"==p then t_1 else 0))
);


HkrepresentationMatrix = (V,k,BGT) -> (
    (1/1)*(transpose matrix apply(BGT, p -> writeInGTBasis(Ekk(V,gtp(p),k)-Ekk(V,gtp(p),k+1),BGT)))
);


XkrepresentationMatrix = (V,k,BGT) -> (
    (1/1)*(transpose matrix apply(BGT, p -> writeInGTBasis(Xk(V,gtp(p),k),BGT)))
);


YkrepresentationMatrix = (V,k,BGT) -> (
    (1/1)*(transpose matrix apply(BGT, p -> writeInGTBasis(Yk(V,gtp(p),k),BGT)))
);


GTrepresentationMatrices = method(
    TypicalValue=>List
);

GTrepresentationMatrices(LieAlgebraModule) := (V) -> (
    if not isIrreducible(V) then error "Not implemented for reducible modules yet" << endl;
    lambda:=first keys(V#"DecompositionIntoIrreducibles");
    lambdaPartition:=dynkinToPartition(lambda);
    n:=#lambdaPartition;
    BGT:=gtPatterns(lambdaPartition);
    Xlabels:=flatten apply(n, i -> delete(null,apply(n, j -> if i<j then (i+1,j+1))));
    Ylabels:=flatten apply(n, i -> delete(null,apply(n, j -> if j<i then (i+1,j+1))));
    -- Create the representation matrices in order of |i-j|
    M:=new MutableHashTable from {};
    -- d=1
    for i from 1 to n-1 do (
        M#(i,i+1)=XkrepresentationMatrix(V,i,BGT);
	M#(i+1,i)=YkrepresentationMatrix(V,i,BGT);
    );
    for d from 2 to n-1 do (
        for i from 1 to n-d do (
            M#(i,i+d) = (M#(i,i+d-1))*(M#(i+d-1,i+d))-(M#(i+d-1,i+d))*(M#(i,i+d-1));
	    M#(i+d,i) = (M#(i+d,i+d-1))*(M#(i+d-1,i))-(M#(i+d-1,i))*(M#(i+d,i+d-1))
        )
    );
    Hmatrices:=apply(n-1, i -> HkrepresentationMatrix(V,i+1,BGT));
    Xmatrices:=apply(Xlabels, p -> M#p);
    Ymatrices:=apply(Ylabels, p -> M#p);
    flatten {Hmatrices,Xmatrices,Ymatrices}
);


-* Tests
sl3 = simpleLieAlgebra("A",2);
lambda={1,1}
lambdaPartition=dynkinToPartition(lambda);
BGT = gtPatterns(lambdaPartition);
sl3 = simpleLieAlgebra("A",2);
V = irreducibleLieAlgebraModule(lambda,sl3);
assert(BGT == {{2, 1, 0, 2, 1, 2}, {2, 1, 0, 2, 1, 1}, {2, 1, 0, 2, 0, 2}, {2, 1, 0, 2, 0, 1}, {2, 1, 0, 2, 0, 0}, {2, 1, 0, 1, 1, 1}, {2, 1, 0, 1, 0, 1}, {2, 1, 0, 1, 0, 0}}
)
H1GT = HkrepresentationMatrix(V,1,BGT);
assert(entries(H1GT)=={{1, 0, 0, 0, 0, 0, 0, 0}, {0, -1, 0, 0, 0, 0, 0, 0}, {0, 0, 2, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, -2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 0, 0, -1}})
X2GT = XkrepresentationMatrix(V,2,BGT);
assert(entries(X2GT)=={{0, 0, 1, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 0, 3, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 3/2, 0}, {0, 0, 0, 0, 0, 0, 0, 3/2}, {0, 0, 0, 0, 0, 0, 3/2, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}})
Y1GT = YkrepresentationMatrix(V,1,BGT);
assert(entries(Y1GT)=={{0, 0, 0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 1, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 1, 0}})


assert(GTrepresentationMatrices(V,lambda)=={matrix {{1, 0, 0, 0, 0, 0, 0, 0}, {0, -1, 0, 0, 0, 0, 0, 0}, {0, 0, 2, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, -2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 0, 0, -1/1}}, matrix {{1, 0, 0, 0, 0, 0, 0, 0}, {0, 2, 0, 0, 0, 0, 0, 0}, {0, 0, -1, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 1, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, -2, 0}, {0, 0, 0, 0, 0, 0, 0, -1/1}}, matrix {{0, 1, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 2, 0, 0, 0, 0}, {0, 0, 0, 0, 2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 1}, {0, 0, 0, 0, 0, 0, 0, 0/1}}, matrix {{0, 0, 0, -1, 0, 3, 0, 0}, {0, 0, 0, 0, -2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 3, 0}, {0, 0, 0, 0, 0, 0, 0, 3/2}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, -3/2}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0/1}}, matrix {{0, 0, 1, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 0, 3, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 3/2, 0}, {0, 0, 0, 0, 0, 0, 0, 3/2}, {0, 0, 0, 0, 0, 0, 3/2, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0/1}}, matrix {{0, 0, 0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 1, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 1, 0/1}}, matrix {{0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {-1/2, 0, 0, 0, 0, 0, 0, 0}, {0, -1/2, 0, 0, 0, 0, 0, 0}, {1/2, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 1/3, 0, 0, 0, 0, 0}, {0, 0, 0, 1/3, 0, -1, 0, 0/1}}, matrix {{0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0, 0, 0}, {0, 1/2, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 1/2, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 1/3, 0, 1, 0, 0}, {0, 0, 0, 0, 2/3, 0, 0, 0/1}}})
*-
