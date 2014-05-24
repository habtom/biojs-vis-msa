biojs-core
==========

Sandbox for the BioJS MSA Viewer with AMD and CoffeeScript

### Step 1) Embedding components

Have a look at the [quick start examples](#).

```
<script src="biojs.js"></script>
<link type="text/css" rel="stylesheet" href="css/msa.css" />
```

This library is [AMD-compatible](#), so you can also embedd it with an AMD loader of your choice.

The whole API is coming soon.

### Step 2) Developing 

[`development.html`](https://cdn.rawgit.com/greenify/biojs-msa-amd/master/development.html)

* all javascript modules are loaded on demand
* CoffeeScript is compiled by the Browser


### Step 3) Compiling


### a) build a single JS file

* all sources are bundled to one JS file (`build/biojs.js`)
* CoffeeScript is compiled by R.js

You need either Java or node to compile the project.

with node:
```
node js/libs/r.js -o build.js
```

with Java:
```
java -classpath jars/rhino.jar:jars/compiler.jar org.mozilla.javascript.tools.shell.Main js/libs/r.js -o build.js
```

### 3.b) Compile the documentation

Currently two versions of the documentation are generated.

1) [`production.html`](#)
      * users has an AMD loader (RequireJS). BioJS is loaded as a AMD dependency.
2) [`production-non-amd.html`](#)
      * users has no AMD loader. BioJS automatically uses almond and registers as global variable

Click the links for an interactive demo for a possible production code.


```
python3 build.py
```

You might need to run
```
pip3 install lxml 
```

### Used libraries

* [coffeescript](https://github.com/jashkenas/coffee-script)
* [require.js](https://github.com/jrburke/requirejs)
* [require-cs](https://raw.githubusercontent.com/jrburke/require-cs/latest/cs.js)
* [r.js](https://github.com/jrburke/r.js/)
* [almond](https://github.com/jrburke/almond)

### Used libraries for the documentation

* [jQuery](https://jquery.com/)
* [highlight.js](http://highlightjs.org/)
* [Bootstrap](http://getbootstrap.com)