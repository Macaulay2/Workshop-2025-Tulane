setRandomSeed(415)
needsPackage "GaussianMixtureModels"
needsPackage "NumericalAlgebraicGeometry"
-- Testing Homotopy track
k = 7
T = getPowerSystem(random(QQ^k,QQ^k),flatten entries random(QQ^k,QQ^1));
sols1 = apply(k,i->1)
sols2 = flatten entries random(QQ^k,QQ^1);
S1 = apply(flatten entries vars ring first T,var -> var^k-1);
S2 = getStartingSystem(T,sols2);
--evaluate(polySystem S,matrix{sols})
track(S1,T,{toSequence sols1},gamma => (7-ii),Predictor => Tangent,tStep => 0.01)
track(S2,T,{toSequence sols2},gamma => (7-ii),Predictor => Tangent,tStep => 0.01)
track(S2,T,{toSequence sols2},gamma => (7-0.5*ii),Predictor => Tangent,tStep => 0.001)

--- Testing solvePowerSystem
for i from 200 to 300 do (
    mu = flatten entries random(QQ^i,QQ^1);
    m = fabricateMoments(mu);
    (A,B) = produceMomentSystemMatrices(i,1/1);
    elapsedTime out = solvePowerSystem(A,flatten entries(m-B));
    print(sort apply(mu,i->i_RR));
    print(sort out);
    )

---
m = fabricateMoments({1,2})
(A,B) = produceMomentSystemMatrices(2,1/1)
solvePowerSystem(A,flatten entries (m-B))
--
for i from 1 to 20 do (
    M := produceMomentSystemMatrices(i,1/1);
    print M
    )
