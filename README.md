## testbox-codewars

- `CodewarsReporter.cfc`: Custom reporter for TestBox to produce Codewars format
- `TestRunner.cfm`: Runs TestBox tests and produces output for Codewars
- `CodewarsBaseSpec.cfc`: Base tests for CFML test bundles that captures spec-level debugging output

### Usage

Assumes you have CommandBox CLI installed and in your path:

https://commandbox.ortusbooks.com/setup/installation

Make sure TestBox is installed:

```bash
box install
```

To test locally, create a `Solution.cfc` and `SolutionTest.cfc` in the root dir.  

Run the task runner with the following command:

```bash
box -clishellpath=/path/to/TestRunner.cfm
```
