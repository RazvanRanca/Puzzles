This contains a Brainfuck interpreter written in "miniJS", thus proving that miniJS is Turing complete.
----

**Brainfuck** (http://en.wikipedia.org/wiki/Brainfuck) is a Turing complete, esoteric, programming language consisting of eight commands.

**miniJs** is an ultra-minimalistic subset of JavaScript. Specifically it contains strings, ints, basic arithmetic and equality operators, if and while statements and input reading.

**sort.not** To give you an idea of the puzzle-like nature of using miniJS, a basic sorting algorithm is implemented here.

**interpreter.not** The interpreter, takes the Brainfuck code and arguments and returns the appropriate result  

*runInterpreter.sh* is a wrapper script for the interpreter which just takes the Brainfuck program as a parameter.
The script gets rid of comments and whitespace, separates the code from the arguments( arguments should be separated by '!' ), runs the interpreter and then converts the interpreter output from ascii decimal to characters.

*tests*
A bunch of BF programs used as tests. These were found on the web and are not written by me.
Arguments to the program can be added at the end of the code and should be separated by '!' (eg: The file ',.,.!65!66' would print out AB)

* tests/hello.bf => prints 'Hello World!'
* tests/jabh.bf => prints 'Just another brainfuck hacker.'
* tests/fib.bf => prints first N fibonnaci numbers. N can be given as a parameter in the file (currently 10). --- Note that values over 255 will overflow because every cell in BF is a byte.
* tests/squares.bf => prints first N perfect squares. N can be given as a parameter in the file (currently 20). --- This is implemented better, no overflow but gets quite slow for larger values.
* tests/quine.bf => Brainfuck quine! outputs an exact copy of its source code --- Note this takes a couple minutes on my machine.

