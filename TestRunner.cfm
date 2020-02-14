<cfsilent>
<!---
 Runs TestBox test and outputs in Codewars format.
 To use, run:
     box -clishellpath=/path/to/TestRunner.cfm
 --->
<cfscript>
	// Bootstrap TestBox framework
	currentDir = getDirectoryFrompath( getCurrentTemplatePath());
	createMapping( '/testbox', currentDir & 'testbox' );
	createMapping( '/codewarsRoot', currentDir );

	// Create TestBox and run the tests
	testData = new testbox.system.TestBox( options={ coverage : { enabled : false } } )
		.runRaw(
			directory = {
				// Find all CFCs in this directory that ends with Test.
				mapping : '/codewarsRoot',
				recurse : false,
				filter = function( path ){
					return path.reFindNoCase( "Test\.cfc$" );
				}
			}
		)
		.getMemento( includeDebugBuffer=true );

	new CodewarsReporter().render( testData );

	// Set exit code to 1 on failure
	if ( testData.totalFail || testData.totalError ) {
		return 1;
	}


    function createMapping( mappingName, mappingPath ) {
    	var mappings = getApplicationSettings().mappings;
    	if( !structKeyExists( mappings, mappingName ) || mappings[ mappingName ] != mappingPath ) {
    		mappings[ mappingName ] = mappingPath;
    		application action='update' mappings='#mappings#';
   		}
    }


</cfscript></cfsilent>