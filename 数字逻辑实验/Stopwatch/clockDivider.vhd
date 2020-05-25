library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clockDivider is
   port (
      clk:            in  STD_LOGIC;
      refreshClock:   out STD_LOGIC;
      clockDig1:      out STD_LOGIC
   );
end clockDivider;

architecture struct of clockDivider is 
   signal count1: integer range 0 to 50000000;
   signal count2: integer range 0 to 50000000;
   signal temp1:   STD_LOGIC:='0';
   signal temp2:   STD_LOGIC:='0';
begin 
   frequencyDivider: process(clk)
   begin
   if rising_edge(clk) then
      count1 <= count1+1;
      count2 <= count2+1;
         if(count1 = 104167) then
            temp1 <= NOT temp1;
            count1 <= 0;
         end if;
         if(count2 =  250000) then
            temp2 <= NOT temp2;
            count2 <= 0;
         end if;
   end if;
   end process;
   refreshClock <= temp1;
   clockDig1 <= temp2;
end struct;
