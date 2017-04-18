with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package body multistack is

   --declare the four arrays needed
   s : array(SSmin .. SSmax) of item;
   base : array(1 .. (numstacks + 1)) of integer;
   top : array(1 .. numstacks) of integer;
   --oldTop is used to store the oldTop, growth, and newBase in order to save space
   oldTop : array(1 .. (numStacks + 1)) of Integer;

   availSpace, totalInc, initialStackSize, J, DeltaX : integer;
   growthAllocate, Alpha, Beta, Tau, Sigma : float;
   equalAllocate : float := 0.07;
   minSpace : float := float(max-L0) * 0.1;

   procedure push(x: in item; stackNum: in integer; overflow: in out boolean) is
   begin
      --increment the top of the stack
      top(stackNum) := top(stackNum) + 1;
      --reallocate?
      if top(stackNum) > base(stackNum + 1) then
         put_line("Reallocation commencing...");
         printContents(true); --true means to print oldTop
         reallocate(x, stackNum, overflow);
         printContents(false);--do not print oldTop
      else --we are succeful add it to the stack
         put("Succesful push on to stack "); put(stackNum, 0); new_line;
         s(top(stackNum)) := x;
      end if;
   end push;

   procedure pop(x: out item; stackNum: in integer; underflow: in out boolean) is
   begin
      --check for underflow
      if top(stackNum) = base(stackNum) then
         underflow := true;
         return;
      else --pop the top of the stack
         X := S(Top(StackNum));
         Put("Pop off stack: "); Put(StackNum,0);
         top(stackNum) := top(stackNum) - 1;
      end if;
   end pop;

   procedure reallocate(x: in item; stackNum: in integer; overflow: in out boolean) is
   begin
      --ReA1
      --find the amount of space available for reallocation
      AvailSpace := max - L0;
      TotalInc := 0;
      J := numStacks;

      while j > 0 loop
         availSpace := availSpace - (Top(j) - Base(J));
         if top(j) > oldTop(j) then
            oldTop(j+1) := top(j) - oldTop(j); --Growth(j) = oldTop(j+1)
            totalInc := totalInc + oldTop(j+1);
         else
            oldTop(j+1) := 0;
         end if;

         J := J - 1;
      end loop;

      --test if we have enough memory for repacking
      if float(AvailSpace) < (minSpace - 1.0) then
         put_line("Insufficient memory for repacking!");
         --decrement the top of the stack since it was increased before the call
         top(stackNum) := top(stackNum) - 1;
         overflow := true;
         return; --return with an error and no changes
      end if;

      --set GrowthAllocate and Alpha
      GrowthAllocate := 1.0 - EqualAllocate;
      Alpha := EqualAllocate * float(AvailSpace) / float(numStacks);

      --set beta
      Beta := GrowthAllocate * float(AvailSpace) / float(totalInc);

      --set the newBase (represented as oldTop) of each stack
      oldTop(1) := Base(1);
      Sigma := 0.0;
      For J in integer range 2 .. numStacks loop
         Tau := Sigma + Alpha + float(oldTop(J)) * Beta;
         oldTop(j) := oldTop(j-1) + (top(j-1) - base(j-1) + floor(Tau) - floor(Sigma));
         Sigma := Tau;
      end Loop;

      --move each stack
      top(stackNum) := top(stackNum) - 1;
      moveStack;
      top(stackNum) := top(stackNum) + 1;

      --put the data in the stack
      s(top(StackNum)) := x;

      --change oldTop to the new top for future calls to reallocate
      for J in integer range 1..numStacks loop
         oldTop(j) := top(j);
      end loop;
   end reallocate;

   procedure moveStack is
   begin
      --move all stacks down
      for J in integer range 2 .. numStacks loop
         if oldTop(j) < base(j) then
            DeltaX := base(j) - oldTop(j);
            for L in integer range (base(j)+1) .. top(j) loop
               s(L - DeltaX) := s(L);
            end loop;
            base(j) := oldTop(j);
            top(j) := top(j) - DeltaX;
         end if;
      end loop;

      --move all stacks up
      for J in reverse 2 .. numStacks loop
         if oldTop(j) > base(j) then
            DeltaX := oldTop(j) - base(j);
            for L in reverse (base(j) + 1) .. Top(j) loop
               s(L + DeltaX) := s(L);
            end loop;
            base(j) := oldTop(j);
            top(j) := top(j) + DeltaX;
         end if;
      end loop;

   end moveStack;

   PROCEDURE PrintContents(PrintOT : Boolean) IS

   begin
      if printOT = true then
         put("**Before repacking:");
      else
         put("**After repacking:");
      end if;

      new_line;
      for j in 1 .. numStacks loop
         put("Base["); put(j, 0); put("]   = "); put(base(j), 0); new_line;
         put("Top["); put(j, 0); put("]    = "); put(top(j), 0); new_line;

         if printOT = true then
            put("OldTop["); put(j, 0); put("] = "); put(oldTop(j), 0); new_line;
         END IF;
      end loop;
   end printContents;

   --truncates the float
   function floor(x : float) return integer is
      ret : integer;
   begin
      ret := integer(x);
      if float(ret) <= x then
         return ret;
      else
         return ret - 1;
      end if;
   end floor;


begin

   initialStackSize := (max - L0) / numStacks;

   --calculated and set the initial bases and tops of each stack
   for i in integer range 1 .. numStacks loop
      base(i) := floor((float(i)-1.0) / float(numStacks) * float(max - L0)) + L0;
      top(i) := base(i);
      oldTop(i) := top(i);
   end loop;

   --set the final base
   base(numStacks + 1) := max;

end multistack;
