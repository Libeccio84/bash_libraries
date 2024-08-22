# bash_libraries
Set of useful bash functions

## arrayLibrary.sh
This is a set of functions which handle positional arrays and print to stdout. These functions are mainly intended to be used with
```bash
readarray -t myNewList <<< "$(lib.xxxxxx <args>)"
```
Any array must be passed to these functions marely by its name, for instance
```bash
a=(1 2 3)
lib.printArray a
```
| **Caveat** |
|:--|
|Following functions have been developed working with standard file paths and some use regex.<br>If an array element contains any regex special character (_e.g._ `*`, `[`, ...), `lib.deltaSet`, `lib.mergeSet` and `lib.intersectSet` functions are likely to fail.|

### lib.printArray
This is a wrapper for `printf` which can be used as follows:
```bash
lib.printArray a
lib.printArray <pattern> a
```
In the first case, `a` elements will be printed on separate lines (_i.e._ `<pattern>` is `'%s\n'`), in the second case `<pattern>` will be passed to `printf` (_e.g._ `lib.printArray '%s-' a`)

### lib.printArrays
This function extends `lib.printArray`to multiple arrays.

### lib.isin
This function returns 0 if the first argument is an element of the second argument (the array):
```bash
$ a=(1 2 3)
$ lib.isin 1 a && echo ok || echo ko
ok
$ lib.isin 5 a && echo ok || echo ko
ko
```

### lib.deltaSet
This function prints the first array without any element contained in the second one. For instance:
```bash
$ a=(1 2 3 4)
$ b=(3 4 5 6)
$ c=(7 8 9)
$ lib.deltaSet a b
1
2
$ lib.deltaSet b a
5
6
$ lib.deltaSet b c
3
4
5
6
```

### lib.mergeSet
This function acts as set union: it prints two input lists removing duplicates.<br>
Example:
```bash
$ a=( 1 2 3 1 4 )
$ b=( 1 3 5 6 6 )
$ lib.mergeSet a b
1
2
3
4
5
6
```

### lib.intersectSet
This function acts as set intersection: it prints only elements belonging to both list (dropping duplicates).<br>
Example:
```bash
$ a=( 1 2 3 1 4 )
$ b=( 1 3 5 6 6 )
$ lib.intersectSet a b
1
3
```

### lib.dropDuplicates
This function overwrites input list sorting it and removing duplicates.<br>
Example:
```bash
$ a=(1 2 2 4 3 4 5)
$ lib.dropDuplicates a
$ printf '%s\n' a
1
2
3
4
5
```
