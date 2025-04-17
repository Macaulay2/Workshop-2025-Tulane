-- Getting the special Monomials (modulo permutations of the variables)

-- First we get the special indexes
IsListSp = (I,n) -> (
    aux := 0;
    if (length I) > n then aux = 1 else(
        if (length I) < n then(
            for i from 1 to (n - (length I)) do I = I | {0}
        );
        for i from 1 to (#I - 1) do(
            if abs(I_i - I_(i-1))>1 then(aux=1; break)
        );
        if (last I) > 0 then aux = 1
    );
    if aux == 0 then {true , I} else {false , I}
)

--Generate, if posible, the list of special monomials
ListSpMon=(d,n)->(
    R:=QQ[x_1..x_n];
   L:=partitions d;
   M:={};
   for i from 0 to (#L-1) do if (IsListSp(toList L_i,n))_0 then M=M | {vectorToMonomial( vector((IsListSp(toList L_i,n))_1)  , R  ) };
   if #M>0 then M else print("There are no special monomials")
)
--Test
ListSpMon(7,8)
ListSpMon(27,8)
