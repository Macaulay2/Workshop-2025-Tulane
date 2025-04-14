
getRigidityMatrix = method(TypicalValue => Matrix)

isRigid = method(TypicalValue => Boolean)

getRigidityMatrix(ZZ, ZZ, List) := (d, n, G) -> (
    R := QQ[x_1 .. x_(d*n)]; -- Create a ring with d*n variables
    M := genericMatrix(R, x_1, d, n); -- Return a generic d by n matrix over R
    -- Folding horizontal concatination of the jacobian of each polynomial (from each edge)
    1/2*transpose fold(
        (a,b)-> a|b,
        apply(
            G,
            pair -> transpose(M_{pair#0} - M_{pair#1}) * (M_{pair#0} - M_{pair#1}) -- Here is the polynomial we might want to switch in the future
        )/jacobian
    )
);

getRigidityMatrix(ZZ,ZZ) := (d,n) -> (
    getRigidityMatrix(d,n, subsets(toList(0..(n-1)), 2))
);