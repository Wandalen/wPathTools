( function _PathTools_s_() {

'use strict';

/**
 * Collection of routines to operate paths reliably and consistently. Implements routines for manipulating paths maps and globing. Extends module PathBasic.
  @module Tools/base/Path
*/

/**
 * @file Path.s.
 */

/**
 * @summary Collection of routines to operate paths reliably and consistently.
 * @namespace "wTools.path"
 * @memberof module:Tools/PathTools
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );
  _.include( 'wPathBasic' );
  _.include( 'wStringsExtra' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Self = _.path = _.path || Object.create( null );

// --
// path map
// --

function filterPairs( filePath, onEach )
{
  let result = Object.create( null );
  let hasDst = false;
  let hasSrc = false;
  let it = Object.create( null );
  it.src = '';
  it.dst = '';

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  if( filePath === null || filePath === '' )
  {
    let r = onEach( it );
    elementsWrite( result, it, r );
  }
  else if( _.strIs( filePath ) )
  {
    it.src = filePath;
    let r = onEach( it );
    elementsWrite( result, it, r );
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.src = filePath[ p ];
      if( filePath[ p ] === null )
      it.src = '';
      if( _.boolIs( filePath[ p ] ) )
      {
      }
      else
      {
        let r = onEach( it );
        elementsWrite( result, it, r );
      }
    }
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];
      if( _.arrayIs( dst ) )
      {
        if( !dst.length )
        {
          it.src = src;
          it.dst = '';
          let r = onEach( it );
          elementsWrite( result, it, r );
        }
        else
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ];
          if( it.dst === null )
          it.dst = '';
          let r = onEach( it );
          elementsWrite( result, it, r );
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        if( it.dst === null )
        it.dst = '';
        let r = onEach( it );
        elementsWrite( result, it, r );
      }
    }
  }
  else _.assert( 0 );

  return end();

  /* */

  function elementsWrite( result, it, elements )
  {

    if( _.arrayIs( elements ) )
    {
      elements.forEach( ( r ) => elementsWrite( result, it, r ) );
      return result;
    }

    _.assert( elements === undefined || elements === null || _.strIs( elements ) || _.arrayIs( elements ) || _.mapIs( elements ) );

    if( elements === undefined )
    return result;

    if( elements === null || elements === '' )
    return elementWrite( result, '', '' );

    if( _.strIs( elements ) )
    return elementWrite( result, elements, it.dst );

    if( _.arrayIs( elements ) )
    {
      elements.forEach( ( src ) => elementWrite( result, src, it.dst ) );
      return result;
    }

    if( _.mapIs( elements ) )
    {
      for( let src in elements )
      {
        let dst = elements[ src ];
        elementWrite( result, src, dst );
      }
      return result;
    }

    _.assert( 0 );
  }

  /* */

  function elementWrite( result, src, dst )
  {
    if( _.arrayIs( dst ) )
    {
      if( dst.length )
      dst.forEach( ( dst ) => elementWriteSingle( result, src, dst ) );
      else
      elementWriteSingle( result, src, '' );
      return result;
    }
    elementWriteSingle( result, src, dst );
    return result;
  }

  /* */

  function elementWriteSingle( result, src, dst )
  {
    if( dst === null )
    dst = '';
    if( src === null )
    src = '';

    _.assert( _.strIs( src ) );
    _.assert( _.strIs( dst ) || _.boolLike( dst ) || _.instanceIs( dst ) );


    if( _.boolLike( dst ) )
    dst = !!dst;

    if( _.boolLike( result[ src ] ) )
    {
      if( dst !== '' )
      result[ src ] = dst;
    }
    else if( _.arrayIs( result[ src ] ) )
    {
      if( dst !== '' && !_.boolLike( dst ) )
      result[ src ] =  _.scalarAppendOnce( result[ src ], dst );
    }
    else if( _.strIs( result[ src ] ) || _.instanceIs( result[ src ] ) )
    {
      if( result[ src ] === '' || result[ src ] === dst || dst === false )
      result[ src ] = dst;
      else if( result[ src ] !== '' && dst !== '' )
      {
        if( dst !== true )
        result[ src ] =  _.scalarAppendOnce( result[ src ], dst );
      }
    }
    else
    result[ src ] = dst;

    // result[ src ] = _.scalarAppendOnce( result[ src ], dst );

    if( src )
    hasSrc = true;

    if( dst !== '' )
    hasDst = true;

    return result;
  }

  /* */

  function end()
  {
    let r;

    if( result[ '' ] === '' )
    delete result[ '' ];

    if( !hasSrc )
    {
      if( !hasDst )
      return '';
      return result;
    }
    else if( !hasDst )
    {
      r = _.mapKeys( result );
    }
    else
    return result;

    if( _.arrayIs( r ) )
    {
      if( r.length === 1 )
      r = r[ 0 ]
      else if( r.length === 0 )
      r = '';
    }

    _.assert( _.strIs( r ) || _.arrayIs( r ) )
    return r;
  }

}

//

// function _filterPairsInplace( filePath, onEach )
function _filterPairsInplace( o )
{
  let result = Object.create( null );
  let hasDst = false;
  let hasSrc = false;
  let it = Object.create( null );
  it.src = '';
  it.dst = '';

  _.routineOptions( _filterPairsInplace, arguments );
  _.assert( arguments.length === 1 );
  _.assert( o.filePath === null || _.strIs( o.filePath ) || _.arrayIs( o.filePath ) || _.mapIs( o.filePath ) );
  _.routineIs( o.onEach );

  if( _.strIs( o.filePath ) || o.filePath === null )
  {
    if( o.filePath === null )
    o.filePath = '';
    if( o.isSrc )
    it.src = o.filePath;
    else
    it.dst = o.filePath;

    let r = o.onEach( it );

    elementsWrite( result, it, r );

    if( _.arrayIs( result ) )
    {
      o.filePath = normalizeArray( _.mapKeys( result ) );
      if( o.filePath.length === 0 )
      return '';
      if( o.filePath. length === 1 )
      return o.filePath[ 0 ];
      else
      return o.filePath;
    }
    else
    {
      o.filePath = result;

      if( _.mapIs( o.filePath ) )
      {
        let keys = _.mapKeys( o.filePath );
        let vals = _.mapVals( o.filePath );
        if( o.isSrc )
        {
          if( vals.length === 1 && ( vals[ 0 ] === '' || vals[ 0 ] === null ) )
          return keys[ 0 ];
        }
        else
        {
          if( keys.length === 1 && keys[ 0 ] === '' )
          return vals[ 0 ];
        }
      }

      return o.filePath;
    }
  }
  else if( _.arrayIs( o.filePath ) )
  {
    let filePath2 = _.arrayAppendArraysOnce( [], o.filePath );
    o.filePath.splice( 0, o.filePath.length );
    for( let p = 0 ; p < filePath2.length ; p++ )
    {
      it.src = filePath2[ p ];
      if( filePath2[ p ] === null )
      it.src = '';
      if( _.boolIs( filePath2[ p ] ) )
      {
      }
      else
      {
        let r = o.onEach( it );
        elementsWrite( result, it, r );
      }
    }
    _.arrayAppendArrayOnce( o.filePath, normalizeArray( _.mapKeys( result ) ) );
  }
  else if( _.mapIs( o.filePath ) )
  {
    for( let src in o.filePath )
    {
      let dst = o.filePath[ src ];

      delete o.filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        if( !dst.length )
        {
          it.src = src;
          it.dst = '';
          let r = o.onEach( it );
          elementsWrite( o.filePath, it, r );
        }
        else
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ];
          if( dst[ d ] === null )
          it.dst = '';
          let r = o.onEach( it );
          elementsWrite( o.filePath, it, r );
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        if( dst === null )
        it.dst = '';
        let r = o.onEach( it );
        elementsWrite( o.filePath, it, r );
      }
    }
  }
  else _.assert( 0 );

  if( _.mapIs( o.filePath ) )
  {
    if( o.filePath[ '' ] === '' )
    delete o.filePath[ '' ];
  }

  return o.filePath;

  /* */

  function elementsWrite( filePath, it, elements )
  {

    /* qqq : cover and implement for filterPairs, please */
    if( elements === it )
    {
      _.assert( it.src === null || _.strIs( it.src ) || _.arrayIs( it.src ) );
      _.assert( it.dst === null || _.strIs( it.dst ) || _.arrayIs( it.dst ) || _.boolLike( it.dst ) );
      elements = Object.create( null );
      if( _.arrayIs( it.src ) )
      {
        for( let s = 0 ; s < it.src.length ; s++ )
        put( elements, it.src[ s ], it.dst );
      }
      else
      {
        put( elements, it.src, it.dst );
      }
    }

    _.assert( elements === undefined || elements === null || _.strIs( elements ) || _.arrayIs( elements ) || _.mapIs( elements ) );

    if( elements === undefined )
    return filePath;

    if( elements === null || elements === '' )
    return elementWrite( filePath, '', '' );

    if( _.strIs( elements ) )
    if( o.isSrc )
    return elementWrite( filePath, elements, it.dst );
    else
    return elementWrite( filePath, it.src, elements );

    if( _.arrayIs( elements ) )
    {
      if( elements.length === 0 )
      return elementWrite( filePath, '', '' );
      elements.forEach( ( r ) => elementsWrite( filePath, it, r ) );
      return filePath;
    }

    if( _.mapIs( elements ) )
    {
      for( let src in elements )
      {
        let dst = elements[ src ];
        elementWrite( filePath, src, dst );
      }
      return filePath;
    }

    _.assert( 0 );
  }

  /* */

  function put( container, src, dst )
  {
    if( src === null )
    src = '';
    if( dst === null )
    dst = '';
    _.assert( container[ src ] === undefined || container[ src ] === dst );
    _.assert( _.strIs( src ) );
    _.assert( _.strIs( dst ) || _.arrayIs( dst ) || _.boolLike( dst ) );
    container[ src ] = dst;
  }

  /* */

  function elementWrite( filePath, src, dst )
  {
    if( _.arrayIs( dst ) )
    {
      if( dst.length )
      dst.forEach( ( dst ) => elementWriteSingle( filePath, src, dst ) );
      else
      elementWriteSingle( filePath, src, '' );
      return filePath;
    }
    elementWriteSingle( filePath, src, dst );
    return filePath;
  }

  /* */

  function elementWriteSingle( filePath, src, dst )
  {
    if( dst === null )
    dst = '';
    if( src === null )
    src = '';

    _.assert( _.strIs( src ) );
    _.assert( _.strIs( dst ) || _.boolLike( dst ) || _.instanceIs( dst ) );

    if( _.boolLike( dst ) )
    dst = !!dst;

    if( _.boolLike( filePath[ src ] ) )
    {
      if( dst !== '' )
      filePath[ src ] = dst;
    }
    else if( _.arrayIs( filePath[ src ] ) )
    {
      if( dst !== '' && !_.boolLike( dst ) )
      filePath[ src ] =  _.scalarAppendOnce( filePath[ src ], dst );
    }
    else if( _.strIs( filePath[ src ] ) || _.instanceIs( filePath[ src ] ) )
    {
      if( filePath[ src ] === '' || filePath[ src ] === dst || dst === false )
      filePath[ src ] = dst;
      else if( filePath[ src ] !== '' && dst !== '' )
      {
        if( dst !== true )
        filePath[ src ] =  _.scalarAppendOnce( filePath[ src ], dst );
      }
    }
    else
    {
      filePath[ src ] = dst;
    }

    return filePath;
  }

  function normalizeArray( src )
  {
    return _.arrayRemoveElement( src, '' );
  }

}

