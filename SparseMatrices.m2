-- -*- coding: utf-8 -*-
-- licensed under GPL v2 or any later version
newPackage(
    "SparseMatrices",
    Version => "0.1",
    Date => "April 8, 2025",
    Headline => "basic arithmetic of sparse matrices",
    Authors => {
	  {Name => "Dave Swinarski", Email => "dswinarski@fordham.edu"}
	  },
    Keywords => {"Sparse Matrices"},
    DebuggingMode => true
    )



export {
    "SparseMatrix",
    "sparseMatrix",
    "dense",
    "sparse",
    "NNZ",
    "ringMap",
    "restrict",
    "diagonalJoin"
    }



SparseMatrix = new Type of HashTable  
-- Keys:
-- BaseRing
-- NumberOfRows
-- NumberOfColumn
-- Entries



sparseMatrix = method(
    TypicalValue => SparseMatrix
)
sparseMatrix(ZZ,ZZ,Ring,HashTable):= (m,n,R,H) -> (
    H2:=new HashTable from apply(pairs(H), p -> {p_0,(p_1)_R});
    new SparseMatrix from {"NumberOfRows"=>m, "NumberOfColumns"=>n,"BaseRing"=>R,"Entries"=>H2}    
);



dense = method(
    TypicalValue => Matrix
)
dense(SparseMatrix) := (M) -> (
    R:=M#"BaseRing";
    m:=M#"NumberOfRows";
    n:=M#"NumberOfColumns";
    map(R^m,R^n,apply(pairs(M#"Entries"),p-> p_0 => p_1))   
)

dense(Matrix):= M -> M


sparse = method(
    TypicalValue => SparseMatrix
)
sparse(Matrix) := M -> (
    H := new HashTable from delete(null,flatten apply(numRows(M), i -> apply(numColumns(M), j -> if M_(i,j)!=0 then (i,j)=>M_(i,j))));
    sparseMatrix(numrows(M),numColumns(M),ring(M),H)
)

sparse(SparseMatrix):= M -> M

transpose(SparseMatrix):=(M) -> (
    E:=M#"Entries";
    newE := new HashTable from apply(pairs(E), p -> {(p_0_1,p_0_0),p_1}); 
    sparseMatrix(M#"NumberOfColumns",M#"NumberOfRows",M#"BaseRing",newE)
);


SparseMatrix == SparseMatrix := (A,B) -> (
    if A#"NumberOfRows" != B#"NumberOfRows" then return false;
    if A#"NumberOfColumns" != B#"NumberOfColumns" then return false;
    if A#"BaseRing" =!= B#"BaseRing" then return false;
    HA:=A#"Entries";
    HB:=B#"Entries";
    if sort(keys(HA))!=sort(keys(HB)) then return false;
    all(keys(HA), k -> HA#k==HB#k)
)



Number * SparseMatrix := (c,A) -> (
    H:={};
    if c==0 then (
	H = new HashTable from {}
    ) else (
        H=new HashTable from apply(pairs(A#"Entries"), p -> {p_0,c*p_1})
    );
    sparseMatrix(A#"NumberOfRows",A#"NumberOfColumns",A#"BaseRing",H)
);


RingElement * SparseMatrix := (c,A) -> (
    if not instance(c,A"BaseRing") then error "c is not the ring of this matrix" << endl;
    H:=new HashTable from apply(pairs(A#"Entries"), p -> {p_0,c*p_1});
    sparseMatrix(A#"NumberOfRows",A#"NumberOfColumns",A#"BaseRing",H)
);


SparseMatrix + SparseMatrix := (A,B) -> (
    if A#"BaseRing" =!= B#"BaseRing" then error "The base rings are not the same";
    if A#"NumberOfRows" =!= B#"NumberOfRows" then error "Different numbers of rows";
    if A#"NumberOfColumns" =!= B#"NumberOfColumns" then error "Different numbers of columns";
    K:=unique(join(keys(A#"Entries"),keys(B#"Entries")));  
    E:=for k in K list (
        if not (B#"Entries")#?k then (
	    {k,(A#"Entries")#k}	
	) else if not (A#"Entries")#?k then (
	    {k,(B#"Entries")#k}
	) else if (A#"Entries")#k+(B#"Entries")#k != 0 then {k,(A#"Entries")#k+(B#"Entries")#k}
    );
    H := new HashTable from delete(null,E);
    sparseMatrix(A#"NumberOfRows",A#"NumberOfColumns",A#"BaseRing",H)
);



SparseMatrix * SparseMatrix := (A,B) -> (
    if A#"BaseRing" =!= B#"BaseRing" then error "The base rings are not the same";
    if A#"NumberOfColumns" =!= B#"NumberOfRows" then error "Maps not composable";
    Iindices:=apply(keys(A#"Entries"), k -> k_0);
    Jindices:=apply(keys(B#"Entries"), k -> k_1);
    ABij:=0;
    E:=flatten for i in Iindices list (
       for j in Jindices list (
           ABij = sum delete(null,apply(A#"NumberOfColumns",k -> if A#"Entries"#?(i,k) and B#"Entries"#?(k,j) then (A#"Entries"#(i,k))*(B#"Entries"#(k,j))));
	   if ABij!=0 then {(i,j),ABij}
       )
    );
    H:=new HashTable from delete(null,E);
    sparseMatrix(A#"NumberOfRows",B#"NumberOfColumns",A#"BaseRing",H)
);


NNZ = method(
    TypicalValue => ZZ
)
NNZ(SparseMatrix) := (M) -> (
    #pairs(M#"Entries")
);

-* Why can't I overload map?
map(Ring,Ring,SparseMatrix):=(S,R,M) -> (
    map(S,R,apply(numgens R, i -> sum delete(null,apply(pairs(M#"Entries"), x -> if x#0#1==i then (x#1)*(S_(x#0#0))))))
);
*-

ringMap = method(
    TypicalValue => RingMap
)
ringMap(Ring,Ring,SparseMatrix):=(S,R,M) -> (
    L:=apply(numgens R, i -> sum delete(null,apply(pairs(M#"Entries"), x -> if x#0#1==i then (x#1)*(S_(x#0#0)))));
    map(S,R,L)
);

restrict = method(
    TypicalValue => SparseMatrix
)
restrict(SparseMatrix,List,List) := (M,I,J) -> (
    m1:=M#"NumberOfRows";
    n1:=M#"NumberOfColumns";
    m2:=#I;
    n2:=#J;
    P:=pairs(M#"Entries");
    newpairs:={};
    i:=0;
    j:=0;
    for p in P do (
        if member(p#0#0,I) and member(p#0#1,J) then (
	    i=position(I,x -> x==p#0#0);
	    j=position(J,x -> x==p#0#1);
	    newpairs = append(newpairs,(i,j)=>p#1)
	)
    );
    sparseMatrix(m2,n2,M#"BaseRing",new HashTable from newpairs)
);

diagonalJoin = method(
    TypicalValue => SparseMatrix
)
diagonalJoin(SparseMatrix,SparseMatrix) := (M,N) -> (
    if M#"BaseRing" =!= N#"BaseRing" then error "The base rings are not the same";
    m1:=M#"NumberOfRows";
    n1:=M#"NumberOfColumns";
    m2:=N#"NumberOfRows";
    n2:=N#"NumberOfColumns";
    Mhash:=pairs(M#"Entries");
    Nhash:=pairs(N#"Entries");
    newNhash:=apply(Nhash, p -> {(p#0#0+m1,p#0#1+n1),p#1});
    sparseMatrix(m1+m2,n1+n2,M#"BaseRing",new HashTable from join(Mhash,newNhash))
);

end

restart
loadPackage "SparseMatrices";


-- TESTS

A1 = sparseMatrix(5,10,QQ,new HashTable from {(0,1)=>1,(4,5)=>-1})
A2 = sparseMatrix(5,10,QQ,new HashTable from {(4,5)=>-1,(0,1)=>1})
A1===A2
A1==A2

A3 = sparseMatrix(5,10,QQ,new HashTable from {(4,5)=>-2/2,(0,1)=>1})
A1===A3
A1==A3



A = sparseMatrix(5,10,QQ,new HashTable from {(0,1)=>1,(4,5)=>-1})
dA = dense(A)
At = transpose(A)
dAt = dense(At)
assert(dAt==transpose(dA))

B = sparseMatrix(5,10,QQ,new HashTable from {(0,1)=>-1,(0,2)=>3,(4,5)=>-1})
dB = dense(B)
C=A+B
dC = dense(C)
assert(dC == dA + dB)


Bt=transpose(B);
dBt = dense(Bt);
ABt=A*Bt
dABt = dense(ABt);
assert(dABt == dA*dBt)



-- Try a bigger example

loadPackage("SparseMatrices");
m = 5000;
n = 10000;
-- I generated two random matrices as follows
--HA = apply(20, k -> {(random(5000),random(10000)),random(-100,100)/random(1,100)});
--HB = apply(30, k -> {(random(5000),random(10000)),random(-100,100)/random(1,100)});
HA = new HashTable from {{(1556,8980), 32/9}, {(1846,5044), -58/71}, {(3245,1264), 11/86}, {(4356,5066), -1/89}, {(634,8920), 34/31}, {(2809,6803), 94/25}, {(2449,8569), 26/23}, {(3932,104), 45/7}, {(4068,6156), -99/56}, {(1596,6162), 33/29}, {(4427,4533), 2/5}, {(487,5102), 1/98}, {(1896,8603), 1/18}, {(4399,1889), -4/21}, {(3379,6802), -83/6}, {(2030,3716), -49/27}, {(1378,9184), 3/2}, {(171,6642), -87/91}, {(724,2563), -72/11}, {(3138,7429), -97/51}};
HB = new HashTable from {{(4883,3016), -1/5}, {(2315,360), -1/7}, {(1432,5840), 7/4}, {(1417,1994), 97/81}, {(772,3263), 50/41}, {(4621,1838), 89/99}, {(271,5508), 43/100}, {(4426,8696), -51/56}, {(4075,4209), 17/6}, {(3386,8236), -29/73}, {(1186,2591), -1}, {(3860,624), 3/17}, {(1632,4481), -40/37}, {(4082,7908), -17}, {(2202,8521), 22/41}, {(3992,9842), 41/4}, {(353,9930), 25/46}, {(2150,7989), -36/19}, {(81,3178), 4/45}, {(1493,9258), -82/59}, {(3809,5174), -11/19}, {(3776,310), 10/3}, {(1212,4707), -1/3}, {(4625,2136), 2/9}, {(3369,3650), -17/19}, {(3838,1599), -36/13}, {(3306,541), 47/33}, {(418,9112), -10/19}, {(783,6701), 3/8}, {(2755,9175), 12/11}};

A = sparseMatrix(m,n,QQ,HA);
B = sparseMatrix(m,n,QQ,HB);
time AplusB = A+B;
 -- used 0.000129s (cpu); 0.000124042s (thread); 0s (gc)
dA = dense(A);
dB = dense(B);
time dAplusdB = dA+dB;
-- used 0.000296s (cpu); 0.000288334s (thread); 0s (gc)
dense(AplusB)==dAplusdB

time Bt = transpose(B);
-- used 0.00013s (cpu); 0.000124458s (thread); 0s (gc)
time dBt = transpose dB;
-- used 0.000817s (cpu); 0.000802167s (thread); 0s (gc)
dense(Bt)==dBt


time ABt = A*Bt;
-- used 1.56833s (cpu); 1.39431s (thread); 0s (gc)
time dAdBt = dA*transpose(dB);
-- used 0.000321s (cpu); 0.000311791s (thread); 0s (gc)
dense(ABt) == dAdBt


-- My new code is correct, but 5000 times slower than the built in multiplication
-- Why?


-- Test ringMap
R=QQ[x_0,x_1]
S=QQ[y_0..y_3]
f1 = map(S,R,{y_0+y_2,y_1-y_3})
M2 = matrix {{1,0},{0,1},{1,0},{0,-1/1}};
f2 = map(S,R,M2);
f1===f2
M3 = sparseMatrix(4,2,QQ,new HashTable from {(0,0)=>1,(2,0)=>1,(1,1)=>1,(3,1)=>-1});
dense(M3)==M2
f3 = ringMap(S,R,M3);
f1===f3


-- Test restrict
dM = matrix apply(5, i -> apply(4,j -> 10/1*i+j));
I = {0,1,2}
J = {2,3}
sM = sparse dM;
dense(restrict(sM,I,J))==dM_J^I
