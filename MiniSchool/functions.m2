-* emacs (classic!)
 Let C = Ctrl, M = Alt (typically). 
 Then shortcuts include: 
   C-x C-f : open/create a file (in a "buffer")
   F12     : start M2
   C-x o   : jump between the windows
   C-x b   : jump between the buffers (i.e., open files)
   F11     : execute the current line (or the highlighted block)
   C-x C-s : save the file (in the current buffer)
   M-/     : autocomplete (not as frequently used as it should!)
   M-x <command> : e.g. <command>=shell starts a shell window
*-

-* VS Code (more visual than emacs)
 Has a simple git graphical interface,
 many add-ons apart from Macaulay2 (e.g., various copilots)   
 Shortcuts:
   F12     : start M2
   M-x <Enter> : execute the current line (or the highlighted block)
*-

-- functions
f = x -> x^2
g = (x,y) -> x | y
f 2 -- no need for parentheses
g("bla",2) 
f {1,2,3}
g(1,2)
A = matrix{{2},{3}}
g(1,A)
g(matrix{{1,1}},A)

-- make a file with code and load it
load "f-and-g.m2"
g(matrix{{1,1}},A) -- get quickly to the code that failed!
help "debugging"

-- apply a function to all elements in a list
S = 1..10
L = toList S
apply(L,x->x^2)
L / (x->x^2)
(x->x^2) \ L

-- an object of type FunctionClosure... 
R = QQ[x,y,z]
basis(3,R)
entries basis(3,R)
flatten entries basis (3,R)
applyFunctionToMonomialsOfDegree'd'  = (f,R,d) -> (
    --...can be passed as an argument...
    apply(flatten entries basis(d,R), f)
    )
applyFunctionToMonomialsOfDegree'd'(degree,R,3)
highestExponent = m -> max first exponents m
applyFunctionToMonomialsOfDegree'd'(highestExponent,R,4)
--...or e.g. returned
getFunctionReturningThe'i'thExponent = i ->
  (m -> (first exponents m)#i)
firstExponent = getFunctionReturningThe'i'thExponent 0
firstExponent m
applyFunctionToMonomialsOfDegree'd'(firstExponent,R,3)

-* EXERCISE:
  Make a function that
  returns the minimal monomials in the list
  with respect to divisibility.
  (Hint: a % b = the division remainder.) 
  Test it on L below.
*-
R = QQ[x,y]
L = apply(100,i->R_(apply(numgens R,i->abs random ZZ)))
M = apply(100,i->R_(apply(numgens R,i->abs random ZZ)))
help delete
help isMember
help select
select(L,m->not isMember(m,M))
