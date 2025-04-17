-- Test for K_3,3 Bipartite graph(should not be spanning)
G = completeMultipartiteGraph({3,3})
assert(isSpanningInSkewSymmetricCompletionMatroid(2, G) === false)

-- Test for  complete graph(should be spanning)
G = completeGraph 4
assert(isSpanningInSkewSymmetricCompletionMatroid(4, G) === true)

   --Test for error when r= odd
G=completeGraph 2
assert(isSpanningInSkewSymmetricCompletionMatroid(3, G) === error)

-- Check that variable naming works correctly
G=completeGraph 2
M1 = getSkewSymmetricCompletionMatrix(2, G, Variable => "x");
M2 = getSkewSymmetricCompletionMatrix(2, G, Variable => "y");
assert(ring M1 =!= ring M2) -- should have different variable names

-- Test with empty graph (should never be spanning)
G = graph()
assert(isSpanningInSkewSymmetricCompletionMatroid(2, G) === false)

-- Test with r=0 (edge case)
G= graph ({0,1},{{0,1}})
assert(isSpanningInSkewSymmetricCompletionMatroid(0, G) === true)

-- Test that graph and list inputs give same results
G = graph({{0,1},{0,2}});
assert(isSpanningInSkewSymmetricCompletionMatroid(2, G) === 
    isSpanningInSkewSymmetricCompletionMatroid(2, {{0,1},{0,2}})
