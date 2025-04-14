# First steps in Macaulay2


### First steps: a homogeneous example ideal

Let's first take a homogeneous ideal and get the most common information about it.

Here we do this with the first key example in algebraic geometry: the ideal of the twised cubic curve!  

First we define the ring the ideal will sit in.
```m2
R = ZZ/32003[a..d]
I = ideal(a*d-b*c, a*c-b^2, b*d-c^2)
```

Let's compute the dimension, codimension (these two should add to 4, the number of variables), and the degree (this is geometrically the number of points of a general linear section of the zero set of complementary dimension.

```m2
dim I
codim I
degree I
```

The hilbert function `hilbertFunction(d, I)` is the dimension over the base field of the quotient vector space $(R/I)_3$.

```m2
hilbertFunction(3, I)
```

The Hilbert series of $I$ (really, of the $R$-module $R/I$) is the formal sum $$H_{R/I}(t) := \sum_{i=0}^\infty \dim (R/I)_d t^d.$$

Hilbert invented the notion of the finite free resolution of an idea;/module, to prove that this is a rational function in $t$.

```m2
hilbertSeries I
```
Hilbert also proved that if one divides by $1-t$ as much as possible, one obtains a power series $\frac{Q(t)}{(1-t)^m}$, where $Q$ is a polynomial with integer coefficients with $Q(1) \ne 0$, and $m = \dim R/I$ (this is one more that the dimension of the zero set of $I$ as a subvariety of projective space.

`reduceHilbert` does this division: it divides by $(1-t)$ as many times as possible.

```m2
reduceHilbert I
```

Thus, $\dim R/I = 2$, and $V(I) \subset \mathbb{P}^3$ is a curve.  Hilbert also proved from the above results that `hilbertFunction(d, I)`, for $d \gg 0$ is a polynomial of degree $d-1$, now called the **Hilbert polynomial**.


```m2
hilbertPolynomial(I, Projective => false)
```

In many ways, the minimal free resolution (unique up to isomorphism, i.e change of bases) is the most important invariant of an ideal or module.

```m2
F = res I
F.dd
```

The degrees in the matrices in the free resolution are homogeneous (if $I$ is).  For instance,
the first matrix has three generators of degree 2, and two first syzygies of degree 3.

*exercise*.  

- Look up the documentation and make sure you understand what the `betti` function displays.

```m2
betti F
```

# Ideals, matrices, lists, and complexes

You have seen lists, and above we have created ideals and complexes.  It is nice to be able to
switch from one type to another.

For example, we start with the ideal $I$ above.  How do we access the polynomials in it?  By indexing, using the underscore operator.
**Important Note!** All indexing for Macaulay2 (including indexing into lists, and matrices) is zero based!

```m2
R = ZZ/32003[a..d]
I = ideal(a*d-b*c, a*c-b^2, b*d-c^2)
```

```m2
for i from 0 to numgens I - 1 list I_i
```

This is so common, here is a faster way to do it:

```m2
I_*
```

Going back and forth from lists (of polynomials, all in the same ring) to ideals is pretty easy:
