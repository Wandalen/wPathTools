# Path

Path is the complete location or name of where a file or web page is located.

### The types of paths

Module allows declaring path as:

- `null` or `empty string` - indicates absence of a path;

```js
_.path.simplify( null ); // returns ''
_.path.simplify( '' );   // returns ''
```

- `string` - a single value, which declares absolute or relative path to file;

```js
_.path.simplify( '/a/b/c' ); // returns '/a/b/c'
_.path.simplify( './a/b/c' ); // returns './a/b/c'
```

- `instance of constructor` - a single value or collection of paths;

```js
var Constr = function( val )
{
  this.value = val;
  return this;
}
_.path.simplify( new Constr( '/dir' ) );
// returns { value : '/dir' }
```

- `array` - a collection of paths, every element of array indicates separate path;

```js
_.path.simplify( [ '/a/b', '/b/c', './c/d' ] );
// returns [ '/a/b', '/b/c', './c/d' ]
```

- `map` - a collection of paths, every pair `key-value` defines two paths. The key defines a source path `src`, and value defines destination path `dst`. If `dst` is `null` or `empty string` it indicates absence of path.

```js
_.path.simplify( { '/src/a' : './dst/b' } );
// returns { '/src/a' : './dst/b' }
```

- `bool-like` - uses in `maps` of paths, indicates possibility of use path;

```js
_.path.simplify( { '/src/a' : true } );
// returns { '/src/a' : true }, can use `src` path

_.path.simplify( { '/src/a' : 0 } );
// returns { '/src/a' : true }, can't use `src` path
```

### Restrictions in collections of paths

For correct work of module, collections of paths should contain next types

| value        | `array`          | `map`         |
|--------------|------------------|---------------|
| null         | -                | +             |
| empty string | -                | +             |
| bool-like    | -                | +             |
| string       | +                | +             |
| instance     | +                | +             |

### Summary

- Modules `PathBasic` and `PathTools` can use next types of path: `null`, `empty string`, `string`, `instance`, `array`, `map`, `bool-like`.
- `array` of path can contain `string` and `instance` paths.
- Every pair `key-value` of `map` of path defines two paths. Key defines a source path, value defines a destination path.

[Back to content](../README.md#Concepts)
