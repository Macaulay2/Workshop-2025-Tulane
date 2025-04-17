TEST ///

-- testing on the bipartite graph which consists of two copies of K(3, 3) glued together on the bottom edge

restart
needsPackage "Rigidity"
check "Rigidity"
installPackage "Rigidity"

twoGlueK33 = {
        {0, 0}, {0, 1}, {0, 2},
        {1, 0}, {1, 1}, {1, 2},
        {2, 0}, {2, 1}, {2, 3}, {2, 4},
        {3, 2}, {3, 3}, {3, 4},
        {4, 2}, {4, 3}, {4, 4}
    }
graph(twoGlueK33)
n = 5
m = 5
r = 1

A = getFiniteCompletabilityMatrix(Variable => x, r, n, m, twoGlueK33)
rank A
condition = r*(n + m - r)
///