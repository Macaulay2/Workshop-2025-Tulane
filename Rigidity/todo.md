# To Do List:

* Young people: Julian, Ryan, Griffin, Jianuo, Aolong
* Senior: Dan, Kalina, Anton
  
## Paper
Kalina is in charge.

## Issues
- Check documentation in SymmetricCompletionDocs.m2 and SkewSymmetricCompletionDocs.m2 ✔️
- uniformize folders/organization (less important)
- Testing: isGloballyRigid(2, G3) takes forever to run (in globallyRigidTests.m2), maybe problem with isGloballyRigid code?
- Fix (?) inconsistency in numbering (e.g. "completability" assumes vertices start from 0, and "Cayley-Menger" starts from 1)

## Issues - part2
- isSpanningSkewTest is effectively empty
- getStressMatrix has no tests
- skewSymmetricMatrix has no tests -- Ryan 5/28
- we lack corner cases - e.g. G is empty
- RigidityTests and RigidityDocs should probably be removed - what is their purpose?
- missing description and references in Rigidity.m2
- what are the main functions? (should we add matrix completion, CM ideals)

## Tests and documentation
Need to document and or test:
* Iterations, Numerical, Field, FiniteField, 
* getSymmetricCompletionMatrix -- Ryan 5/28, 
* isFinitelyCompletable -- Ryan 5/28, 
* getFiniteCompletabilityMatrix -- Ryan 5/28, 
* isSpanningInSymmetricCompletionMatroid, 

Run `installPackage` to see what is still undocumented.

## trop(CM)
Go over documentation, perhaps a better name. --- Dan

# Done!
## No user variable names
`Variable=>` option is no more.
* Cayley-Menger Determinants --- Julian

## trop(CM)
Export:
* tropicalCayleyMenger n -- for ZZ (complete graph on n vertices)
    - memoize this ...  
    - ... or maximalTreePairs
    - produce output as list of maximal Cones (type in "Polyhedra")
* tropicalCayleyMenger G -- for graphs (given as list of edges)



