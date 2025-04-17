-***************************
To Do List
****************************

 - Global Rigidity Test, symbolic and numerical

 - Tests and documentation for local rigidity code

 - Finite Field + numerical computation for local rigidity

 - Matrix completion analogues

 - Tropical Circuit Polynomial (TBD)

 - Pebble Game Algorithm (and related stuff)
*-

d = 3
n = 5
R = QQ[x_1 .. x_(3*5)]; -- Create a ring with d*n variables
M = genericMatrix(R,x_1,d,n)

 first (first (entries (transpose(M_{1}-M_{2})*(M_{1}-M_{2}))))

 jacobian( first (first (entries (transpose(M_{1}-M_{2})*(M_{1}-M_{2}))))) |  jacobian( first (first (entries (transpose(M_{3}-M_{2})*(M_{3}-M_{2})))))
 jacobian(transpose(M_{1}-M_{2})*(M_{1}-M_{2}))


getRigidityMatrix = (d, n, G) -> (
    R := QQ[x_1 .. x_(d*n)]; -- Create a ring with d*n variables
    M := genericMatrix(R, x_1, d, n); -- Return a generic d by n matrix over R
    -- Folding horizontal concatination of the jacobian of each polynomial (from each edge)
    fold(
        (a,b)-> a|b,
        apply(
            subsets(toList(0..(n-1)),2),
            pair -> transpose(M_{pair#0} - M_{pair#1}) * (M_{pair#0} - M_{pair#1}) -- Here is the polynomial we might want to switch in the future
        )/jacobian
    )
);

getRigidityMatrix(2,4)

fold((a,b)-> a|b, getRigidityMatrix(2,4, subsets({1,2,3,4},2)))