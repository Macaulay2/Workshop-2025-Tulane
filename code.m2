newtonIdentity = method()
-- newtonIdentity takes in an integer k and n and returns list of the 1,2,,...,kth sum of powers in n variables in terms of the
-- elementary symmmetric polynomials and sum of powers of degrees (k-1) and lower.
newtonIdentity(ZZ,ZZ) := List => (k,n) -> (
    -- I'll tell M2 that I'm using these as symbols for elementary polynomials and the sum of power polynomials
    if n < 1 or k < 1 then error "n and k need to be positive integers";
   -- e = symbol "e";
    --p = symbol "p";
    use QQ[e_0..e_k, p_0..p_k];
    for i from 0 to k list ( sum((for j from 1 to i-1 list (-1)^(i-1+j)*e_(i-j)*p_j) |  {(-1)^(i-1)*i*e_i}))
)