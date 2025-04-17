-- other attempt: Generate special Monomials of degree at most d in a constructive way
needsPackage "SRdeformations"

ListSpInd=(n,d)->(
    SpI:={{0}}; --Initializing the list of special powers
    SpDeg:={0}; --Initializing the list of special degrees
    AuxI:={};
    AuxDeg:={};
    for m from 1 to n-1 do(
        for i from 0 to (#SpI)-1 do(
            if (SpDeg_i)+(last (SpI_i))<=d then(AuxI=AuxI | { (SpI_i) | {last (SpI_i)}};
                                                AuxDeg=AuxDeg | { SpDeg_i+ (last (SpI_i))};
                                                if (SpDeg_i)+(last (SpI_i))+1<=d then( AuxI=AuxI | { (SpI_i) | {1 +(last (SpI_i))}};
                                                                                         AuxDeg=AuxDeg | { 1+ SpDeg_i+ (last (SpI_i))}))
                                             else(AuxI=AuxI | { sort ((SpI_i) | {0}) };
                                                  AuxDeg=AuxDeg | { SpDeg_i}  ));
        SpI=AuxI;
        SpDeg=AuxDeg;
        AuxI={};
        AuxDeg:={}
        ); 
    SpI   
)
--Test
ListSpInd(6,4)

-- Shuffle every monomial
ShuffMon=(f,n)->(
    R:=QQ[x_1..x_n];
    P:=(exponents f)_0;
    P= permutations P;
    Mon:={};
    for i from 0 to (#P-1) do(
       Mon = Mon | {vectorToMonomial(vector(P_i), R) } 
    );
    toList set Mon
)

ListSpMon=(n,d)->(
    d=min {d,n*(n-1)/2};
    R:=QQ[x_1..x_n];
    SpI:=ListSpInd(d,n);
    SpMon:={};
    for i from 0 to (#SpI - 1) do(SpMon = (SpMon| ShuffMon(vectorToMonomial( vector (SpI_i) , R  ) ,n)));
    SpMon
)

--Test
ListSpMon(4,6)



