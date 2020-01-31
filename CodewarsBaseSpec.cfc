component extends="testbox.system.BaseSpec" {
     /**
     * @aroundEach
     */
	 function captureOutput( spec, suite ){
         var out = '';
            savecontent variable="local.out" {
                try{
                    arguments.spec.body();
                } catch( any e ) {
                    var thisFailure = e;
                }
            }
            // make sure we debug any output, even on failure
            if( len( trim( local.out ) ) ) {
                debug( local.out )
            }
            if( !isNull( thisFailure ) ) {
                throw( thisFailure );
            }
 	 }

}