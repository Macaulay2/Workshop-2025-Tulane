
# Auxillary Algebras for spaces of tensors

## Using algeras to study 


Here are some starring points for this project:

## Lie algebra actions on Schur modules

Implement the standard action of $\mathfrak{sl}_2$ on $\mathbb{C}^2$.

More generally, implement the action of  $\mathfrak{sl}_n$ on the modules $\bigwedge^k \mathbb{C}^n$, and on $S^d \mathbb{C}^n$.

Consider the Schur module $S_{2,1}\mathbb{C}^2$, whose basis is given by the semi-standard Young tableaux of shape (2,1) and content in $`\{0,1\}`$: There are two:
$`\begin{array}{l}\fbox{0}\fbox{0} \\ \fbox{1}\end{array}`$, $`\begin{array}{l}\fbox{0}\fbox{1}\\\fbox{1}\end{array}`$ or
`{{0,0},{1}},  {{0,1},{1}} `

However, the module is also the span of all tableaux of the same shape and content modulo a set of straightening rules. Make a ring whose variables have tableaux as their indices, an ideal of straightening rules and present the module $S_{2,1}\mathbb{C}^2$ by the quotient.

Define the $`\mathfrak{sl}_2`$-action on $`S_{2,1}\mathbb{C}^2 \subset (\mathbb{C}^2)^{\otimes 3}`$, by using the definition of the action on the space of tensors $` \mathbb{C}^2 \otimes \mathbb{C}^2 \otimes \mathbb{C}^2 `$ via the Leibnitz rule. 

Repeat the same exercise for $`\mathfrak{sl}_3`$ acting on $`S_{2,1}\mathbb{C}^3`$.

Define the Lie algebra action of $`\mathfrak{sl}_2 \times \mathfrak{sl}_2 \times \mathfrak{sl}_2`$ acting on $`\mathbb{C}^2
\otimes \mathbb{C}^2 \otimes \mathbb{C}^2`$ as follows. Define the ring 
`R = QQ[x_(0,0,0)..x_(1,1,1)]` 
with $x_i \otimes x_j \otimes x_k = x_{(i,j,k)}$. 
Define a map that takes a triple of matrices `(A,B,C)` and a variable `x_(i,j,k)` and sends it to the result: 
$(Ax_i) \otimes x_j \otimes x_k + x_i \otimes (Bx_j) \otimes x_k  + x_i \otimes x_j \otimes (Cx_k) $

Repeat this with $\mathfrak{sl}_3 \times \mathfrak{sl}_3 \times \mathfrak{sl}_3$ acting on $\mathbb{C}^3
\otimes \mathbb{C}^3 \otimes \mathbb{C}^3$ 

## Making graded rings
Make the graded ring $\mathfrak{g}_0 \oplus \mathfrak{g}_1 = \mathfrak{sl}_2 \oplus \mathbb{C}^2$. The product $\mathfrak{g}_0 \times \mathfrak{g}_0 \to \mathfrak{g}_0$ is the Lie bracket: $[A,B] = AB-BA$. The product $\mathfrak{g}_0 \times \mathfrak{g}_1 \to \mathfrak{g}_1$ is the usual matrix-vector product: $[A,v] = Av$. Declare the product to be skew-commuting so that $[v,A] = -[A,v]$ (you may actually want to make it a commuting product - check this), and define the product $\mathfrak{g}_1 \times \mathfrak{g}_1 \to \mathfrak{g}_0$ to be $[v,w] = A$ to be the matrix $A$ so that $[A,v] = w$. 

Repeat this exercise for the other algebra-module pairs above.

For $\mathbb C^3$, we actually define a $\mathbb Z_3$-graded algebra $\mathfrak{g}$, with $\mathfrak g_0 = \mathfrak{sl}_3$, $\mathfrak g_1 = \mathbb C^3$ and $\mathfrak g_2 = \bigwedge ^2 \mathbb C^3  = (\mathbb C^3)^*$. The products $\mathfrak g_0 \times \mathfrak g_1$  and $\mathfrak g_0 \times \mathfrak g_2$ are the usual Lie algebra action. The product $\mathfrak g_1 \times \mathfrak g_1 \to \mathfrak g_2$ is the wedge product. The other products can be obtained from these by defining the structure tensor from the information we have, then using that structure tensor to define the other products. 

## Sporadic isomorphisms and special cases
We have a sporratic isomorphism $\mathfrak{sl}_4 \oplus \bigwedge^2 \mathbb{C}^4 \cong \mathfrak{sp}_4$, where $\mathfrak{sl}_4$ is the traceless $4\times 4$ matrices, $\bigwedge^2 \mathbb{C}^4$ is the skew-symmetric $4\times 4$ matrices. 

-- make a copy of the symplectic Lie algebra $\mathfrak{sp}_4$ as a ring in M2 with the product being the Lie bracket. 

## Adjoint operators

If $\mathfrak g$ is an algebra, then we can define adjoint operators $\text{ad}_X \colon \mathfrak g \to \mathfrak g$ for each $X\in \mathfrak g$. 
* Construct the map that makes the matrix of an adjoint operator by choosing a basis the source and target.
* Construct adjoint operators as a hash function in order to utilize sparseness. 