_filterPairsInplace.defaults =
{
  filePath : null,
  onEach : null,
  isSrc : true,
}

//

function filterPairsInplace( filePath, onEach )
{
  return this._filterPairsInplace
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterSrcPairsInplace( filePath, onEach )
{
  return this._filterPairsInplace
  ({
    filePath,
    onEach,
    isSrc : true,
  });
}

//

function filterDstPairsInplace( filePath, onEach )
{
  return this._filterPairsInplace
  ({
    filePath,
    onEach,
    isSrc : false,
  });
}

//

function filterPairs_( dst, filePath, onEach )
{
  let self = this;
  let result = Object.create( null );

  argumentsCheckAndSet( arguments );

  let hasDst = false;
  let hasSrc = false;
  let it = Object.create( null );
  it.src = '';
  it.dst = '';

  if( filePath === null )
  filePath = '';
  if( _.strIs( filePath ) )
  {
    it.src = filePath;
    let r = onEach( it );
    elementsWrite( result, it, r );
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.src = filePath[ p ] === null ? '' : filePath[ p ];

      if( !_.boolIs( filePath[ p ] ) )
      {
        let r = onEach( it );
        elementsWrite( result, it, r );
      }
    }
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst1 = filePath[ src ];

      if( _.arrayIs( dst1 ) )
      {
        if( !dst1.length )
        {
          it.src = src;
          it.dst = '';
          let r = onEach( it );
          elementsWrite( result, it, r );
        }
        else
        for( let d = 0 ; d < dst1.length ; d++ )
        {
          it.src = src;
          it.dst = dst1[ d ] === null ? '' : dst1[ d ];
          let r = onEach( it );
          elementsWrite( result, it, r );
        }
      }
      else
      {
        it.src = src;
        it.dst = dst1 === null ? '' : dst1;
        let r = onEach( it );
        elementsWrite( result, it, r );
      }
    }
  }
  else
  _.assert( 0 );

  return end();

  /* */

  function elementsWrite( filePath, it, elements )
  {

    if( elements === undefined )
    return filePath;

    else if( elements === null || elements === '' )
    return elementWrite( filePath, '', '' );

    else if( _.strIs( elements ) )
    return elementWrite( filePath, elements, it.dst );

    else if( _.arrayIs( elements ) )
    {
      if( elements.length === 0 )
      return elementWrite( filePath, '', '' );

      for( let i = 0; i < elements.length; i++ )
      elementsWrite( filePath, it, elements[ i ] );
      return filePath;
    }

    else if( _.mapIs( elements ) )
    {
      for( let src in elements )
      elementWrite( filePath, src, elements[ src ] );
      return filePath;
    }
    else
    _.assert( 0 );
  }

  /* */

  function elementWrite( filePath, src, dst )
  {
    if( _.arrayIs( dst ) )
    {
      if( dst.length )
      dst.forEach( ( dst ) => elementWriteSingle( filePath, src, dst ) );
      else
      elementWriteSingle( filePath, src, '' );
      return filePath;
    }
    elementWriteSingle( filePath, src, dst );
    return filePath;
  }

  /* */

  function elementWriteSingle( filePath, src, dst )
  {
    if( dst === null )
    dst = '';
    if( src === null )
    src = '';

    _.assert( _.strIs( src ) );
    _.assert( _.strIs( dst ) || _.boolLike( dst ) || _.instanceIs( dst ) );

    if( _.boolLike( dst ) )
    dst = !!dst;

    if( _.boolLike( filePath[ src ] ) )
    {
      if( dst !== '' )
      filePath[ src ] = dst;
    }
    else if( _.arrayIs( filePath[ src ] ) )
    {
      if( dst !== '' && !_.boolLike( dst ) )
      filePath[ src ] =  _.scalarAppendOnce( filePath[ src ], dst );
    }
    else if( _.strIs( filePath[ src ] ) || _.instanceIs( filePath[ src ] ) )
    {
      if( filePath[ src ] === '' || filePath[ src ] === dst || dst === false )
      filePath[ src ] = dst;
      else if( filePath[ src ] !== '' && dst !== '' )
      {
        if( dst !== true )
        filePath[ src ] =  _.scalarAppendOnce( filePath[ src ], dst );
      }
    }
    else
    filePath[ src ] = dst;

    if( src )
    hasSrc = true;
    if( dst !== '' )
    hasDst = true;

    return filePath;
  }

  /* */

  function argumentsCheckAndSet( args )
  {
    if( args.length === 3 )
    {
      if( dst === null )
      dst = true;
      else if( dst === filePath )
      dst = false;
      else
      _.assert( _.arrayIs( dst ) || _.mapIs( dst ) );
    }
    else if( args.length === 2 )
    {
      onEach = filePath;
      filePath = dst;
      dst = true;
    }
    else
    _.assert( 0 );

    _.routineIs( onEach, '{-onEach-} should be a routine' );
  }

  /* */

  function end()
  {
    if( !hasSrc && !hasDst )
    result = '';
    else if( !hasDst )
    result = _.mapKeys( result );

    if( dst === false )
    {
      if( _.arrayIs( filePath ) )
      {
        filePath.splice( 0, filePath.length );

        if( _.arrayIs( result ) )
        result = _.arrayAppendArrayOnce( filePath, result );
        else if( _.mapIs( result ) )
        result = _.arrayAppendArrayOnce( filePath, _.mapKeys( result ) );
        else
        result = _.arrayAppendOnce( filePath, result );
      }
      else if( _.mapIs( filePath ) )
      {
        for( let k in filePath )
        delete filePath[ k ];

        if( _.mapIs( result ) )
        for( let k in result )
        filePath[ k ] = result[ k ];

        else if( _.arrayIs( result ) )
        for( let e of result )
        filePath[ e ] = '';
        else
        filePath[ result ] = '';

        result = filePath;
      }
      else if( _.primitiveIs( filePath ) )
      {
        if( result.length === 1 )
        return result[ 0 ];
        return result;
      }

      result = self.simplify_( result, result );
    }
    else
    {
      if( dst !== true )
      {
        if( _.arrayIs( dst ) )
        {
          if( _.arrayIs( result ) )
          result = _.arrayAppendArrayOnce( dst, result );
          else if( _.mapIs( result ) )
          result = _.arrayAppendArrayOnce( dst, _.mapKeys( result ) );
          else
          result = _.arrayAppendOnce( dst, result );
        }
        else if( _.mapIs( dst ) )
        {
          if( _.mapIs( result ) )
          for( let k in result )
          dst[ k ] = result[ k ];

          else if( _.arrayIs( result ) )
          for( let e of result )
          dst[ e ] = '';
          else
          dst[ result ] = '';

          result = dst;
        }
        result = self.simplify_( result, result );
      }
      else
      {
        if( result.length === 1 )
        return result[ 0 ];
        else if( result.length === 0 )
        return '';

        result = self.simplify_( null, result );
      }
    }

    if( _.mapIs( result ) && result[ '' ] === '' )
    delete result[ '' ];

    return result;
  }

}

