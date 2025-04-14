# Data types

We would like to highlight several basic data types. 

## Lists
Use curly braces:
```
L = {1, bla, "bla"}
```
Access elements of the list with `_` or `#`
```
L_0
L_1
L#2
```
Lists behave somewhat like vectors.
```
10*{1,2,3} + {1,1,1}
```
Concatenate lists:
```
L | {3,4,5} | L
```
Loop over lists:
```
for i in L do
  print i
```

Create a list using a loop:
```
for i from 1 to 9 list (
  result := nextPrime i^2;
  << "completed step " << i << endl;
  result
  )
```

_Exercise._ Write a loop that creates a list of 
* first 10 `loadedPackages`
* first 10 prime numbers
* first 10 Fibonacci numbers


Note: e.g., there are also sequences,
```
S = (1, bla "bla")
```
and arrays,
```
A = [1, bla, "bla"]
```
For a more extensive overview see
```
viewHelp "lists and sequences"
```

## Hash tables

Tables with efficient lookup:
```
viewHelp "hash tables"
```

```
examples "hash tables"
```

Keys have values:
```
book = new HashTable from {
  Title => "My book",
  1 => "Introduction",
  2 => "Preliminaries",
  3 => "More stuff",
  PagesWithPictures => {2,5,7},
  "theorem" => {4,6} 
  }
```
Get a value for a key:
```
book.Title
book.PagesWithPictures
```
Use `.` only with a symbol, use `#` for the rest:
```
book#1
book#"theorem"
```
See if there is an entry with the given key:
```
book.?Title
book#?"lemma"
```

Get keys and values as lists
```
keys book
```
```
values book
```

Many types are inherited from `HashTable`, for instance,
```
loadedPackages#0
```
Sometimes you need to peek to see the content.
```
peek loadedPackages#3
```

_Exercise._ Create a hash table where 
* the keys are the numbers from 1 to 10 with the corresponding values are the first 10 letters of the alphabet 
* the keys are first 10 `loadedPackages` and the values are their versions

## Mutable vs. immutable

Most types in Macaulay2 are immutable. General rule: use mutable types only if neccessary for efficiency.

For instance, concatenating two (immutable) lists always creates a new immutable list.

This code 
```
L = {}
for i from 1 to 10 do 
  L = L | {i^2}
```
creates the list `L` of 10 squares, but creates (and eventually destroys) 10 intermediate lists.
```
L = new MutableList
for i from 1 to 10 do 
  L#(i-1) = i
```
```
L
```
```
peek L
```
Once again, types `MutableList` and `MutableHashTable` are less popular and have fewer methods implemented using them.
```
methods MutableList
```
```
methods List
```
