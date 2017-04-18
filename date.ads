--file: date.ads

with Ada.Text_IO;

package date is
   type MonthName is (January, February, March, April, May, June, July, August, September, October, November, December);

   package MonthNameIO is new Ada.Text_IO.Enumeration_IO(MonthName);
   use MonthNameIO;

   Package IntegerIO is new Ada.Text_IO.Enumeration_IO(Integer);
   Use IntegerIO;

   type DateType is record
      month: MonthName;  day: integer range 1..31;  year: integer range 1400..2020;
   end record;
end date;
