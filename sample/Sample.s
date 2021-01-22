
if( typeof module !== 'undefined' )
require( 'wpathtools' );
let _ = wTools;

var dst = '/dst'
var src = '/src'
var pathMap = _.path.mapExtend( null, dst, src );
console.log( 'Path map:\n', pathMap );
/*
Path map:
/src : /dst
*/
