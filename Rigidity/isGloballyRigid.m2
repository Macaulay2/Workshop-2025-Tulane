-- Option FiniteFields: 0 for numeric, 1 for symbolic, prime power for finite field
isGloballyRigid = method(Options => {FiniteField => 1, Iterations => 3}, TypicalValue => Boolean)

-- Core function
isGloballyRigid(ZZ, List) := Boolean => opts -> (d, Gr) -> (
-- According to the p.2 Characterizing Generic Global Rigidity:
-- Asimow and Roth proved that a generic framework in E^d of a graph G
-- with d+1 or fewer vertices is globally rigid if G is a complete
-- graph (i.e., a simplex), otherwise it is not even locally rigid
    G := Gr/toList;
    n := # unique join(toSequence G);
	if n <= d+1 then return # set G == n*(n-1)//2;
	if not isLocallyRigid(d, G) then return false;
    M := getStressMatrix(d, G);
    if opts.FiniteField == 1 then rank M == max(n - d - 1, 0)
    else (
        variableNum := numgens ring M;
        F := if opts.FiniteField == 0 then RR else GF(opts.FiniteField);
        results := apply(
            toList(1..opts.Iterations),
            (k) -> (
                randomValues := random(F^1, F^variableNum);
                randomMap := map(ring randomValues, ring M, randomValues);
                rank randomMap M == max(n - d - 1, 0)
            )
        );
        if #set(results) =!= 1 then error("Try again bro")
        else results#0
    )
)

-- List of edges not given -> use complete graph
isGloballyRigid(ZZ, ZZ) := Boolean => opts -> (d, n) -> (
    isGloballyRigid(d, subsets(toList(0..(n-1)), 2), opts)
);

-- Input a Graph instead of edge set without number of vertices -> get number of vertices from graph
isGloballyRigid(ZZ, Graph) := Boolean => opts -> (d, G) -> (
    isGloballyRigid(d, edges G, opts)
);