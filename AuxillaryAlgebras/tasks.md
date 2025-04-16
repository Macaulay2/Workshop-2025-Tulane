# tasks:

Young Symmetrizers:
* Make a function that accepts as input a triple of fillings (shapes are all partitions of the same number) and applies the Young symmetrizer algorithm
* need helper functions 
    - makeRing: inputs a filling and makes a ring ready for the next function makeDets
    - makeDets: inputs a filling and makes the product of determinants with column indices coming from the columns ( or rows) of the filling and row indices 0..k, with k the size.
    - unfactor: inputs a tuple of fillings and produces the polynomial in x_(i,j,k)

* improvements:
    - try to parallelize some of the steps within the "unfactor" command

# YoungTableaux:
    * Implement the character computation that determines the dimension of [pi_A]**[pi_B]**[pi_C] in Sym
        - note, there is Maple code to do this
    * SemiStandardYoungTableaux: given a shape and content, produce all SemiStandardYoungTableaux of that type
    * StandardYoungTableaux: given a shape, produce all StandardYoungTableaux of that type.