//

function filterInplace( filePath, onEach )
{
  let it = Object.create( null );

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  if( filePath === null || _.strIs( filePath ) )
  {

    if( filePath === null )
    filePath = '';
    it.value = filePath;
    let r = onEach( it.value, it );

    if( r === undefined || r === null )
    return '';
    else if( _.strIs( r ) )
    return r;
    else if( _.arrayIs( r ) )
    r = write( it, r );

    if( r.length === 0 )
    return '';
    if( r.length === 1 )
    return r[ 0 ];
    else
    return r;
    // return self.simplify( r );
  }
  else if( _.arrayIs( filePath ) )
  {
    let filePath2 = filePath.slice();
    filePath.splice( 0, filePath.length );
    for( let p = 0 ; p < filePath2.length ; p++ )
    {
      it.index = p;
      it.value = filePath2[ p ];
      if( filePath2[ p ] === null )
      it.value = '';

      let r = onEach( it.value, it );
      if( r === undefined )
      continue;

      _.arrayAppendArraysOnce( filePath, r );
    }
    /* qqq : should be no simplify in the routine */
    // return self.simplifyInplace( filePath );
    return write( it, filePath );
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];

      delete filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        if( dst.length === 0 )
        {
          it.src = src;
          it.dst = '';
          it.value = it.src;
          it.side = 'src';
          let srcResult = onEach( it.value, it );
          it.side = 'dst';
          it.value = it.dst;
          let dstResult = onEach( it.value, it );
          write( filePath, srcResult, dstResult );
        }
        else
        {
          for( let d = 0 ; d < dst.length ; d++ )
          {
            it.src = src;
            it.dst = dst[ d ];
            if( dst[ d ] === null )
            it.dst = '';
            it.value = it.src;
            it.side = 'src';
            let srcResult = onEach( it.value, it );
            it.value = it.dst;
            it.side = 'dst';
            let dstResult = onEach( it.value, it );
            write( filePath, srcResult, dstResult );
          }
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        if( dst === null )
        it.dst = '';
        it.value = it.src;
        it.side = 'src';
        let srcResult = onEach( it.value, it );
        it.side = 'dst';
        it.value = it.dst;
        let dstResult = onEach( it.value, it );
        write( filePath, srcResult, dstResult );
      }

    }

    /* qqq : should be no simplify in the routine */
    //return self.simplifyInplace( filePath );
  }
  else _.assert( 0 );

  if( _.mapIs( filePath ) )
  {
    if( filePath[ '' ] === '' )
    delete filePath[ '' ];
  }

  return filePath;

  /* */

  function write( pathMap, src, dst )
  {
    if( src === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    src = '';
    if( dst === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    dst = '';
    if( _.arrayIs( dst ) && dst.length === 1 )
    dst = dst[ 0 ];
    if( _.boolLike( dst ) )
    dst = !!dst;

    _.assert( src === undefined || _.strIs( src ) || _.arrayIs( src ) );

    /*
      qqq : general rule of path element merging should be applied here
      - only non-empty strings could be in an array
      - have 3 groups of elements which cant coexist:
      -- non-empty str
      -- boolean-like,
      -- empty ( null or empty string )
    */

    if( dst !== undefined )
    {
      if( _.arrayIs( src ) )
      {
        for( let s = 0 ; s < src.length ; s++ )
        if( src[ s ] !== undefined )
        pathMap[ src[ s ] ] = append( pathMap[ src[ s ] ], dst );
      }
      else
      {
        if( src !== undefined )
        pathMap[ src ] = append( pathMap[ src ], dst );
      }
    }
    else if( _.arrayIs( src ) )
    {
      let src2 = src.slice();
      src.splice( 0, src.length );
      for( let i = 0 ; i < src2.length ; i++ )
      {
        if( src2[ i ] === null || src2[ i ] === '' || src2[ i ] === undefined || _.boolLike( src2[ i ] ) )
        continue;
        else
        {
          _.arrayAppendOnce( src, src2[ i ] );
        }
      }
      return src;
    }

  }

  function append( dst, src )
  {
    if( src === '' )
    dst = src;
    else if( _.boolLike( src ) )
    dst = src;
    else
    {
      if( _.strIs( dst ) || _.arrayIs( dst ) )
      dst = _.scalarAppendOnce( dst, src );
      else
      dst = src;
    }
    return dst;
  }

}

//

function filter( filePath, onEach )
{
  let self = this;
  let it = Object.create( null );

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  if( filePath === null || _.strIs( filePath ) )
  {
    it.value = filePath;
    if( filePath === null )
    it.value = '';
    let r = onEach( it.value, it );
    if( r === undefined )
    return null;
    return self.simplify( r );
  }
  else if( _.arrayIs( filePath ) )
  {
    let result = [];
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.index = p;
      it.value = filePath[ p ];
      if( filePath[ p ] === null )
      it.value = '';
      let r = onEach( it.value, it );
      if( r !== undefined )
      _.arrayAppendArraysOnce( result, r );
    }
    return self.simplify( result );
  }
  else if( _.mapIs( filePath ) )
  {
    let result = Object.create( null );
    for( let src in filePath )
    {
      let dst = filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        if( dst.length === 0 )
        {
          it.src = src;
          it.dst = '';
          it.value = it.src;
          it.side = 'src';
          let srcResult = onEach( it.value, it );
          it.value = it.dst;
          it.side = 'dst';
          let dstResult = onEach( it.value, it );
          write( result, srcResult, dstResult );
        }
        else
        {
          for( let d = 0 ; d < dst.length ; d++ )
          {
            it.src = src;
            it.dst = dst[ d ];
            if( dst[ d ] === null )
            it.dst = '';
            it.value = it.src;
            it.side = 'src';
            let srcResult = onEach( it.value, it );
            it.value = it.dst;
            it.side = 'dst';
            let dstResult = onEach( it.value, it );
            write( result, srcResult, dstResult );
          }
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        if( dst === null )
        it.dst = '';
        it.value = it.src;
        it.side = 'src';
        let srcResult = onEach( it.value, it );
        it.value = it.dst;
        it.side = 'dst';
        let dstResult = onEach( it.value, it );
        write( result, srcResult, dstResult );
      }

    }

    return self.simplify( result );
  }
  else _.assert( 0 );

  /* */

  function write( pathMap, src, dst )
  {
    if( src === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    src = '';
    if( dst === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    dst = '';

    _.assert( src === undefined || _.strIs( src ) || _.arrayIs( src ) );

    if( dst !== undefined )
    {
      if( _.arrayIs( src ) )
      {
        for( let s = 0 ; s < src.length ; s++ )
        if( src[ s ] !== undefined )
        pathMap[ src[ s ] ] = _.scalarAppend( pathMap[ src[ s ] ], dst );
      }
      else if( src !== undefined )
      {
        pathMap[ src ] = _.scalarAppend( pathMap[ src ], dst );
      }
    }

  }

}

// function filter( filePath, onEach )
// {
//   let self = this;
//   let it = Object.create( null );
//
//   _.assert( arguments.length === 2 );
//   _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
//   _.routineIs( onEach );
//
//   if( filePath === null || _.strIs( filePath ) )
//   {
//     it.value = filePath;
//     let r = onEach( it.value, it );
//     if( r === undefined )
//     return null;
//     return self.simplify( r );
//   }
//   else if( _.arrayIs( filePath ) )
//   {
//     let result = [];
//     for( let p = 0 ; p < filePath.length ; p++ )
//     {
//       it.index = p;
//       it.value = filePath[ p ];
//       let r = onEach( it.value, it );
//       if( r !== undefined )
//       result.push( r );
//     }
//     return self.simplify( result );
//   }
//   else if( _.mapIs( filePath ) )
//   {
//     let result = Object.create( null );
//     for( let src in filePath )
//     {
//       let dst = filePath[ src ];
//
//       if( _.arrayIs( dst ) )
//       {
//         dst = dst.slice();
//         for( let d = 0 ; d < dst.length ; d++ )
//         {
//           it.src = src;
//           it.dst = dst[ d ];
//           it.value = it.src;
//           it.side = 'src';
//           let srcResult = onEach( it.value, it );
//           it.value = it.dst;
//           it.side = 'dst';
//           let dstResult = onEach( it.value, it );
//           write( result, srcResult, dstResult );
//         }
//       }
//       else
//       {
//         it.src = src;
//         it.dst = dst;
//         it.value = it.src;
//         it.side = 'src';
//         let srcResult = onEach( it.value, it );
//         it.value = it.dst;
//         it.side = 'dst';
//         let dstResult = onEach( it.value, it );
//         write( result, srcResult, dstResult );
//       }
//
//     }
//
//     return self.simplify( result );
//   }
//   else _.assert( 0 );
//
//   /* */
//
//   function write( pathMap, src, dst )
//   {
//
//     _.assert( src === undefined || _.strIs( src ) || _.arrayIs( src ) );
//
//     if( dst !== undefined )
//     {
//       if( _.arrayIs( src ) )
//       {
//         for( let s = 0 ; s < src.length ; s++ )
//         if( src[ s ] !== undefined )
//         pathMap[ src[ s ] ] = _.scalarAppend( pathMap[ src[ s ] ], dst );
//       }
//       else if( src !== undefined )
//       {
//         pathMap[ src ] = _.scalarAppend( pathMap[ src ], dst );
//       }
//     }
//
//   }
//
// }

//

function filter_( dst, filePath, onEach )
{

  argumentsCheckAndSet( arguments );

  if( filePath === null )
  filePath = '';

  let result;
  let it = Object.create( null );

  if( dst === true )
  result = new filePath.constructor();
  else if( dst === false )
  result = filePath;
  else
  result = dst;

  if( _.strIs( filePath ) )
  {
    it.value = filePath;
    let r = onEach( it.value, it );
    if( r === undefined || r === null )
    r = '';
    else if( _.arrayIs( r ) )
    {
      if( r.length === 0 )
      r = '';
      else if( r.length === 1 )
      r = r[ 0 ];
    }

    if( _.arrayIs( result ) )
    _.arrayAppendOnce( result, r );
    else if( _.mapIs( result ) )
    result[ r ] = '';
    else
    result = r;
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0; p < filePath.length; p++ )
    {
      it.index = p;
      it.value = filePath[ p ] === null ? '' : filePath[ p ];

      let r = onEach( it.value, it );
      if( r === undefined || r === null )
      r = '';
      else if( _.arrayIs( r ) )
      {
        if( r.length === 0 )
        r = '';
        else if( r.length === 1 )
        r = r[ 0 ];
      }

      if( dst === false )
      result[ p ] = r;
      else if( _.arrayIs( result ) )
      _.arrayAppendArraysOnce( result, r );
      else if( _.mapIs( result ) )
      result[ r ] = '';
    }
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst1 = filePath[ src ];

      if( dst === false )
      delete filePath[ src ];

      if( _.arrayIs( dst1 ) )
      {
        dst1 = dst1.slice();
        if( dst1.length === 0 )
        {
          it.src = src;
          it.dst = '';
          it.value = it.src;
          it.side = 'src';
          let srcResult = onEach( it.value, it );
          it.side = 'dst';
          it.value = it.dst;
          let dstResult = onEach( it.value, it );
          write( result, srcResult, dstResult );
        }
        else
        {
          for( let d = 0 ; d < dst1.length ; d++ )
          {
            it.src = src;
            it.dst = dst1[ d ] === null ? '' : dst1[ d ];
            it.value = it.src;
            it.side = 'src';
            let srcResult = onEach( it.value, it );
            it.value = it.dst;
            it.side = 'dst';
            let dstResult = onEach( it.value, it );
            write( result, srcResult, dstResult );
          }
        }
      }
      else
      {
        it.src = src;
        it.dst = dst1 === null ? '' : dst1;
        it.value = it.src;
        it.side = 'src';
        let srcResult = onEach( it.value, it );
        it.side = 'dst';
        it.value = it.dst;
        let dstResult = onEach( it.value, it );
        write( result, srcResult, dstResult );
      }

    }
  }
  else _.assert( 0 );

  if( dst === true )
  result = this.simplify_( null, result );
  else
  {
    if( _.mapIs( result ) && result[ '' ] === '' )
    delete result[ '' ];
    result = this.simplify_( result, result );
  }

  return result;

  /* */

  function write( pathMap, src, dst )
  {
    if( src === null || ( _.arrayIs( src ) && src.length === 0 ) )
    src = '';
    if( dst === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    dst = '';
    if( _.arrayIs( dst ) && dst.length === 1 )
    dst = dst[ 0 ];
    if( _.boolLike( dst ) )
    dst = !!dst;

    if( dst !== undefined )
    {
      if( _.mapIs( pathMap ) )
      {
        if( _.arrayIs( src ) )
        {
          for( let s = 0 ; s < src.length ; s++ )
          if( src[ s ] !== undefined )
          pathMap[ src[ s ] ] = append( pathMap[ src[ s ] ], dst );
        }
        else if( _.strIs( src ) )
        pathMap[ src ] = append( pathMap[ src ], dst );
        else if( src !== undefined )
        _.assert( 0 );
      }
      else
      {
        if( _.arrayIs( src ) )
        {
          for( let s = 0; s < src.length; s++ )
          _.arrayAppendArrays( pathMap, [ src[ s ], dst ] );
        }
        else
        {
          if( src !== undefined )
          _.arrayAppendOnce( pathMap, src );
          if( dst !== undefined )
          _.arrayAppendOnce( pathMap, dst );

        }
      }
    }

    function append( dst, src )
    {
      if( src === '' )
      dst = src;
      else if( _.boolLike( src ) )
      dst = src;
      else
      {
        if( _.strIs( dst ) || _.arrayIs( dst ) )
        dst = _.scalarAppendOnce( dst, src );
        else
        dst = src;
      }
      return dst;
    }
  }

  /* */

  function argumentsCheckAndSet( args )
  {
    if( args.length === 3 )
    {
      if( dst === null )
      dst = true;
      else if( dst === filePath )
      dst = false;
      else
      _.assert( _.arrayIs( dst ) || _.mapIs( dst ) );
    }
    else if( args.length === 2 )
    {
      onEach = filePath;
      filePath = dst;
      dst = true;
    }
    else
    _.assert( 0 );

    _.routineIs( onEach, '{-onEach-} should be a routine' );
  }

}

//

function all( filePath, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  let it = Object.create( null );

  if( filePath === null || _.strIs( filePath ) )
  {
    it.value = filePath;
    let r = onEach( it.value, it );
    if( !r )
    return false;
    return true;
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.index = p;
      it.value = filePath[ p ];
      let r = onEach( it.value, it );
      if( !r )
      return false;
    }
    return true;
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ];
          it.value = it.src;
          it.side = 'src';
          var r = onEach( it.value, it );
          if( !r )
          return false;
          it.value = it.dst;
          it.side = 'dst';
          var r = onEach( it.value, it );
          if( !r )
          return false;
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        it.value = it.src;
        it.side = 'src';
        var r = onEach( it.value, it );
        if( !r )
        return false;
        it.value = it.dst;
        it.side = 'dst';
        var r = onEach( it.value, it );
        if( !r )
        return false;
      }

    }
    return true;
  }
  else _.assert( 0 );

}

