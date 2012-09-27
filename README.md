# Sassdoc

Documentation generator for Sass source code

## Using Sassdoc

### Install the gem

sh
[sudo] gem install sassdoc


### Use the CLI to parse source docs

sh
sassdoc ~/workspace/project


#### Options

sh
Usage: sassdoc [path] [options]
    -v, --[no-]viewer                generate the viewer
    -s, --[no-]stdout                write json output to stdout
    -d, --destination PATH           path to write generated docs to
    -c, --scm URL                    URL to source control management viewer
    -n, --name DOC_NAME              the name of the project documentation


## Examples

### Some simple examples

scss
// this is an example mixin
// @mixin     example-mixin
// @param     $first {String} the first parameter is a string
// @param     $second {Number} the second parameter is a number
// @param     $third {List} this one is a list!
// @usage:
// =example-mixin(first, 2, (3))
@mixin example-mixin($first, $second, $third) {
  // ...
}


scss
// this is an example function
// @function  example-function
// @param     $type {String} the type of example [easy|hard]
// @return    {Number} the index of the type
@function example-function($type) {
  @return index(easy hard, $type);
}


### Defining private methods

scss
// this is a private function
// @function  -private-function
// @private
// @param     $color {Color} a color!
// @return    {Boolean} true of it succeed, false if it failed
@function -private-function($type) {
  //
}


### Specifying a category

By default, Sassdoc will determine the category by the file path. You can define your own organization structure using the @category keyword.

This keyword can be used to set the scope of the entire file, or a single method.

#### Global category

In this example, both function-one and function-two will be scoped to the utilities label

scss
// @category  utilities

// first function
// @function  function-one
// @param     $first {Color} a color
// @return    {Boolean} true of it succeed, false if it failed
@function function-one($first) {
  //
}

// second function
// @function  function-two
// @param     $first {Color} a color
// @return    {Boolean} true of it succeed, false if it failed
@function function-two($first) {
  //
}


#### Individual category

In this example, function-one will be labeled as utilities (from the Global scope), while function-two will be categorized as utilities/hacks

scss
// @category  utilities

// first function
// @function  function-one
// @param     $first {Color} a color
// @return    {Boolean} true of it succeed, false if it failed
@function function-two($first) {
  //
}

// second function
// @function  function-two
// @category  utilities/hacks
// @param     $first {Color} a color
// @return    {Boolean} true of it succeed, false if it failed
@function function-two($first) {
  //
}


## Supported Keywords

<table>
  <tr>
    <th>key</th>
    <th>meaning</th>
  </tr>
  <tr>
    <td>@mixin</td>
    <td>define a mixin</td>
  </tr>
  <tr>
    <td>@function</td>
    <td>define a function</td>
  </tr>
  <tr>
    <td>@param</td>
    <td>a parameter for a method</td>
  </tr>
  <tr>
    <td>@return</td>
    <td>what is returned in the method</td>
  </tr>
  <tr>
    <td>@private</td>
    <td>flag a method as private</td>
  </tr>
  <tr>
    <td>@usage</td>
    <td>provide a block of example usage</td>
  </tr>
  <tr>
    <td>@category</td>
    <td>define a category for the method</td>
  </tr>
  <tr>
    <td>@link</td>
    <td>link off to a URL (limited support)</td>
  </tr>
  <tr>
    <td>@see</td>
    <td>reference another method (limited support)</td>
  </tr>
</table>