# Gaussian Mixture Models

Some references:
1. Moment Varieties of Gaussian Mixtures (https://arxiv.org/abs/1510.04654)
    - C. Am\'endola, J.-C. Faug\`ere and B. Sturmfels, Moment varieties of Gaussian mixtures, J. Algebr. Stat. {\bf 7} (2016), no.~1, 14--28; MR3529332, [link](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwj22dy5udqMAxWm6skDHRp7CPQQFnoECC0QAQ&url=https%3A%2F%2Fwww.publishoa.com%2Findex.php%2Fjournal%2Farticle%2Fview%2F14%2F14&usg=AOvVaw0dUobzVUZrZ16ObGLwUDC7&opi=89978449).
2. Estimating Gaussian mixtures using sparse polynomial moment systems (https://arxiv.org/abs/2106.15675)
    - J. Lindberg, C. Am\'endola and J.~I. Rodriguez, Estimating Gaussian mixtures using sparse polynomial moment systems, SIAM J. Math. Data Sci. {\bf 7} (2025), no.~1, 224--252; MR4858713, [link](https://epubs.siam.org/doi/10.1137/23M1610082).
3. Method of moments for Gaussian mixtures: Implementations and benchmarks (https://arxiv.org/abs/2502.07648)
    - Haley Colgate Kottler, Julia Lindberg


TODOS:
1. Document the existing code
2. Write tests for the existing code
3. Break apart solveGaussianSystem into smaller useful functions
4. Compare our code against existing state of art
5. Look into follow up ideas in the overleaf

Real version of this problem:
1. Find closest univariate polynomial to inputed univariate polynomial that has all real roots (Hermite form of polynomial)
2. Function to compute GKZ discriminant
3. Function to perform Euclidean distance optimization to project to discriminant
4. Function to compute discriminant of univariate polynomial
5. Function that projects complex solution to reals then refines via mesh/grid search
6. Read "An algebraic-geometric approach for linear regression without correspondences" to see if they have good idea for denoise 
