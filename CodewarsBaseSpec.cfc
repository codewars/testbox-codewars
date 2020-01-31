component extends="testbox.system.BaseSpec" {
     /**
     * @aroundEach
     */
	 function captureOutput( spec, suite ){
		savecontent variable="local.out" {
    		arguments.spec.body();
		}
		if( len( trim( local.out ) ) ) {
			debug( local.out )
		}
 	 }
      
}