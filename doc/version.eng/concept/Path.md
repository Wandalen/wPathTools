# Path

Path is a value, which defines a pointer of place in a file system.

### The types of paths

Module allows declaring path as:

- `null` or `empty string` - indicates absence of a path;
- `string` - a single value, which declares absolute or relative path to file. It is canonical form of paths;
- `instance of constructor` - a single value or collection of paths in instance;
- `array` - a collection of paths, each element of array indicates separate path;
- `map` - a collection of paths, each pair `key-value` defines two paths. The key defines a source path `src`, and value defines destination path `dst`. If `dst` is `null` or `empty string` it indicates absence of path;

```js
let fullPaths = { '/src/a' : './dst/b' };
let srcPaths = { '/src/a' : '' };
```

- `bool-like` - uses in `maps` of paths, indicates possibility of use `src` path;

```js
let usedPaths = { '/src/a' : true, './src/b' : 1 };
// source path '/src/a' can be used

let unusedPaths = { '/src/a' : false, './src/b' : 0 };
// source path '/src/a' can't be used
```

### The features of collections of paths

`Array` of paths can contain only `string` and `instance` paths and should exclude `nulls`, `empty strings` and `bool-like` values.

`Map` of paths has no restriction for types of paths.

[Back to content](../README.md#Concepts)
