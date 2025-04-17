needsPackage"ExteriorExtensions"
ea = buildAlgebra(3,9); 
E = ea.appendage
E_0*E_3*E_7
t1 = sum({0,1,2}, k-> random(QQ)*E_k)*sum({3,4,5}, i-> sum({6,7,8}, j-> random(QQ)*E_i*E_j))
t11 = sum({0,1,2}, k-> random(QQ)*E_k)*sum({3,4,5}, i-> sum({6,7,8}, j-> random(QQ)*E_i*E_j))


t2 = sum({3,4,5}, k-> random(QQ)*E_k)*sum({0,1,2}, i-> sum({6,7,8}, j-> random(QQ)*E_i*E_j))
t3 = sum({6,7,8}, k-> random(QQ)*E_k)*sum({0,1,2}, i-> sum({3,4,5}, j-> random(QQ)*E_i*E_j))
s = t1 +t2
s3 = t1+t2+t3;
M1 = ea.ad(t1);
M11 = ea.ad(t11);
M2 = ea.ad(t2);
M3 = ea.ad(t3);
ea.prettyBlockRanks(M1) -- slice rank 1
ea.prettyBlockRanks(M1+M11) -- slice rank 2 (both same kind of slice)
ea.prettyBlockRanks(M1+M2) -- slice rank 2 (different kinds of slices)

ea.prettyBlockRanks(M1 + M2 + M3) -- slice rank 3

p1 = sum(3, i-> E_(0+i)*E_(3+i)*E_(6+i)) 
p1 = sum(3, i-> E_(0+i)*E_(3+i)*E_(6+i)) 
P = ea.ad(p);
ea.prettyBlockRanks(P)


p1 = sum({{0,1,2}, {3,4,5}, {6,7,8}}, term -> product(term, i-> E_i))

p2 = sum({{0,3,6}, {1,4,7}, {2,5,8}}, term -> product(term, i-> E_i))

p3 = sum({{0,3,5}, {1,4,6}, {2,7,8}}, term -> product(term, i-> E_i))

P1 = ea.ad(p1);
P2 = ea.ad(p2);
P3 = ea.ad(p3);
ea.prettyBlockRanks(random(QQ)*P1 )
ea.prettyBlockRanks(random(QQ)*P1 + random(QQ)*P2)
ea.prettyBlockRanks(random(QQ)*P1 + random(QQ)*P2 + random(QQ)*P3 )