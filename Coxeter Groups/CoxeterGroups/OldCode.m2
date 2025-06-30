
reduceWord = method()

reduceWord (List, CoxeterGroup) := List => (word, W) -> (
    if #word <= 1 then word
    else (
	S := gens W;
	w := wordToGroup(word, W);
    	rep := reflectionRep W;
	pos := u ->  position(S, t -> t == u);
	V := target cartanMatrix W;
	w' := wordToGroup(reducedExpression product drop(w, -1), W);
	w = w'|{last w};
    	drops := lengthDrops(w, W);
	if #drops > 0 then w = drop(w', {first drops, first drops});
	w' = drop(w, -1);
	l := #w - 1;
	drops = flatten apply(l, i -> (
		v := (rep product drop(w', i))_(pos last w);
	        apply(select(pos w'#i, j -> (id_V)_j == v ), j -> (i, j) )
		)
	    );
	if #drops > 0 then (
	    (i, j) := first drops;
	    --w' = drop(w, -1);
	    w = take(w', i)|{S#j}|drop(w', i)
	    );
	apply(w, s -> first reducedExpression s)
	) 
    )

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
	(symbol RelationMatrix) => m,
        (symbol cache) => new CacheTable from {}
	};
    
    newGens := apply(S, s -> s <- putInGroup({s}, W) );
    W#(symbol generators) = newGens;
   
    W ^ ZZ := (w, n) -> (
       if n == 0 then id_W 
       else if n > 0 then product toList (n:w) 
       else if n == -1 then product wordToGroup(reverse reducedExpression w, W)
       else product toList(-n: w^(-1))
       );
   
    --W ? W := (f,g) -> (leadNCMonomial f) ? (leadNCMonomial g);

    W == W := (w, v) -> reducedExpression w === reducedExpression v;
       
    W * W := (w, t) -> (
	reducedExpr := reduceWord((reducedExpression w)|(reducedExpression t), W);
	new W from hashTable {
	    (symbol group) => W,
	    (symbol cache) => new CacheTable from {
	    (symbol expressions) => unique ({reducedExpr}|(flatten apply(expressions w, 
		       e -> apply(expressions t, e' -> e|e') ) ) )
	    },
       	(symbol reducedExpression) => reducedExpr,
        (symbol length) => #reducedExpr,
	(symbol sign) => (sign w)*(sign t)
        }
    );
   
    W
    )

-----------------------------------------------------------------

-*
lengthDrops = method()

lengthDrops (List, CoxeterGroup) := List => (w, W) -> (
    if not isSubset(set w, gens W) then (
	error "lengthDrops: Expected a list of generators of the Coxeter group."
	);
    if #w <= 1 then {}
    else if #w == 2 then (
	if w#0 == w#1 then {0} else {}
	)
    else (
    	rep := reflectionRep W;
	S := gens W;
	w' := drop(w, -1);
	l := #w - 1;
	V := target cartanMatrix W;
	pos := t ->  first select(numgens W, j -> S#j == t); 
	select(l, i -> 
	    if i == l - 1 then pos last w == pos w#i  
	    else (rep product drop(w', i+1))_(pos last w)  == (id_V)_(pos w#i) 
	    )
	)
    )
*-

lengthDrops = method()

lengthDrops (List, CoxeterGroup) := List => (w, W) -> (
    if not isSubset(set w, gens W) then (
	error "lengthDrops: Expected a list of generators of the Coxeter group."
	);
    if #w <= 1 then {}
    else if #w == 2 then (
	if w#0 == w#1 then {0} else {}
	)
    else (
    	rep := reflectionRep W;
	S := gens W;
	t := last w;
	w = drop(w, -1);
	V := target cartanMatrix W;
	pos := u ->  position(S, s -> s == u);
	beta := id_V; 
	select(reverse toList(0..#w - 1), i -> 
	    if i == #w - 1 then pos last w == pos t  
	    else (
		beta = (rep w#(i+1))*beta;
		beta_(pos t)  == (id_V)_(pos w#i)
		) 
	    )
	)
    )