//

function any( filePath, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  let it = Object.create( null );

  if( filePath === null || _.strIs( filePath ) )
  {
    it.value = filePath;
    let r = onEach( it.value, it );
    if( r )
    return true;
    return false;
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.index = p;
      it.value = filePath[ p ];
      let r = onEach( it.value, it );
      if( r )
      return true;
    }
    return false;
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ];
          it.value = it.src;
          it.side = 'src';
          var r = onEach( it.value, it );
          if( r )
          return true;
          it.value = it.dst;
          it.side = 'dst';
          var r = onEach( it.value, it );
          if( r )
          return true;
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        it.value = it.src;
        it.side = 'src';
        var r = onEach( it.value, it );
        if( r )
        return true;
        it.value = it.dst;
        it.side = 'dst';
        var r = onEach( it.value, it );
        if( r )
        return true;
      }

    }
    return false;
  }
  else _.assert( 0 );

}

//

function none( filePath, onEach )
{
  return !this.any.apply( this, arguments )
}

//

/*
qqq : implement good tests for routine isEmpty
Dmytro : implemented good tests. Uncomment refactored routine below, and uncomment test cases in test routine, please
*/

// function isEmpty( src )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1 );
//
//   if( src === null || src === '' )
//   return true;
//   else if( _.strIs( src ) )
//   return false;
//   else if( _.arrayIs( src ) )
//   {
//     if( src.length === 0 )
//     return true;
//     if( src.length === 1 )
//     if( src[ 0 ] === null || src[ 0 ] === '' )
//     return true;
//     return false;
//   }
//   else if( _.mapIs( src ) )
//   {
//     let keys = _.mapKeys( src );
//     if( keys.length === 0 )
//     return true;
//     if( keys.length === 1 )
//     if( src[ '' ] === null || src[ '' ] === '' )
//     return true;
//     return false;
//   }
//   else
//   _.assert( 0 );
// }

