GroupElement = new Type of HashTable
CoxeterGroup = new Type of Monoid
DynkinDiagram = new Type of HashTable
Subgroup = new Type of Monoid
Subgroup.synonym = "subgroup"

-- COXETER SYSTEMS
-----------------------------------------------------------------

isCoxeterMatrix = method()

isCoxeterMatrix Matrix := m -> (
    if ring m =!= ZZ then false
    else (
	if rank source m == 0 then true
	else (
	    if any(flatten entries m, e -> e < 0) then false
	    else (
	    	if transpose m =!= m then false
	    	else (
		    all(numColumns m, j -> 
		    	all(j + 1, i -> if i == j then m_j_i == 1 else m_j_i >= 2 or m_j_i == 0 )
		    	)
		    )
	    	)
	    )
	)
    )


-- WORDS
-----------------------------------------------------------------

net GroupElement := g -> (
    expr := g.normalForm;
    if #expr == 0 then net (1_ZZ)
    else net concatenate apply(2*#expr - 1, i -> if even i then toString expr#(i//2) else "*")
    )


-----------------------------------------------------------------

expressions = method()

expressions GroupElement := List => g -> g.cache#(symbol expressions)


-----------------------------------------------------------------

wordToGroup = method()

wordToGroup (List, CoxeterGroup) := (word, W) -> (
    if #word == 0 then {}
    else apply(word, s -> first select(gens W, t -> normalForm t === {s}) )
    )


-----------------------------------------------------------------

exchanges = method()

exchanges (List, GroupElement) := List => (w, s) -> (
    W := group s;
    if not isSubset(set w, gens W) then (
	error "exchanges: Expected a list of generators of the Coxeter group of the group element."
	);
    if #w == 0 then {}
    else if #w == 1 then (
	if w#0 == s then {0} else {}
	)
    else (
    	rep := reflectionRep W;
	S := gens W;
	V := target cartanMatrix W;
	pos := u ->  position(S, t -> t == u);
	beta := id_V; 
	select(reverse toList(0..#w - 1), i -> 
	    if i == #w - 1 then pos last w == pos s  
	    else (
		beta = (rep w#(i+1))*beta;
		beta_(pos s)  == (id_V)_(pos w#i)
		) 
	    )
	)
    )

exchanges (GroupElement, GroupElement) := List => (w, s) -> (
    if group w =!= group s then error "exchanges: Expected group elements in the same Coxeter group.";
    exchanges(wordToGroup(normalForm w, group s), s)
    )

-----------------------------------------------------------------

descentSet = method(Options => {Left => false, AllReflections => false})

descentSet GroupElement := List => o -> w -> (
    if o.Left then descentSet(w^(-1), AllReflections => o.AllReflections)
    else (
	if o.AllReflections then (
	    W := group w;
	    T := reflections W;
	    rho := reflectionRep W;
	    apply(select(T, t -> (
			beta :=  transpose matrix entries transpose ((rho w)*(roots t));
			-- recreating the matrix adds in degrees that are not there otherwise
			(set ((roots W)#"-"))#?beta ) ), 
		t -> position(T, u -> u == t) )
	    )
	else (
	    S := gens group w;
	    apply(select(S, s -> #(exchanges(w, s)) > 0 ), s -> position(S, t -> t == s) )
	    )
	)
    )


-----------------------------------------------------------------

reduceWord = method()

reduceWord (List, CoxeterGroup) := List => (word, W) -> (
    if #word <= 1 then word
    else (
	S := gens W;
	-- Write word = w*s.
	w := drop(word, -1);
	-- Get reduced word for w by induction.
	w = reduceWord(w, W);
	word = wordToGroup(w|{last word}, W);
	s := last word;
	w = drop(word, -1);
    	exch := exchanges(w, s);
	-- Check whether w*s is reduced.
	-- If not, omit a suitable generator from w to obtain an expression 
	-- for word with 2 fewer factors.
	-- In that case, since length w > length w*s >= length w - 1, we see
	-- length w*s =  length w - 1 so that this new expression must be reduced.
	if #exch > 0 then word = drop(w, {first exch, first exch});
	apply(word, s -> first normalForm s)
	) 
    )

--INPUT: A list of indexed variables representing a word of a Coxeter group.
--OUTPUT: A list of indexed variables representing a reduced word for the given word.

	
-----------------------------------------------------------------	
	
normalForm = method()

normalForm GroupElement := List => g -> g.normalForm	

normalForm (List, CoxeterGroup) := List => (word, W) -> (
    -- Find a reduced expression for word.
    word = reduceWord(word, W);
    if #word <= 1 then word
    else (
	-- Rewrite word = w*s, and get normal form for w.
	-- Note that, since word is reduced, so are w and (nf w)*s.
	if #word >= 2 then (
	    word = wordToGroup(word, W);
	    s := last word;
	    w := wordToGroup(normalForm product drop(word, -1), W);
	    S := gens W;
    	    rep := reflectionRep W;
	    pos := u ->  position(S, t -> t == u);
	    V := target cartanMatrix W;
	    beta := id_V;
	    i := #w - 1;
	    local swaps;
	    -- Check whether there is a lex smaller reduced word for (nf w)*s obtained by
	    -- removing s and inserting a smaller generator in a suitable position.
	    while i >= 0 do(
	    	beta = (rep w#i)*beta;
	    	swaps = select(pos w#i, j -> beta_(pos s) == (id_V)_j );
	    	if #swaps > 0 then (
	    	    word = take(w, i)|{S#(first swaps)}|drop(w, i);
		    );
	    	i = i - 1
	    	)
	    );
	apply(word, s -> first normalForm s)
	) 
    )
	
-----------------------------------------------------------------

putInGroup = method()

putInGroup (List, CoxeterGroup) := (expr, W) -> (
    nf := reduceWord(expr, W);
    new W from hashTable {
	    (symbol group) => W,
	    (symbol cache) => new CacheTable from {
	    (symbol expressions) => unique {nf, expr}
	    },
       	(symbol normalForm) => nf,
        (symbol length) => #nf,
	(symbol sign) => (-1)^#expr
	}
    )


-----------------------------------------------------------------

isReduced = method()

isReduced (List, CoxeterGroup) := Boolean => (w, W) -> reduceWord(w, W) == w


-- COXETER GROUP CONSTRUCTORS
----------------------------------------------------------------- 
 
new CoxeterGroup from List := (CoxeterGroup, inits) -> new CoxeterGroup of GroupElement from new HashTable from inits

coxeterGroup = method(Options => {Variable => "s"})

coxeterGroup (List, Matrix) := CoxeterGroup => o -> (S, m) -> (
    if not isCoxeterMatrix m then error "coxeterGroup: Expected a Coxeter matrix.";
    if #S =!= numColumns m then (
	error "coxeterGroup: Expected the number of generators to match the number of columns of
	the matrix"
	);
    -- get the symbols associated to the list that is passed in, in case the variables have been used earlier.
    --if #varList == 0 then error "Expected at least one variable.";
    --if #varList == 1 and class varList#0 === Sequence then varList = toList first varList;
   
    W := new CoxeterGroup from {
	(symbol generators) => {},
        (symbol generatorSymbols) => S,
	(symbol coxeterMatrix) => m,
        (symbol cache) => new CacheTable from {}
	};
    
    newGens := apply(S, s -> s <- putInGroup({s}, W) );
    W#(symbol generators) = newGens;
   
    W ^ ZZ := (w, n) -> (
       if w == id_W then id_W 
       else (
       	   if n == 0 then id_W 
       	   else if n > 0 then product toList (n:w) 
       	   else if n == -1 then product wordToGroup(reverse normalForm w, W)
       	   else product toList(-n: w^(-1))
	   )
       );
   
    W ? W := (w, v) -> normalForm w ? normalForm v;

    W == W := (w, v) -> normalForm w === normalForm v;
       
    W * W := (w, t) -> (
	nf := normalForm((normalForm w)|(normalForm t), W);
	new W from hashTable {
	    (symbol group) => W,
	    (symbol cache) => new CacheTable from {
	    (symbol expressions) => unique ({nf}|(flatten apply(expressions w, 
		       e -> apply(expressions t, e' -> e|e') ) ) )
	    },
       	(symbol normalForm) => nf,
        (symbol length) => #nf,
	(symbol sign) => (sign w)*(sign t)
        }
    );
   
    W
    )

coxeterGroup Matrix := CoxeterGroup => o -> m -> (
    s := getSymbol o.Variable;
    coxeterGroup(apply(numRows m, i -> s_i), m)
    )

coxeterGroup (List, DynkinDiagram) := CoxeterGroup => o -> (S, D) -> (
    V := vertices graph D;
    if #S =!= #V then (
	error "coxeterGroup: Expected the Dynkin diagram to have as many vertices as the
	list of generators."
	);
    E := set edges graph D;
    m := matrix apply(V, u -> apply(V, v -> 
	    if u == v then 1 
	    else if (weights D)#?(sort {u,v}) then (weights D)#(sort {u,v})
	    else if E#?(set {u, v}) then 3
	    else 2
	    )
	);
    coxeterGroup(S, m)
    ) 

coxeterGroup DynkinDiagram := CoxeterGroup => o -> D -> (
    s := getSymbol o.Variable;
    V := vertices graph D;
    coxeterGroup(apply(#V, i -> s_i), D)
    ) 

coxeterGroup Graph := CoxeterGroup => o -> G -> (
    coxeterGroup dynkinDiagram(G, apply((edges G)/toList/sort, e -> e => 0) ) 
    )

coxeterGroup Subgroup := CoxeterGroup => o -> P -> (
    if #(P_*) == 0 then coxeterGroup({}, matrix {{}})
    else (
    	W := group P;
    	D := dynkinDiagram W;
    	S := gens W;
    	G := inducedSubgraph(graph D, apply(P_*, s -> position(S, t -> t == s) ) );
    	E := (edges G)/toList/sort;
    	wgt := select(pairs weights D, p -> (set E)#?(p_0)); 
    	coxeterGroup(flatten apply(P_*, s -> normalForm s), dynkinDiagram(G, wgt) )
	)
    )


-----------------------------------------------------------------

CoxeterGroup _ ZZ := GroupElement => (W, i) -> (gens W)#i

CoxeterGroup _ List := GroupElement => (W, w) -> (
    if #w == 0 then id_W
    else product apply(w, i -> W_i)
    )


-----------------------------------------------------------------

net CoxeterGroup := W -> (
    hasAttribute := value Core#"private dictionary"#"hasAttribute";
    getAttribute := value Core#"private dictionary"#"getAttribute";
    ReverseDictionary := value Core#"private dictionary"#"ReverseDictionary";
    if hasAttribute(W,ReverseDictionary) then toString getAttribute(W,ReverseDictionary)
    else (
	net "W("|
	net concatenate drop(drop(characters toString apply(W.generators, s -> net s), 1 ), -1)
    	|")"
	)
    )


CoxeterGroup#{Standard,AfterPrint} = CoxeterGroup#{Standard,AfterNoPrint} = W -> (
     << endl;				  -- double space
     << concatenate(interpreterDepth:"o") << lineNumber << " : " << class W <<  
     (if W.cache#?hasType then (
	  horizontalJoin(" of type ", W.cache#hasType)
	 ) else (" ") ) << endl;
     )
-- Magic code for having Macaulay2 print the types of specific Coxeter groups.

-----------------------------------------------------------------

coxeterMatrix = method()

coxeterMatrix CoxeterGroup := Matrix => W -> W.coxeterMatrix

generators CoxeterGroup := List => o -> W -> W.generators

group = method()

group GroupElement := g -> g.group

id CoxeterGroup := W -> putInGroup({}, W);

length GroupElement := ZZ => w -> w.length

numgens CoxeterGroup := ZZ => W -> #(gens W)

CoxeterGroup * CoxeterGroup := (W, W') -> (
    D := dynkinDiagram W;
    D' := dynkinDiagram W';
    coxeterGroup(D + D')
    )

-----------------------------------------------------------------

relations CoxeterGroup := List => W -> (
    if W.cache#?(symbol relations) then W.cache#(symbol relations)
    else (
	m := coxeterMatrix W;
	rels := select(apply(flatten apply(numgens W, i -> apply(i + 1, j -> {j, i})),
		 p -> {p, m_(p#0)_(p#1)}), r -> last r > 0);
	rels = apply(rels, r -> flatten apply(last r, t -> apply(first r, i -> W_i) ) );
	W.cache#(symbol relations) = rels;
	rels
	)
    )


-----------------------------------------------------------------

groupOrder = method(Options => {DegreeLimit => 20})

groupOrder GroupElement := ZZ => o -> g -> (
    G := group g;
    i := 1;
    while g^i =!= id_G and i <= o.DegreeLimit do i = i + 1;
    if g^i =!= id_G then error "groupOrder: Degree limit exceeded.  Element may have infinite order.";
    i
    )

groupOrder CoxeterGroup := ZZ => o -> W -> if not isFiniteGroup W then infinity else #(groupElements W)    


-----------------------------------------------------------------

sign = method()

sign GroupElement := g -> g.sign


-----------------------------------------------------------------

isFiniteGroup = method()

isFiniteGroup CoxeterGroup := W -> (
    if W.cache#?hasType then (
	if #(W.cache#hasType) == 2 then true else false
	)
    else (
	D := dynkinDiagram W;
	if not isForest graph D then false
	else (
	    cmps := apply(connectedComponents graph D, 
	    	C -> ( inducedSubgraph(graph D, C), hashTable select(pairs weights D, p -> isSubset(p_0, C) ) )
	    	);
	    all(cmps, C -> (
		    L := set leaves C_0;
		    if #L == 0 then true
		    -- Identify types A, B, F, H, and I
		    else if #L == 2 then (
		    	-- Identify type An (n >= 2)
		    	if #(pairs C_1) == 0 then true
		    	else if #(pairs C_1) > 1 then false
		    	else (
			    V := vertices C_0;
			    -- Identify type I
			    if #V == 2 then (
				if first values C_1 > 0 then true
				else false
				)
			    else (
			    	wgt := first pairs C_1;
			    	-- Identify types B and F
			    	if wgt_1 == 4 then (
				    if #V == 4 and #((set wgt_0)*L) == 0 then true
				    else if #((set wgt_0)*L) == 1 then true
				    else false
				    )
			    	-- Identify type H
			    	else if wgt_1 == 5 then (
				    if #V > 4 then false 
				    else if #((set wgt_0)*L) == 1 then true 
				    else false
				    )
			    	else false
			    	)
			    )
		    	)
		    -- Identify types D and E
		    else if #L == 3 then (
		    	if #(pairs C_1) =!= 0 then false 
		    	else (
			    deg3 := select(vertices C_0, v -> degree(C_0, v) == 3);
		    	    if set deg3 =!= set select(vertices C_0, v -> degree(C_0, v) >= 3) 
		    	    or #deg3 =!= 1 then false
		    	    else (
			    	N := toList neighbors(C_0, deg3#0);
			    	Ndeg := apply(N, w -> degree(C_0, w) );
			    	if min Ndeg =!= 1 then false
			    	-- Identify type D
			    	else if set Ndeg === set {1, 2, 2} then true
			    	-- Identify type E
			    	else any(select(N, w -> degree(C_0, w) == 2), w -> 
				    min apply(toList neighbors(C_0, w), u -> degree(C_0, u) ) == 1 
				    )
			    	)
			    )
		    	)
		    else false
		    )
		)
	    )
	)
    )


isFiniteGroup Subgroup := Boolean => H -> (
    if H.cache.?isFiniteGroup then H.cache.isFiniteGroup
    else error "isFiniteGroup: Not implemented yet."
    )
   

-----------------------------------------------------------------

groupElements = method(Options => {Format => "list"})


groupElements CoxeterGroup := List => o -> W -> (
    if W.cache#?groupElements then (
	if o.Format == "hashtable" then W.cache#groupElements
	else flatten values W.cache#groupElements
	)
    else (
    	if not isFiniteGroup W then error "groupElements: Expected a finite Coxeter group.";
    	S := gens W;
    	elts := hashTable {0 => {id_W}, 1 => S};
    	l := 1;
    	asc := select(apply(elts#l, w -> (w, toList( (set(0..#S - 1)) - descentSet w) ) ), 
	    p -> #(p#1) > 0 ); 
    	while #asc > 0 do(
	    elts = hashTable ((pairs elts)|{(l+1, unique flatten apply(asc, 
			(w, a) -> apply(a, i -> w*(S#i) ) ) )} 
	    );
	    l = l + 1;
	    asc = select(apply(elts#l, w -> (w, toList( (set(0..#S - 1)) - descentSet w) ) ), 
	    	p -> #(p#1) > 0 )
	    );
	W.cache#(symbol groupElements) = elts;
	if o.Format == "hashtable" then elts
	else flatten values elts
	)
    )


-----------------------------------------------------------------

longWord = method()

longWord CoxeterGroup := GroupElement => W -> (
    elts := groupElements(W, Format => "hashtable");
    N := max keys elts;
    first (elts#N)
    )


-- THE REFLECTION REPRESENTATION
-----------------------------------------------------------------

cartanMatrix = method()

cartanMatrix CoxeterGroup := Matrix => W -> (
    if W.cache#?(symbol cartanMatrix) then W.cache#(symbol cartanMatrix)
    else (
    	m := entries coxeterMatrix W;
    	n := 2*lcm select(flatten m, e -> e > 0);
    	kk := cyclotomicField n;
    	z := first (coefficientRing kk)_*;
    	A := matrix apply(m, r -> apply(r, e -> if e == 0 then -1 else -(z^(n//(2*e)) + z^(n - n//(2*e)))/2 ) );
	W.cache#(symbol cartanMatrix) = A;
	A
	)
    )


-----------------------------------------------------------------

reflectionRepresentatives = method()

reflectionRepresentatives CoxeterGroup := List => W -> (
    if W.cache#?reflectionRepresentatives then W.cache#reflectionRepresentatives
    else (
	A := cartanMatrix W;
    	r := apply(numgens W, i -> id_(target A) - 2*(matrix apply(numRows A, 
		    r -> apply(numColumns A, c -> if r == i then A_c_r else 0_(ring A) ) ) )
	    ); 
	W.cache#(symbol reflectionRepresentatives) = r;
	r
	)
    ) 
 
 
reflectionRep = method()

reflectionRep CoxeterGroup := Matrix => W -> (
    if W.cache#?(symbol reflectionRep) then W.cache#(symbol reflectionRep)
    else (
    	r := hashTable apply(numgens W, i -> (gens W)#i => (reflectionRepresentatives W)#i );
	rep := w -> (
	    V := target cartanMatrix W;
	    if length w == 0 then id_V else (
		word := flatten apply(if instance(w, List) then w else normalForm w, 
		    t -> wordToGroup({t}, W) );
	    	product apply(word, t -> r#t)
		)
	    ); 
	W.cache#(symbol reflectionRep) = rep;
	rep
	)
    )


-----------------------------------------------------------------

roots CoxeterGroup := HashTable => {} >> o -> W -> (
    if W.cache#?(symbol roots) then W.cache#(symbol roots)
    else (
    	if not isFiniteGroup W then error "roots: Not yet implemented for infinite Coxeter groups.";
	S := gens W;
    	elts := groupElements W;
    	rho := reflectionRep W;
	neg := {};
	refl := {};
    	scan(elts, w -> (
		cols := apply(entries transpose rho w, c -> transpose matrix {c});
		newNeg := apply(descentSet w, i -> cols#i);
		neg = neg|newNeg;
		refl = refl|apply(cols - set newNeg, c -> (w, position(cols, d -> d == c), c) )
		)
	    );
	refl = applyValues(partition(e -> last e, refl), v -> drop(first v, -1) );
	refl = applyValues(refl, v -> (v#0)*(S#(v#1))*(v#0)^(-1) );
	W.cache#(symbol reflections) =  values refl; 
	W.cache#(symbol rootPairs) = hashTable ((pairs refl)/reverse); 
	R := hashTable {"+" => keys refl, "-" => unique neg};
	W.cache#(symbol roots) = R;
	R
	)
    )

roots GroupElement := Matrix => {} >> o -> t -> (
    W := group t;
    if not W.cache#?(symbol reflections) then roots W;
    if not (set reflections W)#?t then error "roots: Expected a reflection of a Coxeter group.";
    W.cache#(symbol rootPairs)#t
    )


-----------------------------------------------------------------

reflections = method()

reflections CoxeterGroup := List => W -> (
    if W.cache#?(symbol reflections) then W.cache#(symbol reflections)
    else (
	roots W;
	W.cache#(symbol reflections)
	)
    )


-- DYNKIN DIAGRAMS
-----------------------------------------------------------------

graph DynkinDiagram := Graph => o -> D -> D.graph

weights = method()
weights DynkinDiagram := Graph => D -> D.weights

net DynkinDiagram := D -> net (graph D, weights D)

DynkinDiagram + DynkinDiagram := (D, D') -> (
    Dweights := apply(pairs weights D, (e, w) -> ({{e_0, 0}, {e_1, 0}}, w) );
    D'weights := apply(pairs weights D', (e, w) -> ({{e_0, 1}, {e_1, 1}}, w) );
    dynkinDiagram(disjointUnion {graph D, graph D'}, Dweights|D'weights)
    )

-----------------------------------------------------------------

dynkinDiagram = method()

dynkinDiagram (Graph, List) := DynkinDiagram => (G, w) -> (
    D := new DynkinDiagram from hashTable {
	(symbol graph) => G,
        (symbol weights) => hashTable w,
        (symbol cache) => new CacheTable from {}
	};
    D
    )

dynkinDiagram Graph := DynkinDiagram => G -> dynkinDiagram(G, {})

dynkinDiagram CoxeterGroup := DynkinDiagram => W -> (
    m := coxeterMatrix W;
    V := toList(0..numgens W - 1);
    G := graph(V, select(subsets(V, 2), e -> m_(e#0)_(e#1) >= 3 or m_(e#0)_(e#1) == 0) );
    w := apply(select(subsets(V, 2), e -> m_(e#0)_(e#1) >= 4 or m_(e#0)_(e#1) == 0), 
	e -> e => m_(e#0)_(e#1) );
    dynkinDiagram(G, w)
    )


-----------------------------------------------------------------

specificDynkin = method()

specificDynkin String := DynkinDiagram => name -> (
    if not (set("A", "B", "C", "D", "E", "F", "G", "H", "I"))#?(first name) then (
	error "specificDynkin: Expected the first character to be A, B, C, D, E, F, G, H, or I."
	);
    n := value last name;
    if not instance(value last name, ZZ) then (
	error "specificDynkin: Expected the last character to be an integer."
	);
    if not instance(value(name#1),ZZ) and name#1 =!= "'" then (
	error "specificDynkin: Not one of the named Dynkin diagrams."
	); 
    if first name == "A" then (
	if n <= 0 then error "specificDynkin: Expected a positive integer.";
	if n >= 2 then (
	    if #name == 2 then dynkinDiagram pathGraph n else dynkinDiagram cycleGraph(n + 1)
	    )
	else (
	    -- fix issue with pathGraph 1 having no vertices
	    if #name == 2 then dynkinDiagram graph({0}, {}) 
	    else dynkinDiagram(pathGraph 2, {{0,1} => 0})
	    )
	)
    else if first name == "B" then (
	if n <= 1 then error "specificDynkin: Expected an integer greater than or equal to 2.";
	if #name == 2 then dynkinDiagram(pathGraph n, {{n-2, n-1} => 4})
	else (
	    if n <= 2 then error "specificDynkin: Expected an integer greater than or equal to 3.";
	    dynkinDiagram(addEdges'(addVertices(pathGraph n, {n, n+1}), {{0, n},{0, n+1}}), 
		{{n-2, n-1} => 4})
	    )
	)
    else if first name == "C" then (
	if #name == 2 then error "specificDynkin: Not one of the named Dynkin diagrams.";
	if n <= 1 then error "specificDynkin: Expected an integer greater than or equal to 2.";
	dynkinDiagram(pathGraph n, {{0, 1} => 4, {n-2, n-1} => 4})
	)
    else if first name == "D" then (
	if n <= 3 then error "specificDynkin: Expected an integer greater than or equal to 4.";
	if #name == 2 then (
	    dynkinDiagram(addEdges'(addVertices(pathGraph(n-2), {n-2, n-1}), 
		    {{n-3, n-2},{n-3, n-1}}) )
	    )
	else (
	    dynkinDiagram(addEdges'(addVertices(pathGraph(n-2), {n-2, n-1, n, n+1}), 
		    {{n-3, n-2},{n-3, n-1},{0, n},{0, n+1}}) )
	    )
	)
    else if first name == "E" then (
	if not (set {6, 7, 8})#?n then (
	    error "specificDynkin: Expected the last character to be 6, 7, or 8."
	    );
	if #name == 2 then (
	    dynkinDiagram(addEdges'(addVertices(pathGraph(n-1), {n-1}), {{2, n-1}}) )
	    )
	else (
	    if n == 6 then (
		dynkinDiagram(addEdges'(addVertices(pathGraph 5, {5, 6}), {{2, 5}, {5, 6}}) )
	    )
	    else if n == 7 then (
		dynkinDiagram(addEdges'(addVertices(pathGraph 7, {7}), {{3, 7}}) )
		)
	    else (
		dynkinDiagram(addEdges'(addVertices(pathGraph 8, {9}), {{2, 9}}) )
		)
	    )
	)
    else if first name == "F" then (
	if n =!= 4 then error "specificDynkin: Expected the last character to be 4.";
	if #name == 2 then dynkinDiagram(pathGraph 4, {{1,2} => 4}) else dynkinDiagram(pathGraph 5, {{2,3} => 4})
	)
    else if first name == "G" then (
	if n =!= 2 then error "specificDynkin: Expected the last character to be 2.";
	dynkinDiagram(pathGraph 3, {{1,2} => 6})
	)
    else if first name == "H" then (
	if not (set {3, 4})#?n then (
	    error "specificDynkin: Expected the second character to be 3 or 4."
	    );
	dynkinDiagram(pathGraph n, {{0,1} => 5})
	)
    else if first name == "I" then (
	if n <= 1 then error "specificDynkin: Expected an integer greater than or equal to 2.";
	dynkinDiagram(pathGraph 2, {{0,1} => n})
	)
    )


-- SPECIFIC COXETER GROUPS
-----------------------------------------------------------------

specificCoxeterGroup = method()

specificCoxeterGroup (List, String) := CoxeterGroup => (S, name) -> (
    W := coxeterGroup(S, specificDynkin name); 
    W.cache#(symbol hasType) = name;
    W
    )

specificCoxeterGroup String := CoxeterGroup => name -> (
    W := coxeterGroup specificDynkin name; 
    W.cache#(symbol hasType) = name;
    W
    )


-----------------------------------------------------------------

symmetricGroup = method()

symmetricGroup ZZ := CoxeterGroup => n -> (
    if n < 2 then error "symmetricGroup: Expected an integer greater than 1.";
    S := specificCoxeterGroup("A"|(toString (n - 1) ) );
    S.cache#(symbol permutationAction) = hashTable apply(numgens S, i -> S_i => l -> take(l, i)|{l#(i+1), l#i}|drop(l, i + 2) );
    S
    )

toList GroupElement := List => w -> (
    S := group w;
    if not (S.cache)#?hasType or not (first S.cache#hasType == "A"
    or first S.cache#hasType == "B") then (
	error "toList: Expected an element of a symmetric or hyperoctahedral group."
	);
    a := (s, l) -> ((S.cache#(symbol permutationAction))#s) l;
    l := if first S.cache#hasType == "A" then toList(0..(numgens S)) else toList(1..(numgens S));
    expr := wordToGroup(normalForm w, S);
    fold(reverse expr, l, a)
    )
    

CoxeterGroup_List := (S, p) -> (
    if not (S.cache)#?hasType or not (first S.cache#hasType == "A"
    or first S.cache#hasType == "B") then (
	error "toList: Expected an element of a symmetric or hyperoctahedral group."
	);
    neg := select(#p, i -> p#i < 0);
    if first S.cache#hasType == "B" then p = apply(p, i -> (abs i) - 1);
    parityAdjust := if #neg > 0 then product flatten apply(neg, i -> (
	    w := apply(#p - i - 1, j -> S_(i+j) );
	    w|{last gens S}|(reverse w)
	    ) ) else id_S;
    if first S.cache#hasType == "A" then (
	if #p =!= numgens S + 1 or set p =!= set(0..#p-1) then (
	    error "Expected a list representing the one-line notation of a permutation in the symmetric group."
	    )
	)
    else if #p =!= numgens S or set p =!= set(0..#p-1) then (
	    error "Expected a list representing the one-line notation of a permutation in the hyperoctahedral group."
	    );
    lowerInver := i -> #select(i, j -> p#j > p#i);  
    inverExc := select(#p, i -> p#i + lowerInver i > i);
    swaps := product flatten apply(inverExc, i -> 
	reverse apply(p#i - i + lowerInver i, j -> S_(i+j) ) );
    swaps*parityAdjust
    )


-----------------------------------------------------------------

Tableau = new Type of HashTable

tableau = method()

tableau List := Tableau => t -> (
    if not all(t, r -> instance(r, List)) or any(#t - 1, i -> #(t#i) < #(t#(i+1)) ) or 
    not all(t, r -> all(r, e -> instance(e, ZZ) and e >= 0) ) then (
	error "tableau: Expected a list of lists of non-negative integers of non-increasing lengths."
	);
    T := new Tableau from hashTable {
	(symbol rows) => hashTable apply(#t, i -> i => t#i),
	(symbol partition) => apply(t, r -> #r),
	(symbol partition) => apply(t, r -> #r),
	(symbol size) => sum apply(t, r -> #r),
	(symbol cache) => new CacheTable from {}
	};
    
    T
    )

tableau (GroupElement, List) := Tableau => (p, d) -> (
    S := group p;
    if not (S.cache)#?hasType or not (first S.cache#hasType == "A") then (
	error "toList: Expected an element of a symmetric group."
	);
    p = toList p;
    tableau apply(reverse sort d, k ->  sort take(p, k + 1) )
    )

net Tableau := T -> (
    rows := values T.rows;
    stack apply(rows, r -> 
	netList({r}, Boxes => true, Alignment => Center, HorizontalSpace => 3, VerticalSpace => 1) )
    )
    

-----------------------------------------------------------------

hyperoctahedralGroup = method()

hyperoctahedralGroup ZZ := CoxeterGroup => n -> (
    H := specificCoxeterGroup("B"|(toString n ) );
    H.cache#(symbol permutationAction) = hashTable apply(n, i -> 
	if i == n - 1 then H_(n - 1) => l -> drop(l, -1)|{-(last l)}
	else H_i => l -> take(l, i)|{l#(i+1), l#i}|drop(l, i + 2) 
	);
    H
    )


-----------------------------------------------------------------

dihedralGroup = method(Options => {Variables => {"s", "t"}})

dihedralGroup ZZ := CoxeterGroup => o -> n -> (
    specificCoxeterGroup(o.Variables/getSymbol, "I"|(toString n))
    )


-- SUBGROUPS
-----------------------------------------------------------------

Subgroup#{Standard,AfterPrint} = Subgroup#{Standard,AfterNoPrint} = (H) -> (
     << endl;				  -- double space
     << concatenate(interpreterDepth:"o") << lineNumber << " : Subgroup of " << group H << endl;
     )
-- Magic code for having Macaulay2 print which group the subgroup belongs to.

-----------------------------------------------------------------

subgroupPrepare = method()
subgroupPrepare GroupElement := identity
subgroupPrepare Subgroup := H -> H_*
subgroupPrepare Thing :=  x -> error "expected a list of group elements or subgroups"

-- Work-around for ensuring lists passed to subgroups consist of group elements, 
-- following idealPrepare for ideal.


-----------------------------------------------------------------

subgroup = method()

subgroup List := Subgroup => J -> (
    if #J == 0 then (
	error "subgroup: Expected a nonempty list."
	);
    if any(J, w -> not instance(class w, CoxeterGroup) ) then (
	error "subgroup: Expected a list of Coxeter group elements."
	);
    W := group first J;
    if any(J, w -> group w =!= W) then (
	error "subgroup: Expected a list of elements of the same Coxeter group."
	);
    J = flatten apply(toList splice J, subgroupPrepare);

    H := new Subgroup from hashTable{
	(symbol generators) => J,
	(symbol group) => W,
        (symbol cache) => new CacheTable from {
	    (symbol relationTables) => hashTable apply(relations W, r -> 
		    r => hashTable {0 => apply(#r + 1, 
			    i -> if i == 0 or i == #r then 0 else ".")} 
		    ),
	    (symbol schriererGraph) => hashTable apply(gens W, s -> s => digraph({0}, {}) ),
	    (symbol transversal) => {id_W},
	    (symbol DegreeLimit) => 1, 
	    (symbol CompleteComputation) => false
	    }
	};
    
    if J == {id_W} then (
	H.cache.isParabolic = true;
	H.cache.conjugate = id_W;
	H.cache.cosetEquals = (u, w) -> u == w;
	); 
    
    if isSubset(J, gens W) then (
	H.cache.isParabolic = true;
	H.cache.conjugate = id_W;
	H.cache.cosetEquals = (u, w) -> isSubset(wordToGroup(normalForm(w^(-1)*u), W), J);
	);
    
    H
    )

-- subgroup Sequence := Subgroup =>  J -> subgroup flatten apply(toList splice J,subgroupPrepare)

-----------------------------------------------------------------

isParabolic = method()

isParabolic Subgroup := Boolean => H -> (
    if H.cache.?isParabolic then H.cache.isParabolic
    else (
	error "isParabolic: Not yet implemented."
	)
    )


-----------------------------------------------------------------

isNormal = method()

isNormal Subgroup := Boolean => o -> H -> (
    W := group H;
    q := quotientMap H;
    all(gens W, s -> all(gens H, h -> q (h^s) == id_W) )
    )


-----------------------------------------------------------------

conjugate (GroupElement, GroupElement) := Subgroup => (s, w) -> (
    if not instance(w, group s) then (
	error "Expected a group elements from the same Coxeter group."
	);
    w*s*w^(-1)
    )

GroupElement ^ GroupElement := GroupElement => (s, w) -> conjugate(s, w)

conjugate (Subgroup, GroupElement) := Subgroup => (H, w) -> (
    W := group H;
    if not instance(w, W) then (
	error "Expected a group element from the same Coxeter group as the subgroup."
	);
    Hw := new Subgroup from hashTable{
	(symbol generators) => apply(gens H, h -> h^w),
	(symbol group) => group H,
        (symbol cache) => new CacheTable from {
	    (symbol relationTables) => H.cache.relationTables,
	    (symbol schriererGraph) => H.cache.schriererGraph,
	    (symbol transversal) => apply(H.cache.transversal, u -> u^w),
	    (symbol DegreeLimit) => H.cache.DegreeLimit, 
	    (symbol CompleteComputation) => H.cache.CompleteComputation
	    }
	};
    
    if H.cache.?isParabolic and H.cache.isParabolic then (
	g := (H.cache.conjugate)*w^(-1);
	Hw.cache.isParabolic = true;
	Hw.cache.conjugate = g;
	Hw.cache.cosetEquals = (u, v) -> H.cache.cosetEquals(u^g, v^g);
	);
    
    Hw
    )

Subgroup ^ GroupElement := Subgroup => (H, w) -> conjugate(H, w)


commutator = method()

commutator (GroupElement, GroupElement) := GroupElement => (g, h) -> (h^g)*(h^(-1))

-----------------------------------------------------------------

generators Subgroup := List => o -> H -> H.generators

Subgroup_* := List => H -> gens H

group Subgroup := H -> H.group

numgens Subgroup := ZZ => H -> #(gens H)

net Subgroup := H -> (
    net "subgroup ("|
    net concatenate drop(drop(characters toString apply(H.generators, s -> net s), 1 ), -1)
    |net ")"
    )


-*

QuotientSet = new Type of HashTable

quotient Subgroup := QuotientSet => P -> (
    if not P.parabolic then error "quotient: Expected a parabolic subgroup of a Coxeter group.";
    W := group P;
    X := new QuotientSet from hashTable {
	(symbol group) => W,
	(symbol subgroup) => P,
	(symbol cosets) =>
	(symbol cache) => new CacheTable from {}
	}
    )
*-


-- BRUHAT + WEAK ORDERS
-----------------------------------------------------------------

isSubword = method()

isSubword (List, List) := Boolean => (w, v) -> (
    local pos;
    while #w > 0 do(
	if not isSubset(w, v) then break 
	else (
	    pos = position(v, s -> s == first w);
	    w = drop(w, 1);
	    v = drop(v, pos)
	    )
	);
    if #w == 0 then true else false
    )


-----------------------------------------------------------------

subwords = method()

subwords List := List => w -> subsets w

subwords (List, List) := List => (w, v) -> select(subsets v, swd -> isSubword(w, swd) )

   
-----------------------------------------------------------------

bruhatCompare = method()

bruhatCompare (GroupElement, GroupElement) := (w, v) -> (
    W := group w;
    if W =!= group v then (
	error "bruhatCompare: Expected group elements of the same Coxeter group."
	);
    if w == v then true
    else if length w >= length v then false
    else if w == id_W then true
    else (
    	nfw := wordToGroup(normalForm w, W);
    	nfv := wordToGroup(normalForm v, W);
	if not isSubset(nfw, nfv) then false
	else any(select(subsets(nfv, #nfw), swd -> isSubset(nfw, swd)), swd -> product swd == w)
	)	    
    )


-----------------------------------------------------------------

bruhatInterval = method()

bruhatInterval (GroupElement, GroupElement) := (w, v) -> (
    if not bruhatCompare(w, v) then (
	error "bruhatInterval: Expected the first group element to be less than or equal to the
	second in Bruhat order."
	);
    W := group w;
    w = wordToGroup(normalForm w, W);
    v = wordToGroup(normalForm v, W);
    poset(apply(subwords(w, v), swd -> wordToGroup(swd, W) ), bruhatCompare)	    
    )


-----------------------------------------------------------------

bruhatPoset = method()

bruhatPoset CoxeterGroup := Poset => W -> poset(groupElements W, bruhatCompare)


-----------------------------------------------------------------

weakCompare = method(Options => {Left => false})

weakCompare (GroupElement, GroupElement) := o -> (w, v) -> (
    if group w =!= group v then (
	error "weakCompare: Expected group elements of the same Coxeter group."
	);
    if o.Left then (
	isSubset(descentSet(w, AllReflections => true), descentSet(v, AllReflections => true) )
	)
    else (
	isSubset(descentSet(w, Left => true, AllReflections => true), 
	    descentSet(v, Left => true, AllReflections => true) )
	)	    
    )


-----------------------------------------------------------------

weakInterval = method(Options => {Left => false})

weakInterval (GroupElement, GroupElement) := o -> (w, v) -> (
    if not weakCompare(w, v, o) then (
	error "weakInterval: Expected the first group element to be less than or equal to the
	second in weak order."
	);
    W := group w;
    w = wordToGroup(normalForm w, W);
    v = wordToGroup(normalForm v, W);
    poset(apply(subwords(w, v), swd -> wordToGroup(swd, W) ), bruhatCompare)	    
    )


-----------------------------------------------------------------

weakLattice = method(Options => {Left => false})

weakLattice CoxeterGroup := Poset => W -> poset(groupElements W, weakCompare)


-- ENUMERATION
----------------------------------------------------------------- 

nerveComplex = method(Options => {Facets => false})

nerveComplex CoxeterGroup := List => o -> W -> (
    N := select(subsets gens W, J -> if #J == 0 then true else isFiniteGroup coxeterGroup subgroup J );
    if o.Facets then maximalElements poset(N, isSubset)
    else N
    )


-----------------------------------------------------------------

poincare Subgroup := RingElement => P -> poincare coxeterGroup P

poincare CoxeterGroup := RingElement => W -> (
    T := local T;
    A := ZZ[T];
    if isFiniteGroup W then (
	coeff := values applyValues(groupElements(W, Format => "hashtable"), v -> #v);
	sum apply(#coeff, i -> (coeff#i)*A_0^i )
	)
    else (
	N := nerveComplex W;
	mu := moebiusFunction poset(N|{gens W}, isSubset);
	putInRing := f -> (
	    coeff := apply(first entries transpose (coefficients f)_1, e -> sub(e, ZZ) );
	    sum apply(#coeff, i -> (coeff#i)*A_0^(#coeff - i - 1) )
	    ); 
	poin := apply(N, J -> putInRing poincare subgroup J);
	den := -(sum apply(#poin, i -> mu#({},N#i)*(product drop(poin, {i,i}) ) ) );
	poin = apply(select(pairs tally poin, p -> p_0 =!= 1_A), p -> Power{p_0, p_1});
	num := Product poin;
	poin = reduceHilbert Divide {den, num};
	Divide {denominator poin, numerator poin}
	)
    )


-- RIGHT ANGLED GROUPS
----------------------------------------------------------------- 

isRightAngled = method()

isRightAngled CoxeterGroup := Boolean => W -> set values (dynkinDiagram W).weights === set {0}
