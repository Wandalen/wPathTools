# Path

Path is a string or container of strings to describe location or name of where file is located.

### The structure of paths

Module allows declaring paths in several ways.

#### Null or empty string

Indicates absence of a path. The module handles `null` and `empty string` equally.

```js
let absencePath1 = null;
let absencePath2 = '';
```

#### String

A single value, which declares absolute or relative path to file. It is canonical form of paths.

```js
let absolute = '/usr/bin';
// absolute path in POSIX systems
let relative = './some/path'
// relative path
```

#### Instance of constructor

Can define single value or collection of paths. Paths defines as properties of constructor.

```js
let Constr = function( v )
{
  this.value = v;
  return this;
};
let path = new Constr( '/some' );
// returns { value : '/some' }
```

#### Array

A collection of paths, each element of array indicates separate path.

```js
let paths = [ '/a/b', './b/c' ];
```
`Array` of paths can contain only `string` and `instance` paths and should exclude `null` values, `empty strings` and `bool-like` elements.

#### Map

A collection of paths, each pair `key-value` defines two paths. The key defines a source path `src`, and value defines destination path `dst`. If `dst` is `null` or `empty string` it indicates absence of path;

```js
let fullPaths = { '/src/a' : './dst/b' };
let srcPaths = { '/src/a' : '' };
```

`Map` of paths has no restriction for types of paths.

#### Bool-like

Uses in `maps` of paths, indicates possibility of use `src` path

```js
let usedPaths = { '/src/a' : true, './src/b' : 1 };
// source path '/src/a' can be used

let unusedPaths = { '/src/a' : false, './src/b' : 0 };
// source path '/src/a' can't be used
```

[Back to content](../README.md#Concepts)