function isEmpty( src )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( src === null || _.arrayIs( src ) || _.strIs( src ) || _.mapIs( src ) );

  if( src === null || src === '' )
  return true;

  if( _.strIs( src ) )
  return false;

  if( _.arrayIs( src ) )
  {
    if( src.length === 0 )
    return true;
    if( src.length === 1 )
    if( src[ 0 ] === null || src[ 0 ] === '' || src[ 0 ] === '.' ) // qqq zzz : refactor to remove dot case | Dmytro : uncomment routine above, please
    return true;
    return false;
  }

  if( _.mapKeys( src ).length === 0 ) // Dmytro : missed
  return true;
  if( _.mapKeys( src ).length === 1 )
  if( src[ '.' ] === null || src[ '.' ] === '' || src[ '' ] === null || src[ '' ] === '' ) // qqq zzz : refactor to remove dot | Dmytro : uncomment routine above, please
  return true;

  return false;
}

//

/*
qqq kos : extend tests for routine mapExtend
qqq kos : cover single argument cases for routine mapExtend
Dmytro : coverage is extended, added test cases with single arguments
*/

function _mapExtend( o )
{
  let self = this;
  let used = false;

  _.routineOptions( _mapExtend, arguments );
  _.assert( o.dstPathMap === null || _.strIs( o.dstPathMap ) || _.arrayIs( o.dstPathMap ) || _.mapIs( o.dstPathMap ) );
  _.assert( !_.mapIs( o.dstPath ) );
  _.assert( _.longHas( [ 'replace', 'append', 'prepend' ], o.mode ) );

  // let removing = o.srcPathMap === '' || o.srcPathMap === null;
  // removing = false; /* off the feature */

  o.dstPath = dstPathNormalize( o.dstPath );
  o.srcPathMap = srcPathMapNormalize( o.srcPathMap );

  if( o.supplementing )
  {
    getDstPathFromSrcMap();
    getDstPathFromDstMap();
  }
  else
  {
    getDstPathFromDstMap();
    getDstPathFromSrcMap();
  }

  [ o.dstPathMap, used ] = dstPathMapNormalize( o.dstPathMap );

  // if( removing )
  // dstPathMapRemove( o.dstPathMap, o.dstPath );
  // else
  if( o.srcPathMap !== '' )
  used = dstPathMapExtend( o.dstPathMap, o.srcPathMap, o.dstPath ) || used;

  if( used && o.dstPathMap[ '' ] === o.dstPath )
  {
    delete o.dstPathMap[ '' ];
  }

  /* */

  return o.dstPathMap;

  /* */

  function dstPathNormalize( dstPath )
  {
    dstPath = self.simplify( dstPath );
    return dstPath;
  }

  /* */

  function srcPathMapNormalize( srcPathMap )
  {
    srcPathMap = self.simplify( srcPathMap );
    return srcPathMap;
  }

  /* */

  function getDstPathFromDstMap()
  {

    if( o.dstPath === null || o.dstPath === '' )
    if( _.mapIs( o.dstPathMap ) )
    if( o.dstPathMap[ '' ] !== undefined && o.dstPathMap[ '' ] !== null && o.dstPathMap[ '' ] !== '' )
    if( o.srcPathMap !== '' )
    if( o.dstPath !== o.dstPathMap[ '' ] )
    {
      o.dstPath = o.dstPathMap[ '' ];
      used = false;
    }

  }

  /* */

  function getDstPathFromSrcMap()
  {

    if( o.dstPath === null || o.dstPath === '' )
    if( _.mapIs( o.srcPathMap ) )
    if( o.srcPathMap[ '' ] !== undefined && o.srcPathMap[ '' ] !== null && o.srcPathMap[ '' ] !== '' )
    if( o.dstPath !== o.srcPathMap[ '' ] )
    {
      o.dstPath = o.srcPathMap[ '' ];
      used = false;
    }

  }

  /* */

  function dstPathMapNormalize( dstPathMap )
  {
    let used = false;

    if( dstPathMap === null )
    {
      dstPathMap = Object.create( null );
    }
    else if( _.strIs( dstPathMap ) )
    {
      let originalDstPath = dstPathMap;
      dstPathMap = Object.create( null );
      if( originalDstPath !== '' || ( o.dstPath !== null && o.dstPath !== '' ) )
      {
        dstPathMap[ originalDstPath ] = o.dstPath;
        if( originalDstPath !== '' )
        used = true;
      }
    }
    else if( _.arrayIs( dstPathMap ) )
    {
      let originalDstPath = dstPathMap;
      dstPathMap = Object.create( null );
      originalDstPath.forEach( ( p ) =>
      {
        dstPathMap[ p ] = o.dstPath;
        used = true;
      });
    }
    else if( _.mapIs( dstPathMap ) )
    {
      for( let f in dstPathMap )
      {
        let val = dstPathMap[ f ];
        // qqq : boolean should not override null neither ''
        //       check all cases
        // Dmytro : routine not override null and '' if it contains in dstMap
        if( ( val === null || val === '' ) && !_.boolLike( o.dstPath ) )
        {
          dstPathMap[ f ] = o.dstPath;
          used = true;
        }
        else
        if( _.boolLike( val ) )
        {
          dstPathMap[ f ] = !!val;
        }
      }

    }

    /* get dstPath from dstPathMap if it has empty key */

    if( dstPathMap[ '' ] === '' || dstPathMap[ '' ] === null )
    {
      delete dstPathMap[ '' ];
    }

    _.assert( _.mapIs( dstPathMap ) );
    return [ dstPathMap, used ];
  }

  /* */

  function dstPathMapRemove( dstPathMap, dstPath )
  {
    if( dstPath !== '' && _.mapKeys( dstPathMap ).length === 0 )
    {
      dstPathMap[ '' ] = dstPath;
    }
    else for( let src in dstPathMap )
    {
      dstPathMap[ src ] = dstPath;
      if( src === '' && dstPath === '' )
      delete dstPathMap[ '' ];
    }
  }

  /* */

  function dstPathMapExtend( dstPathMap, srcPathMap, dstPath, wasUsed )
  {
    let used = false;

    if( _.strIs( srcPathMap ) )
    {
      let dst;
      srcPathMap = self.normalize( srcPathMap );
      [ dst, used ] = dstJoin( dstPathMap[ srcPathMap ], dstPath, srcPathMap );
      if( srcPathMap !== '' || dst !== '' )
      dstPathMap[ srcPathMap ] = dst;
    }
    else if( _.mapIs( srcPathMap ) )
    {
      for( let g in srcPathMap )
      {
        let dstPath2 = srcPathMap[ g ];
        let tryingToUse = false;

        dstPath2 = dstPathNormalize( dstPath2 );

        if( ( dstPath2 === null ) || ( dstPath2 === '' ) )
        {
          dstPath2 = dstPath;
          tryingToUse = true;
        }

        if( tryingToUse )
        used = dstPathMapExtend( dstPathMap, g, dstPath2 ) || used;
        else
        dstPathMapExtend( dstPathMap, g, dstPath2 );
      }
    }
    else if( _.arrayLike( srcPathMap ) )
    {
      for( let g = 0 ; g < srcPathMap.length ; g++ )
      {
        let srcPathMap2 = srcPathMap[ g ];
        srcPathMap2 = srcPathMapNormalize( srcPathMap2 );
        used = dstPathMapExtend( dstPathMap, srcPathMap2, dstPath ) || used;
      }
    }
    else _.assert( 0, () => 'Expects srcPathMap, got ' + _.strType( srcPathMap ) );

    return used;
  }

  /* */

  function dstJoin( dst, src, key )
  {
    let used = false;
    let r;

    if( _.boolLike( src ) )
    src = !!src;

    _.assert( dst === undefined || dst === null || _.arrayIs( dst ) || _.strIs( dst ) || _.boolIs( dst ) || _.objectIs( dst ) );
    _.assert( src === null || _.arrayIs( src ) || _.strIs( src ) || _.boolIs( src ) || _.objectIs( src ) );

    if( o.mode === 'replace' )
    {
      if( o.supplementing )
      {
        r = dst;
        if( dst === undefined || dst === null || dst === '' )
        {
          r = src;
          if( key !== '' )
          used = true;
        }
      }
      else
      {
        if( key !== '' )
        used = true;
        r = src;
      }
    }
    else
    {
      r = dst;

      if( dst === undefined || dst === null || dst === '' )
      {
        r = src;
        if( key !== '' )
        used = true;
      }
      else if( src === null || src === '' || _.boolLike( src ) || _.boolLike( dst ) )
      {
        if( o.supplementing && ( src === null || src === '' || _.boolLike( src ) ) )
        {
          r = dst;
        }
        else
        {
          r = src;
          if( key !== '' )
          used = true;
        }
      }
      // {
      //   if( o.supplementing )
      //   {
      //     r = dst;
      //   }
      //   else
      //   {
      //     r = src;
      //     if( key !== '' )
      //     used = true;
      //   }
      // }
      else
      {
        if( key !== '' )
        used = true;
        if( o.mode === 'append' )
        r = _.scalarAppendOnce( dst, src );
        else
        r = _.scalarPrependOnce( dst, src );
      }

    }

    r = self.simplifyInplace( r );

    return [ r, used ];
  }

}

