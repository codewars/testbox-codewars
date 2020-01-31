/**
 * Runs TestBox test and outputs in Codewars format.
 * To use, run:
 *     box task run TestRunner
 */
component {

	function run(){
		// Bootstrap TestBox framework
		filesystemUtil.createMapping( "/testbox", resolvepath( "testbox" ) );

		// Create TestBox and run the tests
		testData = new testbox.system.TestBox( options={ coverage : { enabled : false } } )
			.runRaw(
				directory = {
					// Find all CFCs in this directory that ends with Test.
					mapping : filesystemUtil.makePathRelative( getCWD() ),
					recurse : false,
					filter = function( path ){
						return path.reFindNoCase( "Test\.cfc$" );
					}
				}
			)
			.getMemento( includeDebugBuffer=true );

		new CodewarsReporter().render( print, testData );

		// Flush the buffer
		print.toConsole();

		// Set exit code to 1 on failure
		if ( testData.totalFail || testData.totalError ) {
			return 1;
		}
	}

}
