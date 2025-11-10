# To Do List:

## Issues
- Decide defult "null" variable name
- Explanation for what we're doing in overleaf file
- Check documentation in SymmetricCompletionDocs.m2 and SkewSymmetricCompletionDocs.m2
- uniformize folders/organization (less important)
- Testing: isGloballyRigid(2, G3) takes forever to run (in globallyRigidTests.m2), maybe problem with isGloballyRigid code?
  
## Documentation
 * -- warning: missing node: isGloballyRigid(...,FiniteField=>...) cited by isGloballyRigid
 * -- warning: missing node: isGloballyRigid(...,Iterations=>...) cited by isGloballyRigid
 * -- warning: missing node: isSpanningInSkewSymmetricCompletionMatroid(...,Numerical=>...) cited by Numerical
 * -- warning: missing node: isSpanningInSymmetricCompletionMatroid(...,Numerical=>...) cited by Numerical
 * -- warning: missing node: isSpanningInSkewSymmetricCompletionMatroid(...,FiniteField=>...) cited by isSpanningInSkewSymmetricCompletionMatroid
 * -- warning: missing node: getSymmetricCompletionMatrix(...,Variable=>...) cited by getSymmetricCompletionMatrix
 * -- warning: missing node: isSpanningInSymmetricCompletionMatroid(...,FiniteField=>...) cited by FiniteField
 * -- warning: missing node: getSkewSymmetricCompletionMatrix(...,Variable=>...) cited by getSkewSymmetricCompletionMatrix

Documented:
* getSkewSymmetricCompletionMatrix, 
* getRigidityMatrix, 
* isSpanningInSkewSymmetricCompletionMatroid, 
* isLocallyRigid,
* getStressMatrix,
* isGloballyRigid, 
* getAllTrees


Need to document:
* Iterations, Numerical, Field, FiniteField, 
* getSymmetricCompletionMatrix, 
* isFinitelyCompletable, 
* getFiniteCompletabilityMatrix, 
* isSpanningInSymmetricCompletionMatroid, 
* raysOfTreePairCone, ***
* raysOfUltrametricCone, 
* maximalTreePairs, ***
* edgeListToIndices, ***


### Other possible additions/alterations
* Cayley-Menger Determinants (compare with stress matrices?)
* ring creation subroutine (shared by several methods)
