/**
 * Renders TestResult from TestBox in Codewars format.
 * Based on `CLIRenderer@testbox-commands`.
 */
component {

	/**
	 * @print a print buffer to use
	 * @testData test results from TestBox
	 */
	function render( print, testData ){
		for ( thisBundle in testData.bundleStats ) {
			// Check if the bundle threw a global exception
			if ( !isSimpleValue( thisBundle.globalException ) ) {
				var message = escapeLF(
					"#thisBundle.globalException.type#:#thisBundle.globalException.message#:#thisBundle.globalException.detail#"
				);
				print.line( prependLF( "<ERROR::>#message#" ) );

				// ACF has an array for the stack trace
				if ( isSimpleValue( thisBundle.globalException.stacktrace ) ) {
					print.line( prependLF( "<LOG::-Stacktrace>#escapeLF( thisBundle.globalException.stacktrace )#" ) );
				}
			}

			var debugMap = prepareDebugBuffer( thisBundle.debugBuffer );

			// Generate reports for each suite
			for ( var suiteStats in thisBundle.suiteStats ) {
				genSuiteReport( suiteStats = suiteStats, bundleStats = thisBundle, print = print, debugMap = debugMap );
			}
		}
	}

	/**
	 * Recursive Output for suites
	 * @suiteStats Suite stats
	 * @bundleStats Bundle stats
	 * @print The print Buffer
	 */
	function genSuiteReport( required suiteStats, required bundleStats, required print, debugMap={}, labelPrefix='' ){
		labelPrefix &= '/' & arguments.suiteStats.name;
		print.line( prependLF( "<DESCRIBE::>#arguments.suiteStats.name#" ) );

		for ( local.thisSpec in arguments.suiteStats.specStats ) {
			var thisSpecLabel = labelPrefix & '/' & local.thisSpec.name;
			print.line( prependLF( "<IT::>#local.thisSpec.name#" ) );

			if( debugMap.keyExists( thisSpecLabel ) ) {
				print.line( debugMap[ thisSpecLabel ] )
			}

			if ( local.thisSpec.status == "passed" ) {
				print.line( prependLF( "<PASSED::>Test Passed" ) );
			} else if ( local.thisSpec.status == "failed" ) {
				print.line( prependLF( "<FAILED::>#escapeLF( local.thisSpec.failMessage )#" ) );
			} else if ( local.thisSpec.status == "skipped" ) {
				print.line( prependLF( "<LOG::>Skipped" ) );
				print.line( prependLF( "<ERROR::>Test skipped" ) );
			} else if ( local.thisSpec.status == "error" ) {
				print.line( prependLF( "<ERROR::>#escapeLF( local.thisSpec.error.message )#" ) );

				var errorStack = [];
				// If there's a tag context, show the file name and line number where the error occurred
				if (
					isDefined( "local.thisSpec.error.tagContext" ) && isArray( local.thisSpec.error.tagContext ) && local.thisSpec.error.tagContext.len()
				) {
					errorStack = thisSpec.error.tagContext;
				} else if (
					isDefined( "local.thisSpec.failOrigin" ) && isArray( local.thisSpec.failOrigin ) && local.thisSpec.failOrigin.len()
				) {
					errorStack = thisSpec.failOrigin;
				}

				if ( errorStack.len() ) {
					var stacktrace = errorStack
						.slice( 1, 5 )
						.map( function( item ){
							return "at #item.template#:#item.line#";
						} )
						.toList( "<:LF:>" );
					print.line( prependLF( "<LOG::-Stacktrace>#stacktrace#" ) );
				}
			} else {
				print.line( prependLF( "<ERROR::>Unknown test status: #local.thisSpec.status#" ) );
			}

			print.line( prependLF( "<COMPLETEDIN::>#local.thisSpec.totalDuration#" ) );
		}

		// Handle nested Suites
		if ( arguments.suiteStats.suiteStats.len() ) {
			for ( local.nestedSuite in arguments.suiteStats.suiteStats ) {
				genSuiteReport( local.nestedSuite, arguments.bundleStats, print, debugMap, labelPrefix )
			}
		}

		print.line( prependLF( "<COMPLETEDIN::>#arguments.suiteStats.totalDuration#" ) );
	}

	private function escapeLF( required text ){
		return replace( text, chr( 10 ), "<:LF:>", "all" );
	}

	private function prependLF( required text ){
		return "#chr( 10 )##text#";
	}

	// Transofrm array of messages to struct keyed on message label containing an array of 
	private function prepareDebugBuffer( array debugBuffer ) {
		return debugBuffer.reduce( ( debugMap={}, d )=> {
			debugMap[ d.label ] = debugMap[ d.label ] ?: '';
			debugMap[ d.label ] &= prependLF( isSimpleValue( d.data ) ? d.data : serialize( d.data ) );
			return debugMap;
		} ) ?: {};

	}

}