_mapExtend.defaults =
{
  dstPathMap : null,
  srcPathMap : null,
  dstPath : null,
  mode : 'replace',
  supplementing : 0,
}

/*

qqq : implement _.path.mapSupplement, _.path.mapAppend, _.path.mapPrepend
Dmytro : implemented and covered

test.case = 'dstMap=map with empty src, srcMap=null, dstPath=str';
var expected = { "" : "/dst" };
var dstMap = { "" : "/dst2" };
var srcMap = null;
var dstPath = '/dst2';
var got = path.mapExtend( dstMap, srcMap, dstPath );
test.identical( got, expected );
test.is( got === dstMap );

test.case = 'dstMap=map with empty src, srcMap=null, dstPath=str';
var expected = { "" : "/dst" };
var dstMap = { "" : "/dst" };
var srcMap = null;
var dstPath = '/dst2';
var got = path.mapSupplement( dstMap, srcMap, dstPath );
test.identical( got, expected );
test.is( got === dstMap );

test.case = 'dstMap=map with empty src, srcMap=null, dstPath=str';
var expected = { "" : [ "/dst", "/dst2" ] };
var dstMap = { "" : "/dst" };
var srcMap = null;
var dstPath = '/dst2';
var got = path.mapAppend( dstMap, srcMap, dstPath );
test.identical( got, expected );
test.is( got === dstMap );

test.case = 'dstMap=map with empty src, srcMap=null, dstPath=str';
var expected = { "" : [ "/dst2", "/dst" ] };
var dstMap = { "" : "/dst" };
var srcMap = null;
var dstPath = '/dst2';
var got = path.mapPrepend( dstMap, srcMap, dstPath );
test.identical( got, expected );
test.is( got === dstMap );

//

var dst = { '/dir' : '/file' }
var src = { '/dir' : false }
var got = _.path.mapAppend( dst, src )
var expected = { '/dir' : false }

var dst = { '/dir' : false }
var src = { '/dir' : '/file' }
var got = _.path.mapAppend( dst, src )
var expected = { '/dir' : '/file' }

var dst = { '/dir' : '/file' }
var src = { '/dir' : true }
var got = _.path.mapAppend( dst, src )
var expected = { '/dir' : '/file' }

var dst = { '/dir' : true }
var src = { '/dir' : '/file' }
var got = _.path.mapAppend( dst, src )
var expected = { '/dir' : '/file' }

*/

//

function mapExtend( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.assertInRange( arguments, [ 1, 4 ] );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'replace',
    supplementing : 0,
  });
}

//

/*
qqq : cover routine mapSupplement
Dmytro : covered. Test cases is identical to mapExtend.
*/

function mapSupplement( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.assertInRange( arguments, [ 1, 4 ] );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'replace',
    supplementing : 1,
  });
}

//

function mapAppend( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.assertInRange( arguments, [ 1, 4 ] );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'append',
    supplementing : 1,
  });
}

//

function mapPrepend( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'prepend',
    supplementing : 1,
  });
}

//

function mapsPair( dstFilePath, srcFilePath )
{
  let self = this;
  // let srcPath1;
  // let srcPath2;
  // let dstPath1;
  // let dstPath2;

  _.assert( srcFilePath !== undefined );
  _.assert( dstFilePath !== undefined );
  _.assert( arguments.length === 2 );

  if( srcFilePath && dstFilePath )
  {

    // srcPath1 = self.mapSrcFromSrc( srcFilePath );
    // srcPath2 = self.mapSrcFromDst( dstFilePath );
    // dstPath1 = self.mapDstFromSrc( srcFilePath );
    // dstPath2 = self.mapDstFromDst( dstFilePath );

    // srcPath1 = self.mapSrcFromSrc( srcFilePath ).filter( ( e ) => e !== null );
    // srcPath2 = self.mapSrcFromDst( dstFilePath ).filter( ( e ) => e !== null );
    // dstPath1 = self.mapDstFromSrc( srcFilePath ).filter( ( e ) => e !== null );
    // dstPath2 = self.mapDstFromDst( dstFilePath ).filter( ( e ) => e !== null );

    if( _.mapIs( srcFilePath ) && _.mapIs( dstFilePath ) )
    {
      mapsVerify();
    }
    else
    {
      srcVerify();
      // dstVerify();
    }

    if( _.mapIs( dstFilePath ) )
    {
      dstFilePath = self.mapExtend( null, dstFilePath, null );
      srcFilePath = dstFilePath = self.mapSupplement( dstFilePath, srcFilePath, null );
    }
    else
    {
      srcFilePath = dstFilePath = self.mapExtend( null, srcFilePath, dstFilePath );
    }

  }
  else if( srcFilePath )
  {
    if( self.isEmpty( srcFilePath ) )
    srcFilePath = dstFilePath = null;
    else
    srcFilePath = dstFilePath = self.mapExtend( null, srcFilePath, null );
  }
  else if( dstFilePath )
  {
    if( self.isEmpty( dstFilePath ) )
    srcFilePath = dstFilePath = null;
    else if( _.mapIs( dstFilePath ) )
    srcFilePath = dstFilePath = self.mapExtend( null, dstFilePath, null );
    else
    srcFilePath = dstFilePath = self.mapExtend( null, { '' : dstFilePath }, dstFilePath ); // yyy
  }
  else
  {
    srcFilePath = dstFilePath = null;
  }

  return srcFilePath;

  /* */

  function mapsVerify()
  {
    _.assert
    (
      _.mapsAreIdentical( srcFilePath, dstFilePath ),
      () => 'File maps are inconsistent\n' + _.toStr( srcFilePath ) + '\n' + _.toStr( dstFilePath )
    );
  }

  /* */

  function srcVerify()
  {
    if( dstFilePath && srcFilePath && Config.debug )
    {
      let srcPath1 = self.mapSrcFromSrc( srcFilePath ).filter( ( e ) => e !== null );
      let srcPath2 = self.mapSrcFromDst( dstFilePath ).filter( ( e ) => e !== null );
      let srcFilteredPath1 = srcPath1.filter( ( e ) => !_.boolLike( e ) && e !== null );
      let srcFilteredPath2 = srcPath2.filter( ( e ) => !_.boolLike( e ) && e !== null );
      _.assert
      (
        srcFilteredPath1.length === 0 || srcFilteredPath2.length === 0 ||
        self.isEmpty( srcFilteredPath1 ) || self.isEmpty( srcFilteredPath2 ) ||
        _.arraySetIdentical( srcFilteredPath1, srcFilteredPath2 ),
        () => 'Source paths are inconsistent ' + _.toStr( srcFilteredPath1 ) + ' ' + _.toStr( srcFilteredPath2 )
      );
    }
  }

  // /* */
  //
  // function dstVerify()
  // {
  //   if( dstFilePath && srcFilePath && Config.debug )
  //   {
  //     let dstFilteredPath1 = dstPath1.filter( ( e ) => !_.boolLike( e ) && e !== null );
  //     let dstFilteredPath2 = dstPath2.filter( ( e ) => !_.boolLike( e ) && e !== null );
  //     _.assert
  //     (
  //       dstFilteredPath1.length === 0 || dstFilteredPath2.length === 0 ||
  //       _.arraySetIdentical( dstFilteredPath1, [ '.' ] ) || _.arraySetIdentical( dstFilteredPath2, [ '.' ] ) || _.arraySetIdentical( dstFilteredPath1, dstFilteredPath2 ),
  //       () => 'Destination paths are inconsistent ' + _.toStr( dstFilteredPath1 ) + ' ' + _.toStr( dstFilteredPath2 )
  //     );
  //   }
  // }

}

//

/*
qqq : cover routine simplify
qqq : make sure routine simplify does not clone input data if possible to avoid it
Dmytro : covered. Routine create new container every time if src is array with duplicates,
         empty strings, nulls.
*/

