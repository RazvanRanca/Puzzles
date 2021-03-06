Two sample programs implemented on the MIPS reduced instruction set
===
See: http://en.wikipedia.org/wiki/MIPS_architecture

reverse.s: reverses a string of length up to 40. 
---

The algorithm is equivalent to roughly the following pseudo-code:
```
String input;
Stack st;

read input;
int i=0;
char c= input.charAt(i);

while(c != '/n') {
  st.push(c);
  i++;
  c = input.charAt(i);
}
while(!st.isEmpty())
  print (st.pop());
print '/n';
```

**Things worth mentioning:**
- Through the use of registers I make sure that the addresses for the allocated space for input string and stack are read
only once
- I only use the saved registers ($s0-$s4 specifically), thus there is no need to save anything to the stack before the
syscall function calls


brackets.s: Reads an input string, checks that it is properly bracketed and returns a suitable output message. Accepts (, ), [ and ] as valid brackets
---

The algorithm is equivalent to roughly the following pseudo-code:
```
String input;
Stack st;
boolean success = true;

read input;
int pos = 0;
char c= input.charAt(pos);

while(c != '/n') {
  if( c == '(' || c == '[' )
    st.push(c);
  else {
    if( c == ')' || c == ']' ) {
      if(st.isEmpty()) {
        printf("At : %d unexpected close bracket\n", pos);
        success = false;
      } else {
        char p = st.pop();
        if(( c == ')' && p != '(' ) || ( c == ']' && p != '[' )) {
          printf("At : %d mismatching close bracket\n", pos);
          success = false;
        } 
    }
  }
  pos++;
  c = input.charAt(pos);
}
if(!st.isEmpty()) {
  printf("At : %d unclosed open bracket(s)\n", pos);
  success = false;
}
if(success)
  printf("At : %d all brackets matched\n", pos);
```

**Register usage in the main function:**
* $s0 -holds the newline character, used to determine when we have finished reading the input
* $s1 - the stack pointer
* $s2 - the address where the stack begins, used to determine when the stack is empty
* $s3 - the address of the current character we are considering
* $s4 - the value of the current character
* $s5 - the position of the current character in the input string
* $s6 - a flag which becomes zero if we find an error, used to determine whether to print the success message

All of the above are saved registers because they are used in the "checkCharacters" loop, and at any point in this loop it
is possible for the print function to be called, therefore we cannot rely on temporary registers during this loop

* $a0, $a1 - used as parameters for both the print function and the syscall
* $t0, $t1, $t2 - used to store the values of different parentheses, for comparation with other registers.
Here i had to made a compromise, i didn't have enough saved registers to store the 4 possible parentheses, so in order to
respect the coding guidelines, i load these values on every loop, just before i need them. This way i know the function
calls cannot interfere with their values during my computations.

**Register usage in the print function:**

Here i send the two parameters as $a0(the message) and $a1(the position of the current character).
I could have just gotten the position directly from $s5(make it act as a global), but this seems to be against the coding
guidelines, so i pass the value in $a1 instead.

Since i need to use $a0 in the syscall, i need to store it's value somewhere, but syscall itself is a function call, therefore i
can't rely on a temporary register being the same before and after the call. So i have to store the value of a saved register
on the stack, use that saved register to hold $a0 and, after i print the message, restore the initial value of the saved
register from the stack.
