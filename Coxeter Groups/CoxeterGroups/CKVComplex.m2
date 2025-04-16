
graph MonomialIdeal := Graph => o -> I -> (
    expos := flatten(I_*/exponents);
    if any(expos, e -> sum e =!= 2) then (
	error "graph: Expected a quadratic monomial ideal."
	);
    if any(expos, e -> any(e, d -> d > 1) ) then (
	    error "graph: Expected a squarefree monomial ideal."
	    );
    graph apply(expos, e -> positions(e, i -> i == 1) )
    )


-----------------------------------------------------------------
-- get a list of all spherical elements of a Coxeter group


sphericalElements = method()

sphericalElements CoxeterGroup := List => W -> (
    unique apply(flatten (nerveComplex(W, Facets => true)/subgroup/coxeterGroup/groupElements), 
	w -> sub(w, W))
    )	


-----------------------------------------------------------------
-- get the spherical length of an element of a Coxeter group

-*
sphericalLength = method()

sphericalLength GroupElement :=  => w -> (
    )	

sphericalLength (ZZ, CoxeterGroup) := HashTable => (k, W) -> (
    )	


-----------------------------------------------------------------
-- compute a finite-index torsion-free subgroup of a Coxeter group

torsionFreeSubgroup = method()

torsionFreeSubgroup (ZZ, CoxeterGroup) := Subgroup => (h, W) -> (
    )

torsionFreeSubgroup CoxeterGroup := Subgroup => W -> torsionFreeSubgroup(sphericalIndex(k, W), W)	


-----------------------------------------------------------------
-- find the smallest integer h such that torsionFreeSubgroup(h, W) does not contain elements
-- of spherical length less than k

sphericalIndex = method()

sphericalIndex (ZZ, CoxeterGroup) := ZZ => (k, W) -> (
    )

*-