function simplify( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( src === null )
  return '';

  if( _.strIs( src ) )
  return src;

  // qqq
  if( _.boolLike( src ) )
  return !!src;
  // qqq : was missing!

  if( _.arrayIs( src ) )
  {
    let src2 = _.arrayAppendArrayOnce( null, src );
    src2 = src2.filter( ( e ) => e !== null && e !== '' );
    if( src2.length !== src.length )
    src = src2;
    if( src.length === 0 )
    return '';
    else if( src.length === 1 )
    return src[ 0 ]
    else
    return src;
  }

  if( !_.mapIs( src ) )
  return src;

  for( let k in src )
  {
    src[ k ] = self.simplify( src[ k ] );
  }

  let keys = _.mapKeys( src );
  if( keys.length === 0 )
  return '';
  if( keys.length !== 1 && keys.includes( '' ) && src[ '' ] === '' )
  delete src[ '' ];

  let vals = _.mapVals( src );
  vals = vals.filter( ( e ) => e !== null && e !== '' );
  if( vals.length === 0 )
  {
    if( keys.length === 1 && keys[ 0 ] === '' )
    return '';
    else if( keys.length === 1 )
    return keys[ 0 ]
    else
    return src;
  }

  // for( let k in src )
  // {
  //   src[ k ] = self.simplify( src[ k ] );
  // }

  return src;
}

//

function simplifyDst( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( src === null )
  return '';

  if( _.strIs( src ) )
  return src;

  // qqq
  if( _.boolLike( src ) )
  return !!src;
  // qqq : was missing!

  if( _.arrayIs( src ) )
  {
    let src2 = _.arrayAppendArrayOnce( null, src );
    src2 = src2.filter( ( e ) => e !== null && e !== '' );
    if( src2.length !== src.length )
    src = src2;
    if( src.length === 0 )
    return '';
    else if( src.length === 1 )
    return src[ 0 ]
    else
    return src;
  }

  if( !_.mapIs( src ) )
  return src;

  for( let k in src )
  {
    src[ k ] = self.simplifyDst( src[ k ] );
  }

  let keys = _.mapKeys( src );
  if( keys.length === 0 )
  return '';

  if( keys.length === 1 && src[ '' ] !== undefined )
  src = src[ '' ];

  return src;
}

//

/*
qqq : cover routine simplifyInplace
qqq : make sure routine simplifyInplace never clone input data if possible to avoid it
Dmytro : covered, routine not create new container
*/

function simplifyInplace( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( src === null )
  return '';

  // qqq
  if( _.boolLike( src ) )
  return !!src;
  // qqq : was missing!

  if( _.strIs( src ) )
  return src;

  if( _.arrayIs( src ) )
  {
    src = _.arrayRemoveDuplicates( src, ( e ) => e );
    src = _.arrayRemoveElement( src, '', ( e ) => e === null || e === '' );
    return src;
  }

  if( !_.mapIs( src ) )
  return src;

  for( let k in src )
  {
    src[ k ] = self.simplifyInplace( src[ k ] );
  }

  return src;
}

//

function simplify_( dst, src )
{
  let self = this;
  let result;

  if( arguments.length === 1 )
  {
    src = dst;
    dst = true;
  }
  else
  _.assert( arguments.length === 2 );

  if( dst === null )
  dst = true;
  else if( dst === src )
  dst = false;

  if( src === null )
  result = '';

  else if( _.strIs( src ) )
  result = src;

  else if( _.boolLike( src ) )
  result = !!src;

  else if( _.arrayIs( src ) )
  {
    if( dst === false )
    {
      result = _.arrayRemoveDuplicates( src, ( e ) => e );
      result = _.arrayRemoveElement( result, '', ( e ) => e === null || e === '' );
      return result;
    }
    else
    {
      result = _.arrayAppendArrayOnce( null, src );
      result = result.filter( ( e ) => e !== null && e !== '' );
      if( result.length === 0 )
      result = '';
      else if( result.length === 1 )
      result = result[ 0 ];
    }
  }

  else if( _.mapIs( src ) )
  {
    if( dst !== false )
    {
      result = Object.create( null );

      for( let k in src )
      result[ k ] = self.simplify( src[ k ] );

      let keys = _.mapKeys( result );
      if( keys.length > 0 )
      {
        if( keys.length !== 1 && keys.includes( '' ) && result[ '' ] === '' )
        delete result[ '' ];

        let vals = _.mapVals( result );
        vals = vals.filter( ( e ) => e !== null && e !== '' );
        if( vals.length === 0 )
        {
          if( keys.length === 1 && keys[ 0 ] === '' )
          result = '';
          else if( keys.length === 1 )
          result = keys[ 0 ];
        }
      }
      else
      result = '';

    }
    else
    {
      for( let k in src )
      src[ k ] = self.simplify( src[ k ] );
      result = src;
    }
  }
  else
  result = src;

  fillDst();

  return result;

  /* */

  function fillDst()
  {
    if( !_.boolIs( dst ) )
    {
      if( _.arrayIs( dst ) )
      {
        if( _.arrayIs( result ) )
        _.arrayAppendArrayOnce( dst, result );
        else if( _.mapIs( result ) )
        _.arrayAppendArrayOnce( dst, _.mapKeys( result ) );
        else if( result !== '' )
        _.arrayAppendOnce( dst, result );
      }
      else if( _.mapIs( dst ) )
      {
        if( _.mapIs( result ) )
        {
          for( let k in result )
          dst[ k ] = result[ k ];
        }
        else if( _.arrayIs( result ) )
        {
          for( let i in result )
          dst[ result[ i ] ] = '';
        }
        else
        dst[ result ] = '';
      }
      else
      dst = result;

      result = self.simplify_( dst, dst );
    }
  }

}

//

/*
qqq : make pathMap*From* optimal and add tests
Dmytro : improved, added tests
*/

function mapDstFromSrc( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  {
    if( pathMap === null )
    return [];
    else
    return [ null ];
  }

  let result = [];

  for( let k in pathMap )
  {
    if( _.arrayIs( pathMap[ k ] ) )
    _.arrayAppendArrayOnce( result, pathMap[ k ] );
    else
    _.arrayAppendOnce( result, pathMap[ k ] );
  }

  return result;
}

// function mapDstFromSrc( pathMap )
// {
//   _.assert( arguments.length === 1 );
//
//   // if( _.strIs( pathMap ) )
//   // return [ null ];
//
//   // if( !_.mapIs( pathMap ) ) // yyy
//   // return [ null ];
//
//   if( !_.mapIs( pathMap ) )
//   if( pathMap === null )
//   return [];
//   else
//   return [ null ];
//
//   let result = _.mapVals( pathMap );
//
//   result = _.filter( result, ( e ) =>
//   {
//     if( _.arrayIs( e ) )
//     return _.unrollFrom( e );
//     return e;
//   });
//
//   result = _.arrayAppendArrayOnce( null, result );
//
//   return result;
// }

//

function mapDstFromDst( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  {
    if( pathMap === null )
    return [];
    else
    return _.arrayAsShallowing( pathMap );
  }

  let result = [];

  for( let k in pathMap )
  {
    if( _.arrayIs( pathMap[ k ] ) )
    _.arrayAppendArrayOnce( result, pathMap[ k ] );
    else
    _.arrayAppendOnce( result, pathMap[ k ] );
  }

  return result;
}

// function mapDstFromDst( pathMap )
// {
//   _.assert( arguments.length === 1 );
//
//   if( !_.mapIs( pathMap ) )
//   if( pathMap === null )
//   return [];
//   else
//   return _.arrayAsShallowing( pathMap );
//
//   let result = _.mapVals( pathMap );
//
//   result = _.filter( result, ( e ) =>
//   {
//     if( _.arrayIs( e ) )
//     return _.unrollFrom( e );
//     return e;
//   });
//
//   result = _.arrayAppendArrayOnce( null, result );
//
//   return result;
// }

//

function mapSrcFromSrc( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  {
    if( pathMap === null )
    return [];
    else
    return _.arrayAsShallowing( pathMap );
  }

  let result = [];

  for( let k in pathMap )
  if( k !== '' || ( pathMap[ k ] !== '' && pathMap[ k ] !== null ) )
  result.push( k );

  return result;
}

// function mapSrcFromSrc( pathMap )
// {
//   _.assert( arguments.length === 1 );
//
//   if( !_.mapIs( pathMap ) )
//   if( pathMap === null )
//   return [];
//   else
//   return _.arrayAsShallowing( pathMap );
//
//   // if( !_.mapIs( pathMap ) )
//   // return _.arrayAs( pathMap );
//
//   pathMap = this.mapExtend( null, pathMap );
//
//   return _.mapKeys( pathMap )
// }

//

function mapSrcFromDst( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  {
    if( pathMap === null )
    return [];
    else
    return [ null ];
  }

  let result = [];

  for( let k in pathMap )
  result.push( k );

  return result;
}

