
cayleyMengerIdeal = method(TypicalValue => Ideal)
cayleyMengerIdeal(ZZ,ZZ) := Ideal => (n,d) -> (
    dists := getSymbol "d";
    R := QQ(monoid new Array from apply(subsets(1..n, 2), i-> dists_ (toSequence(i))));
    M := map(R^(n+1),R^(n+1), ((i,j) ->
        if i == j then 0
        else if i == 0 or j == 0 then 1
        else (dists_(min(i,j),max(i,j)))_R));
    minors(d+3,M)
);