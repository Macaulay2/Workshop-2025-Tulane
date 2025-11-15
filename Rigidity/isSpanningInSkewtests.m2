-- Test for isSpanningInSkewSymmetricCompletionMatroid
TEST ///
-- Test for K_3,3 Bipartite graph(should not be spanning)
G = completeMultipartiteGraph({3,3})
assert(isSpanningInSkewSymmetricCompletionMatroid(2, G) === false)

-- Test for  complete graph(should be spanning)
G = completeGraph 4
assert(isSpanningInSkewSymmetricCompletionMatroid(4, G) === true)

-- Test with disconnected graph (should never be spanning)
G = graph({0,1,2},{{0,1}})
assert(isSpanningInSkewSymmetricCompletionMatroid(2, G) === false)

///

