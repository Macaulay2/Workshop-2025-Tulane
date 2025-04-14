
getRigidityMatrix = method(TypicalValue => Matrix)

isLocallyRigid = method(TypicalValue => Boolean)

getRigidityMatrix(ZZ, ZZ, List) := (d, n, G) -> (
    R := QQ[x_1 .. x_(d*n)]; -- Create a ring with d*n variables
    M := genericMatrix(R, x_1, d, n); -- Return a generic d by n matrix over R
    -- Here is the polynomial we might want to switch in the future
    polynomialLists := apply(G, pair -> transpose(M_{pair#0} - M_{pair#1}) * (M_{pair#0} - M_{pair#1}) ); 
    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatination of the jacobian of each polynomial (from each edge)
    1/2 * transpose fold((a,b) -> a|b, jacobianList)
);

getRigidityMatrix(ZZ,ZZ) := (d,n) -> (
    getRigidityMatrix(d,n, subsets(toList(0..(n-1)), 2))
);

isLocallyRigid(ZZ, ZZ, G) := (d, n, G) -> (
    M := getRigidityMatrix(d,n,G);
    rank M == d*n - (d+1)*d/2
;)

isLocallyRigid(ZZ,ZZ) := (d,n) -> (
    isRigid(d,n, subsets(toList(0..(n-1)), 2))
);

