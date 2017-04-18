--driver.adb

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO,
     Ada.Strings.Equal_Case_Insensitive, multistack, date;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO,
    Ada.Strings, date;

--------
--main--
--------
procedure runMultiStack is

   package SU renames Ada.Strings.Unbounded;

   data : SU.Unbounded_String;
   dateData : dateType;
   max, numStacks, L0, SSmin, SSmax, dataType : Integer;
   error : boolean := false;
   stackNum, choice : Integer;

   ----------- Gets the data and returns it to
   --getDate-- the main program to push on the stack
   -----------
   procedure getDate(retDate : in out dateType) is
      monthTemp : String(1..11);
      month : monthName;
      day : integer range 1..31;
      year : integer range 1400..2020;
      count : integer;
      ctemp : character;
   begin
      --put("Enter the date: ");

      count := 1;

      --get the month using ' ' as a delimiter
      getMonthTemp:
      loop
         get(ctemp);
         monthTemp(count) := ctemp;
         count := count + 1;
         exit getMonthTemp when ctemp = ' ';
      end loop getMonthTemp;

      --get the day
      get(day);
      --skip the comma
      get(ctemp);
      --get the year
      get(year);

      if Equal_Case_Insensitive(monthTemp(1..3), "Jan") then month := January;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Feb") then month := February;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Mar") then month := March;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Apr") then month := April;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "May") then month := May;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Jun") then month := June;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Jul") then month := July;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Aug") then month := August;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Sep") then month := September;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Oct") then month := October;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Nov") then month := November;
         elsif Equal_Case_Insensitive(monthTemp(1..3), "Dec") then month := December;
         else
         --print an error if it isn't a month name
            put("Error reading the month name!");
            return;
      end if;

      --set the data to return
      retDate.month := month;
      retDate.day := day;
      retDate.year := year;

   end getDate;

--begin main--
begin
   loop
   Get(DataType);
   if DataType = 1 then
      Put("Processing Strings"); New_Line;
   elsif dataType = 2 then
      Put("Processing Dates"); New_line;
   end if;
   exit when dataType = 3;
   put("Number of stacks: ");
   Get(NumStacks);
   Put(NumStacks,0); new_line;

   put("Minimum subscript of the multistack array (L0): ");
   Get(L0);
   put(L0,0); new_line;

   put("Max storage of all combined stacks (max): ");
   Get(Max);
   put(max,0); new_line;

   put("Min subscript of the WHOLE array: ");
   get(SSmin);
   put(SSmin,0); new_line;

   put("Max subscript of the WHOLE array: ");
   get(SSmax);
   Put(SSmax,0); New_Line;

   --dataType = strings--
   if dataType = 1 then
      declare
         --create the stack
         package s is new multistack(numStacks, L0, max, SSmin, SSmax, SU.Unbounded_String);
      begin
         StringLoop:
         loop --get the user input until we need to exit
            new_line;
            Get(Choice);
            --put(Choice);

            case choice is
               when 1 => --push
                  get(stackNum);
                  get_line(data);
                  Put(StackNum,0); put(' ');
                  put(data); new_line;
                  --push it and check for errors
                  s.push(data, stackNum, Error);
                  if error = true then
                     put_line("Error pushing data on the stack!");
                     Error := False;
                  else
                     put_line("Pushing");
                  end if;

               when 2 => --pop
                  --put("StackNumber ");
                  get(stackNum);
                  --put(stackNum);
                  --pop and check for errors
                  s.pop(data, stackNum, Error);
                  if error = true then
                     new_line;
                     put_line("Nothing to pop!");
                     error := false;

                  else
                     new_line;
                     --put("Popped: "); put_line(data);
                     put_line(data);
                  end if;

               when 3 => --exit
                  put("Done with string!"); new_line;
                  exit StringLoop;

               when others =>
                  put("Invalid choice.");
            end case;
         end loop StringLoop;
      end;

   --dataType = date--
   elsif dataType = 2 then
      declare
         --create the stack
         package s is new multistack(numStacks, L0, max, SSmin, SSmax, DateType);
      begin
         DateLoop:
            Loop --get the input from the user till we need to exit
            new_line;
            get(choice);

            case choice is
               when 1 => --push
                  Get(StackNum);
                  getDate(dateData); --call to getDate
                  date.MonthNameIO.put(dateData.month);
                  put(" ");
                  put(dateData.day, 0);
                  put(", ");
                  put(dateData.year, 0); new_line;
                  --push and check for errors
                  s.push(dateData, stackNum, Error);
                  if error = true then
                     put_line("Error pushing data on the stack!");
                     error := false;
                  end if;

               when 2 => --pop
                  --put("Stack Number: ");
                  get(stackNum);
                  --put(stackNum); new_line;
                  --pop and check for errors
                  s.pop(dateData, stackNum, Error);
                  if error = true then
                     new_line;
                     put_line("Nothing to pop!");
                     error := false;

                  Else --print the date
                     --put("Pop :");
                     new_line;
                     date.MonthNameIO.put(dateData.month);
                     put(" ");
                     put(dateData.day, 0);
                     put(", ");
                     put(dateData.year, 0);
                     new_line;
                  end if;

               when 3 => --exit
                  put("Done with Date!"); new_line;
                  exit DateLoop;

               when others =>
                  put("Invalid choice.");
            end case;
         end loop DateLoop;
      end;
   end if;
  end loop;
end runMultiStack;