// function mapSrcFromDst( pathMap )
// {
//   _.assert( arguments.length === 1 );
//
//   if( !_.mapIs( pathMap ) )
//   {
//     if( pathMap === null )
//     return [];
//     else
//     return [ null ];
//   }
//
//   return _.mapKeys( pathMap );
// }

// --
// etc
// --

// function areBasePathsEquivalent( basePath1, basePath2 )
// {
//   let path = this;
//
//   let filePath1 = path.mapSrcFromDst( basePath1 );
//   let filePath2 = path.mapSrcFromDst( basePath2 );
//
//   basePath1 = path.mapDstFromDst( basePath1 );
//   basePath2 = path.mapDstFromDst( basePath2 );
//
//   // if( filePath1.length > 0 && filePath2.length > 0 )
//   // if( !_.entityIdentical( basePath1, basePath2 ) )
//   // return false;
//
//   if( !_.entityIdentical( basePath1, basePath2 ) )
//   return false;
//
//   return true;
// }

//

function traceToRoot( filePath )
{
  let self = this;
  let result = [];

  _.assert( arguments.length === 1 );

  // filePath = self.detrail( filePath ); // Dmytro : cycled loop if path is absolute and has form '/..'
  filePath = self.canonize( filePath );

  if( self.isAbsolute( filePath ) )
  {
    while( filePath !== self._rootStr )
    {
      result.unshift( filePath );
      filePath = self.detrail( self.dir( filePath ) );
    }
  }
  else
  {
    filePath = self.undot( filePath );
    if( !self.isDotted( filePath ) )
    do
    {
      result.unshift( filePath );
      filePath = self.detrail( self.dir( filePath ) );
    }
    while( !self.isDotted( filePath ) );
  }

  return result;
}

//

function group( o )
{
  let self = this;

  _.routineOptions( group, arguments );
  _.assert( _.arrayIs( o.vals ) );
  _.assert( o.result === null || _.mapIs( o.result ) );

  o.result = o.result || Object.create( null );
  o.result[ '/' ] = o.result[ '/' ] || [];

  let vals = _.arrayFlattenOnce( null, o.vals );
  let keys = o.keys;

  keys = self.s.from( keys );
  vals = self.s.from( vals );

  keys = self.mapSrcFromSrc( keys );

  _.assert( _.arrayIs( keys ) );
  _.assert( _.arrayIs( vals ) );

  // if( o.vals && o.vals.length )
  // debugger;

  /* */

  for( let k = 0 ; k < keys.length ; k++ )
  {
    let key = keys[ k ];
    let res = o.result[ key ] = o.result[ key ] || [];
  }

  /* */

  for( let key in o.result )
  {
    let res = o.result[ key ];
    for( let v = 0 ; v < vals.length ; v++ )
    {
      let val = vals[ v ];
      if( self.begins( val, key ) )
      _.sorted.addOnce( res, val, ( a, b ) =>
      {
        a = a.toLowerCase();
        b = b.toLowerCase();
        if( a === b )
        return 0;
        if( a < b )
        return -1;
        return +1;
      });
      // _.arrayAppendOnce( res, val );
    }

  }

  /* */

  // if( o.vals && o.vals.length )
  // debugger;

  return o.result;
}

group.defaults =
{
  keys : null,
  vals : null,
  result : null,
}

//

function mapGroupByDst( pathMap )
{
  let path = this;
  let result = Object.create( null );

  _.assert( arguments.length == 1 );
  _.assert( _.mapIs( pathMap ) );

  /* */

  for( let src in pathMap )
  {
    let normalizedSrc = path.fromGlob( src );
    let dst = pathMap[ src ];

    if( _.boolLike( dst ) )
    continue;

    if( _.strIs( dst ) )
    {
      extend( dst, src );
    }
    else
    {
      _.assert( _.arrayIs( dst ) );
      for( var d = 0 ; d < dst.length ; d++ )
      extend( dst[ d ], src );
    }

  }

  /* */

  for( let src in pathMap )
  {
    let dst = pathMap[ src ];

    if( !_.boolLike( dst ) )
    continue;

    for( var dst2 in result )
    {

      for( var src2 in result[ dst2 ]  )
      {
        if( path.isRelative( src ) ^ path.isRelative( src2 ) )
        {
          result[ dst2 ][ src ] = !!dst;
        }
        else
        {
          let srcBase = path.fromGlob( src );
          let srcBase2 = path.fromGlob( src2 );
          if( path.begins( srcBase, srcBase2 ) || path.begins( srcBase2, srcBase ) )
          result[ dst2 ][ src ] = !!dst;
        }
      }

    }

  }

  /* */

  return result;

  /* */

  function extend( dst, src )
  {
    dst = path.normalize( dst );
    result[ dst ] = result[ dst ] || Object.create( null );
    result[ dst ][ src ] = '';
  }

}

//

function setOptimize( filePath )
{
  let self = this;
  let topToBottom = Object.create( null );
  let bottomToTops = Object.create( null );

  if( !_.mapIs( filePath ) )
  filePath = self.mapExtend( null, filePath );

  for( let src in filePath )
  {
    let dst = filePath[ src ];
    if( _.boolLike( dst ) )
    continue;

    debugger;
    if( topToBottom[ src ] && _.strBegins( topToBottom[ src ], src ) )
    {
      revisit( src );
    }
    else
    {
      let topPaths = self.traceToRoot( src );
      if( !isVisited( topPaths, src ) )
      visit( topPaths, src );
    }

  }

  let result = Object.keys( bottomToTops );
  result.sort();
  return result;

  /* */

  function isVisited( topPaths, src )
  {
    for( let d = 0 ; d < topPaths.length ; d++ )
    {
      if( topToBottom[ topPaths[ d ] ] )
      return true;
    }
    return false;
  }

  /* */

  function visit( topPaths, src )
  {
    _.assert( bottomToTops[ src ] === undefined );
    bottomToTops[ src ] = topPaths;
    for( let d = 0 ; d < topPaths.length ; d++ )
    {
      let dir = topPaths[ d ];
      topToBottom[ dir ] = src;
    }
  }

  /* */

  function revisit( src )
  {
    let topPaths = bottomToTops[ topToBottom[ src ] ];
    delete bottomToTops[ topToBottom[ src ] ];
    bottomToTops[ src ] = topPaths
    debugger;
    for( let d = 0 ; d < topPaths.length ; d++ )
    {
      let dir = topPaths[ d ]
      topToBottom[ dir ] = src;
    }
  }

}

//

function mapOptimize( filePath, basePath )
{
  let self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( basePath === undefined || _.mapIs( basePath ) );
  _.assert( self.isElement( filePath ) );

  if( !_.mapIs( filePath ) )
  filePath = self.mapExtend( null, filePath );

  let arrayPath = [];

  for( let src in filePath )
  {
    let dst = filePath[ src ];
    if( !_.boolLike( dst ) )
    arrayPath.push( src );
  }

  arrayPath.sort();

  for( let i1 = 0 ; i1 < arrayPath.length ; i1++ )
  {
    let path1 = arrayPath[ i1 ];
    for( let i2 = i1+1 ; i2 < arrayPath.length ; i2++ )
    {
      let path2 = arrayPath[ i2 ];

      if( !self.begins( path2, path1 ) )
      break;

      if( filePath[ path1 ] !== filePath[ path2 ] )
      continue;

      if( basePath )
      {
        if( basePath[ path1 ] !== basePath[ path2 ] )
        continue;
        else
        delete basePath[ path2 ];
      }

      arrayPath.splice( i2, 1 );
      delete filePath[ path2 ];
      i2 -= 1;
    }
  }

  return filePath;
}

// --
// fields
// --

let Fields =
{
}

// --
// routines
// --

let Routines =
{

  // path map

  filterPairs,

  _filterPairsInplace,
  filterPairsInplace,
  filterSrcPairsInplace,
  filterDstPairsInplace,

  filterInplace,
  filter,
  filter_,
  all,
  any,
  none,

  isEmpty,
  _mapExtend,
  mapExtend,
  mapSupplement,
  mapAppend,
  mapPrepend,
  mapsPair,

  simplify,
  simplifyDst, /* qqq : cover simplifyDst | Dmytro : covered */
  simplifyInplace,
  simplify_,

  mapDstFromSrc,
  mapDstFromDst,
  mapSrcFromSrc,
  mapSrcFromDst,

  // etc

  // areBasePathsEquivalent,
  traceToRoot, /* qqq : add basic test coverage | Dmytro : basic test coverage added */
  group,
  mapGroupByDst,
  setOptimize, /* xxx : deprecate maybe? */
  mapOptimize, /* qqq : cover please | Dmytro : coverage is extended */

}

_.mapSupplement( Self, Fields );
_.mapSupplement( Self, Routines );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

if( typeof module !== 'undefined' )
{
  require( './Glob.s' );
}

})();
