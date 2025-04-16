-- methods
f = method()
f Matrix := A -> A - det A 
A = matrix{{1,2},{3,4}}
f A
f(Matrix,Matrix) := (A,B) -> A - B
methods f
code 1
f(A,transpose A)

-- methods with options
q = method(Options => {Value=>0,First=>0,Second=>0})
q RR := o -> x -> o.Value + o.First * x + o.Second * x^2 / 2
q(1.)
q(1.,First=>2)
q(1.,Value=>sin 1, First=>cos 1, Second=>pi)
options q

-- one more implementation for an existing method
betti
methods betti
code 1
betti String := o -> s -> print "Are you looking for Betty?" 
betti "Anton"
betti Ideal := o -> I -> print "Are you looking for a betti table?"
betti ideal 0

-- see more details
help method




