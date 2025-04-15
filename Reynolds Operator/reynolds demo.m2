-- Reynolds demo 
V = QQ^3

v1 = matrix{{0},{2},{3}}
v2 = matrix{{1},{-1},{4}}

------------------------------------------------------------
-- Placeholder for the Casimir operator.
CasimirOperator = v -> (
    if (v_(0,0) == 0) then (
        v
    ) else (
        2*v
    )
)

------------------------------------------------------------
-- The Reynolds operator algorithm following Algorithm 4.5.19.
reynoldsOperator = v -> (
    vList := {v};  -- initialize with v₀ = v.
    while true do (
        print("Iteration " | toString(#vList - 1) | ": Last vector = " | toString(last vList));
        
        -- Form the matrix M whose columns are the vectors in vList.
        M := vList_0;
        if (#vList > 1) then (
            for i from 1 to (#vList - 1) do (
                M = M || vList#i;
            )
        );
        
        -- If the list of vectors is linearly dependent, proceed to compute the projection.
        if (#vList > rank M) then (
            -- Compute the kernel of M.
            K = kernel M;
            genKer = generators K;
            for j from 0 to numcols genKer - 1 do (
                -- Extract the kernel generator as a list of coefficients.
                aList := for i from 0 to (#vList - 1) list genKer_(i,j);
                if (aList_(#vList - 1) =!= 0) then (
                    if (aList_0 =!= 0) then (
                        return 0
                    )
                    else (
                        -- Compute s = a₁*v₀ + a₂*v₁ + ... + aₗ*vₗ₋₁.
                        s := 0 * v; 
                        for i from 1 to (#vList - 1) do (
                            s = s + aList_i * vList#(i - 1)
                        );
                        return (1 / aList_1) * s
                    )
                )
            )
        );
        -- No dependence. Compute the next iterate.
        vList = append(vList, CasimirOperator(last vList))
    )
)

------------------------------------------------------------

rinv1 = reynoldsOperator(v1)
print "Reynolds operator applied to v1:"
print rinv1

rinv2 = reynoldsOperator(v2)
print "Reynolds operator applied to v2:"
print rinv2
