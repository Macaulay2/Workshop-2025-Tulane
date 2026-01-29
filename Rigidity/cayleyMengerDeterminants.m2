
cayleyMengerDeterminants = method(TypicalValue => Matrix)
cayleyMengerDeterminants(ZZ,ZZ) := Matrix => (n,d) -> (
    dists := getSymbol "d";
    R := QQ(monoid new Array from apply(subsets(1..n, 2), i-> dists_ (toSequence(i))));
    M := map(R^(n+1),R^(n+1), ((i,j) ->
        if i == j then 0
        else if i == 0 or j == 0 then 1
        else (dists_(min(i,j),max(i,j)))_R));
    ideal for i in subsets(1..n,d+2) list det submatrix(M, prepend(0, i), prepend(0, i))
);