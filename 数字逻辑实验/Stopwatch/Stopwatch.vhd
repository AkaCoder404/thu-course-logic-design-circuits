library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Stopwatch is
   Port ( 
      clk :   in     STD_LOGIC;                       -- Clock
      rst :   in     STD_LOGIC;                       -- STOP/RESET
      key1:   in     STD_LOGIC;                       -- GO/PAUSE
      key2:   in     STD_LOGIC;                       -- LAP
      key3:   in     STD_LOGIC;                       -- DISPLAY LAP
		  led:    OUT    STD_LOGIC_VECTOR (3 downto 0);   -- show what setting each is
      sel:    OUT    STD_LOGIC_VECTOR (5 downto 0);   -- controls which of the 6 anthode displays are being used
      dig:    OUT    STD_LOGIC_VECTOR (7 downto 0)    -- controls the 7 + 1 (decmial point) segment display of a single anthode
   );
end Stopwatch;


architecture struct of Stopwatch is
   component clockDivider port (
      clk: in STD_LOGIC;
      refreshClock: out STD_LOGIC;
      clockDig1:    out STD_LOGIC
   );
   end component;
   signal refreshSig: STD_LOGIC;
   signal dig1Sig:    STD_LOGIC;
   component display port (
		refreshClock:   in  STD_LOGIC;
		clockDig1:      in  STD_LOGIC;
		rst :   in     STD_LOGIC; -- STOP/RESET
		key1:   in     STD_LOGIC; -- GO/PAUSE
		key2:   in     STD_LOGIC; -- LAP
		key3:   in     STD_LOGIC; -- DISPLAY LAP
		led:    OUT    STD_LOGIC_VECTOR (3 downto 0);
		dig:    OUT    STD_LOGIC_VECTOR (7 downto 0);
		sel:    OUT    STD_LOGIC_VECTOR (5 downto 0)		  
   );
   end component;
   begin 
      part0: clockDivider port map (clk => clk, refreshClock => refreshSig, clockDig1=> dig1Sig);
      part1: display port map(refreshClock => refreshSig, clockDig1=>dig1Sig, rst=>rst, key1=>key1, key2=>key2, key3=>key3, led=>led, dig=>dig, sel=>sel );
end struct;




