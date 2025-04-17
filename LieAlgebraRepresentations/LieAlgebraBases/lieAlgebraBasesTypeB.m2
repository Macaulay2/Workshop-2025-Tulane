-- Type B so(2n+1) Lie algebras
-- written by Naufil Sakran, Dinesh Limbu, Rohan Joshi

-- See Fulton and Harris, Section 18.1, especially p. 270

Eijm = (i0,j0,m) -> ( matrix apply(m, i -> apply(m, j -> if i==i0 and j==j0 then 1/1 else 0/1)) );
Hin = (i,n) -> ( Eijm(i,i,n) - Eijm(i+1,i+1,n));

typeBHin = (i,n) -> ( Eijm(i,i,2*n+1) - Eijm(n+i,n+i,2*n+1));
typeBXijn = (i,j,n) -> ( Eijm(i,j,2*n+1) - Eijm(n+j,n+i,2*n+1));
typeBYijn = (i,j,n) -> ( Eijm(i,n+j,2*n+1) - Eijm(j,n+i,2*n+1));
typeBZijn = (i,j,n) -> ( Eijm(n+i,j,2*n+1) - Eijm(n+j,i,2*n+1));
typeBUin = (i,n) -> ( Eijm(i,2*n,2*n+1) - Eijm(2*n,n+i,2*n+1));
typeBVin = (i,n) -> ( Eijm(n+i,2*n,2*n+1) - Eijm(2*n,i,2*n+1));


------------------------------------------------

so2n1BasisElements = (n) -> (
    B:={};
    Hbasis := apply(n, i -> typeBHin(i,n));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then typeBXijn(i,j,n))));   
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBYijn(i,j,n)))); 
    Zbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBZijn(j,i,n))));
    Ubasis := flatten apply(n, i -> typeBUin(i,n));
    Vbasis := flatten apply(n, i -> typeBVin(i,n));
    flatten {Hbasis, Xbasis, Ybasis, Zbasis, Ubasis, Vbasis}
);

so2n1DualBasis = (n) -> (
    B:={};
    Hbasis := apply(n, i -> typeBHin(i,n));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then typeBXijn(j,i,n))));   
    Zbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBZijn(j,i,n)))); 
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBYijn(i,j,n))));
    Vbasis := flatten apply(n, i -> -typeBVin(i,n));
    Ubasis := flatten apply(n, i -> -typeBUin(i,n));
    flatten {Hbasis, Xbasis, Zbasis, Ybasis, Vbasis, Ubasis}
);


--myTrace = M -> sum (apply(numgens target M, i -> M_(i,i)))
--killingform=(M,N) -> myTrace(matrix M*N)
--myBasis = so2n1BasisElements(3);
--myDualBasis = so2n1DualBasis(3);
--matrix apply(length myBasis, i -> apply ( length myDualBasis, j -> killingform(myBasis_i,myDualBasis_j)))