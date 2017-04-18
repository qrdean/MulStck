generic
   numStacks : integer; --the number of total stacks used in the multistack
   L0 : integer; --the minimum value of the multistack
   max : integer; --the maximum number of values in the stack
   SSmin : integer; --the minimum value of the array the the multistack is located in
   SSmax : integer; --the maximum value of the array that the multistack is located in
   type item is private;

package multistack is

   procedure push(x: in item; stackNum: in integer; overflow: in out boolean);
   procedure pop(x: out item; stackNum: in integer; underflow: in out boolean);
   procedure reallocate(x: in item; stackNum: in integer; overflow: in out boolean);
   procedure moveStack;
   procedure printContents(printOT : in Boolean);
   function floor(x: in float) return integer;
end;
