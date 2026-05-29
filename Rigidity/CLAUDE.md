# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Macaulay2 package called `Rigidity` for rigidity theory computations. It covers local/global rigidity of graphs, symmetric and skew-symmetric matrix completion matroids, non-symmetric (finite) matrix completion, and tropical Cayley-Menger geometry.

## Running and Testing

From within Macaulay2, load the package from the parent directory of `Rigidity/`:

```macaulay2
restart
needsPackage "Rigidity"       -- load without installing
check "Rigidity"              -- run all TEST blocks
installPackage "Rigidity"     -- install; also reveals undocumented exports
```

To run a single test block interactively, load the relevant `*Tests.m2` file directly after `needsPackage "Rigidity"`.

## Package Architecture

`Rigidity.m2` is the package entry point. It:
1. Declares exports and loads all implementation files from `./Rigidity/`.
2. Calls `beginDocumentation()` then loads all `*Docs.m2` files.
3. Loads all `*Tests.m2` files (each contains one or more `TEST ///...///` blocks).

### Implementation files → Doc/Test file pairs

| Implementation | Docs | Tests |
|---|---|---|
| `getRigidityMatrix.m2`, `isLocallyRigid.m2` | `RigidityDocs.m2` | `locallyRigidTests.m2` |
| `isGloballyRigid.m2`, `getStressMatrix.m2` | `GlobalRigidityDocs.m2` | `globallyRigidTests.m2` |
| `symmetricMatrices.m2` | `SymmetricCompletionDocs.m2` | `symmetricMatricesTest.m2` |
| `skewSymmetricMatrices.m2` | `SkewSymmetricCompletionDocs.m2` | `skewSymmetricMatricesTest.m2` |
| `MatrixCompletionNonSymmetric.m2` | `MatrixCompletionNonSymmetricDocs.m2` | `MatrixCompletionNonSymmetricTests.m2` |
| `CayleyMenger.m2`, `cayleyMengerIdeal.m2`, `getCayleyMengerMatrix.m2` | `CayleyMenger-docs.m2`, `cayleyMengerIdealDocs.m2` | `CayleyMenger-tests.m2`, `cayleyMengerIdealTest.m2` |

### Key exported functions

- **Rigidity:** `getRigidityMatrix`, `isLocallyRigid`, `getStressMatrix`, `isGloballyRigid`
- **Symmetric completion matroid:** `getSymmetricCompletionMatrix`, `isSpanningInSymmetricCompletionMatroid`
- **Skew-symmetric completion matroid:** `getSkewSymmetricCompletionMatrix`, `isSpanningInSkewSymmetricCompletionMatroid`
- **Non-symmetric (finite) completion:** `getFiniteCompletabilityMatrix`, `isFinitelyCompletable`
- **Cayley-Menger:** `getCayleyMengerMatrix`, `cayleyMengerDeterminants`, `tropicalCayleyMenger`

### Options pattern

Most matroid-spanning functions share the options `Numerical => Boolean` (evaluate at random rationals) and `FiniteField => ZZ` (evaluate over GF(q)). `isLocallyRigid` uses `Field => Ring` and `Iterations => ZZ` instead. Both patterns run confidence checks and error if results disagree across iterations.

## Documentation format

All docs live in `*Docs.m2` files and use the `doc ///...///` syntax. Each node must include `Key` (with all method signatures), `Headline`, `Usage`, `Inputs`, and `Description` with at least one `Example`. See `RigidityDocs.m2` for a canonical example.

## Test format

Tests use `TEST ///...///` blocks with `assert(...)` statements. Each block should have a comment above naming the test. See `locallyRigidTests.m2` and `symmetricMatricesTest.m2` for canonical examples.

## Known issues (see todo.md)

- `skewSymmetricMatricesTest.m2` is effectively empty — asserts are commented out.
- `isGloballyRigid(2, G3)` hangs in `globallyRigidTests.m2`.
- Vertex numbering is 0-indexed in completion functions but 1-indexed in Cayley-Menger functions.
- `RigidityTests.m2` and `RigidityDocs.m2` may be vestigial.
