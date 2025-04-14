newPackage(
    "Permutations",
    AuxiliaryFiles => true,
    Version => "1.0", 
    Date => "April 18, 2025",
    Keywords => {"Combinatorics"},
    Authors => {
        {Name => "Sean Grate", 
         Email => "sean.grate@auburn.edu", 
         HomePage => "https://seangrate.com/"}
    },
    Headline => "functions for working with permutations"
)

export {
    -- types
    "Permutation",
    -- methods
    "permutation",
    "cycleDecomposition",
    "cycleType",
    "ascents",
    "descents",
    "ascendingRuns",
    "descendingRuns",
    "exceedances",
    "saliances",
    "records",
    "avoidsPattern",
    "avoidsPatterns",
    "isVexillary",
    "isCartwrightSturmfels",
    "isCDG",
    "foataBijection",
    "ord",
    "sign",
    "isEven",
    "isOdd",
    "isDerangement",
    "fixedPoints",
    "inversions",
    -- symbols
    "Weak"
}

-----------------------------------------------------------------------------
-- **CODE** --
-----------------------------------------------------------------------------
------------------------------------
-- Local utilities
------------------------------------
to1Index := w -> (w / (i -> i+1))
to0Index := w -> (w / (i -> i-1))

------------------------------------
-- Permutation type declarations and basic constructors
------------------------------------
Permutation = new Type of VisibleList
Permutation.synonym = "permutation"

new Permutation from VisibleList := (typeofPermutation,w) -> w

permutation = method()
permutation VisibleList := Permutation => w -> new Permutation from w

isWellDefined Permutation := Boolean => w -> (
    wList := toList w;
    ((sort wList) == toList(1..#wList)) and not (#wList == 0)
)

------------------------------------
-- Permutation string representations
------------------------------------
expression Permutation := w -> expression toList w
toString Permutation := w -> toString expression toList w
tex Permutation := w -> tex expression toSequence w
html Permutation := w -> html expression toList w

------------------------------------
-- Indexing permutations as lists
------------------------------------
Permutation _ ZZ := ZZ => (w,n) -> ((toList w)_(n-1))
Permutation _ List := List => (w,l) -> ((toList w)_l)
Permutation _ Sequence := List => (w,s) -> ((toList w)_(toList s))

------------------------------------
-- Basic permutation operations
------------------------------------
Permutation == Permutation := Boolean => (w, v) -> (
    (w, v) = extend(w,v);
    toList(w) == toList(v)
)
Permutation * Permutation := Permutation => (w, v) -> (
    (w,v) = extend(w,v);
    trim permutation w_(to0Index toList v)
)
-- power implementation modified from Mahrud's in https://github.com/Macaulay2/M2/issues/2581
Permutation ^ ZZ := Permutation => (w, n) -> fold(if n < 0 then (-n):(permutation to1Index inversePermutation to0Index toList w) else n:w,
                                                  permutation toList (1 .. #w),
                                                  (w, v) -> w*v)

------------------------------------
-- Matrix representation of a permutation
------------------------------------
-- some people prefer the transpose of this
matrix Permutation := Matrix => o -> w -> (
    id_(ZZ^(#w))_(to0Index toList w)
)

------------------------------------
-- Group actions
------------------------------------
Permutation * VisibleList := VisibleList => (w, l) -> (
    if #(trim w) > #l then error(toString w | " permutes more than " | toString #l | " elements.") 
    else l_(to0Index toList extend(w, #l))
)
VisibleList _ Permutation := VisibleList => (l, w) -> (w*l)

-- group action on a matrix permutes the rows/columns of the matrix
Permutation * Matrix := Matrix => (w, M) -> (
    m := numRows M;
    if #(trim w) > m then error(toString w | " permutes more than " | toString m | " elements.") 
    else (matrix extend(w, m)) * M
)
Matrix _ Permutation := Matrix => (M, w) -> (w*M)
Matrix * Permutation := Matrix => (M, w) -> (transpose(w*(transpose M)))
Matrix ^ Permutation := Matrix => (M, w) -> (M*w)

------------------------------------
-- Miscellaneous
------------------------------------
-- inverse = method()
inverse Permutation := Permutation => w -> (permutation to1Index inversePermutation to0Index toList w)

-- order of a permutation, i.e. smallest integer n such that w^n = identity
-- the order of a permutation can be expressed as the lcm of its cycle lengths
ord = method()
ord Permutation := ZZ => w -> (
    lcm((cycleDecomposition w) / length)
)

-- see https://en.wikipedia.org/wiki/Parity_of_a_permutation for different ways
-- to compute the sign or parity of a permutation
sign = method()
sign Permutation := ZZ => w -> (
    if even(#w - #(cycleDecomposition w)) then 1 else -1
)

isEven = method(TypicalValue => Boolean)
isEven Permutation := w -> (
    sign w == 1
)

isOdd = method(TypicalValue => Boolean)
isOdd Permutation := w -> (
    sign w == -1
)

isDerangement = method(TypicalValue => Boolean)
isDerangement Permutation := w -> (not any(cycleDecomposition w, cycle -> #cycle == 1))

fixedPoints = method()
fixedPoints Permutation := List => w -> (for cycle in cycleDecomposition w list if #cycle == 1 then unsequence cycle else continue)

inversions = method()
inversions Permutation := List => w -> (
    for idxPair in sort(subsets(toList w, 2) / sort) list if w_(idxPair#0) > w_(idxPair#1) then idxPair else continue
)

length Permutation := ZZ => w -> (#(inversions w))

-----------------------------------------------------------------------------
-- **DOCUMENTATION** --
-----------------------------------------------------------------------------
beginDocumentation()
load "./Permutations/docs.m2"

-----------------------------------------------------------------------------
-- **TESTS** --
-----------------------------------------------------------------------------
load "./Permutations/tests.m2"
end

-----------------------------------------------------------------------------
--Development Section
-----------------------------------------------------------------------------
restart
uninstallPackage "Permutations"
restart
installPackage "Permutations"
restart
needsPackage "Permutations"
elapsedTime check "Permutations"
viewHelp "Permutations"