library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
   port (
      refreshClock:   in STD_LOGIC;
      clockDig1:		in STD_LOGIC;
      rst :   in     STD_LOGIC; -- STOP/RESET
      key1:   in     STD_LOGIC; -- GO/PAUSE
      key2:   in     STD_LOGIC; -- LAP
      key3:   in     STD_LOGIC; -- DISPLAY LAP
	   led:    OUT    STD_LOGIC_VECTOR (3 downto 0) := "0000";   
      dig:    OUT    STD_LOGIC_VECTOR (7 downto 0) := "00000000";
      sel:    OUT    STD_LOGIC_VECTOR (5 downto 0) := "000000"  
   );
end display;

architecture struct of display is
   signal en: STD_LOGIC := '0';
   signal lap: STD_LOGIC := '0';
   signal displayer: STD_LOGIC := '0';
   signal push_button_sig_start : integer:=0;
   signal push_button_sig_save_lap: integer:=0;
   signal push_button_sig1 : integer:=0;
   signal push_button_sig2 : integer:=0;
   signal push_button_sig_display_lap : integer:=0;
   signal push_button_sig3 : integer:=0;
   signal lap_count : integer:=0;
   signal lap_display: integer:=0;
	-- New Added -- Track Each dig#Count
	subtype digitCount is integer range 0 to 9;
	type clocks is array (5 downto 0) of digitCount; 
	-- New Added -- Track Each use#
	subtype usenum is integer range 0 to 9;
	type used is array (5 downto 0) of usenum;
	-- New Added -- Track is dig#Laps
	subtype digLap is integer range 0 to 9;
	type split is array (14 downto 0) of digLap;
	-- Naming
	signal uses 	: used := (1,1,1,1,1,1);
	signal clock  : clocks := (1,1,1,1,1,1);
	signal laps   : split := (1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
   
	begin
      display: process (refreshClock, clockDig1, rst, key1, key2, key3, en, lap) is
      begin
			-- RESET BUTTON
         if(rst='0' and en = '0') then 				
				led(3) <= '1';
				led(2) <= '0';
				led(0) <= '0';
				for k in 0 to uses'length-1 loop
					uses(k) <= 0;
				end loop;
				for k in 0 to clock'length-1 loop
					clock(k) <= 0;
				end loop;
				for k in 0 to laps'length-1 loop
					laps(k) <= 0;
				end loop;
			-- SHOW SPLIT TIMES
			elsif (displayer = '1' and en = '0') then
				if (lap_display = 1) then
					led(0) <= '1';
					for k in 0 to uses'length-2 loop
						uses(k) <= laps(k);
					end loop;
				elsif (lap_display = 2) then
					for k in 0 to uses'length-2 loop
						uses(k) <= laps(k+5);
					end loop;
				elsif (lap_display = 3) then
					for k in 0 to uses'length-2 loop
						uses(k) <= laps(k+10);
					end loop;
				end if;
			-- COUNTING 
			elsif rising_edge(clockDig1) then
				if (en = '1') then
					led(3) <= '0';
					led(0) <= '0';
					led(2) <= '1';
					led(1) <= '0';
					for k in 0 to uses'length-2 loop
						uses(k) <= clock(k);
					end loop;
					if (lap = '1') then
						led(1) <= '1';
						
						if (lap_count = 1) then
							for k in 0 to clock'length-2 loop
								laps(k) <= clock(k);
							end loop;
						elsif (lap_count = 2) then
							for k in 0 to clock'length-2 loop
								laps(k+5) <= clock(k);
							end loop;
						elsif (lap_count = 3) then
							for k in 0 to clock'length-2 loop
								laps(k+10) <= clock(k);
							end loop;
						end if;
					end if;		
					
					-- Centiseconds < Seconds < Minutes
					clock(0) <= clock(0) + 1; 					-- .01 Seconds
					if(clock(0) = 9) then
						clock(0) <= 0;
						clock(1) <= clock(1) + 1; 				-- .1 Seconds
						if (clock(1) = 9) then
							clock(1) <= 0;
							clock(2) <= clock(2) + 1;			-- 1 Seconds
							if (clock(2) = 9) then
								clock(2) <= 0;
								clock(3) <= clock(3) + 1;     -- 10 Seconds
								if (clock(3) = 5) then 
									clock(3) <= 0;
									clock(4) <= clock(4) + 1;
									if(clock(4) = 9) then     	-- 1 Minute
										clock(4) <= 0;
									end if;
								end if;
							end if;
						end if;
					end if;				
				end if;	
			end if;
			end process display;
			
			process(refreshClock)
			variable digit: unsigned (2 downto 0) := "000";
			begin
				if(rising_edge(refreshClock)) then
					case digit is 
						when "000" =>
							case (uses(0)) is 
								when 0 => 
									sel <= "111110";
									dig <= "11000000";
								when 1 => 
									sel <= "111110"; 
									dig <="11111001"; -- 1
								when 2 =>
									sel <= "111110";
									dig <="10100100"; -- 2
								when 3 =>
									sel <= "111110";
									dig <="10110000"; -- 3
								when 4 =>
									sel <= "111110";
									dig <="10011001"; -- 4
								when 5 =>
									sel <= "111110";
									dig <="10010010"; -- 5
								when 6 =>
									sel <= "111110";
									dig <="10000010"; -- 6
								when 7 =>
									sel <= "111110";
									dig <="11111000"; -- 7
								when 8 =>
									sel <= "111110";
									dig <="10000000"; -- 8
								when 9 => 
									sel <= "111110";
									dig <="10010000"; -- 9
								when others =>
									sel <= "111110";
									dig <="00000000";
							end case;
						when "001" =>
							case (uses(1)) is
								when 0 => 
									sel <= "111101";
									dig <= "11000000";
								when 1 => 
									sel <= "111101"; 
									dig <="11111001"; -- 1
								when 2 =>
									sel <= "111101";
									dig <="10100100"; -- 2
								when 3 =>
									sel <= "111101";
									dig <="10110000"; -- 3
								when 4 =>
									sel <= "111101";
									dig <="10011001"; -- 4
								when 5 =>
									sel <= "111101";
									dig <="10010010"; -- 5
								when 6 =>
									sel <= "111101";
									dig<="10000010"; -- 6
								when 7 =>
									sel <= "111101";
									dig <="11111000"; -- 7
								when 8 =>
									sel <= "111101";
									dig <="10000000"; -- 8
								when 9 => 
									sel <= "111101";
									dig <="10010000"; -- 9
								when others =>
									sel <= "111101";
									dig <="00000000";
							end case;
						when "010" => 
							case(uses(2)) is 
								when 0 => 
									sel <= "111011";
									dig <= "01000000";
								when 1 => 
									sel <= "111011"; 
									dig<="01111001"; -- 1
								when 2 =>
									sel <= "111011";
									dig <="00100100"; -- 2
								when 3 =>
									sel <= "111011";
									dig <="00110000"; -- 3
								when 4 =>
									sel <= "111011";
									dig <="00011001"; -- 4
								when 5 =>
									sel <= "111011";
									dig <="00010010"; -- 5
								when 6 =>
									sel <= "111011";
									dig <="00000010"; -- 6
								when 7 =>
									sel <= "111011";
									dig <="01111000"; -- 7
								when 8 =>
									sel <= "111011";
									dig <="00000000"; -- 8
								when 9 => 
									sel <= "111011";
									dig <="00010000"; -- 9
								when others =>
									sel <= "111011";
									dig <="00000000";
							end case;
						when "011" => 
							case(uses(3)) is 
								when 0 => 
									sel <= "110111";
									dig <= "11000000";
								when 1 => 
									sel <= "110111"; 
									dig <="11111001"; -- 1
								when 2 =>
									sel <= "110111";
									dig <="10100100"; -- 2
								when 3 =>
									sel <= "110111";
									dig <="10110000"; -- 3
								when 4 =>
									sel <= "110111";
									dig <="10011001"; -- 4
								when 5 =>
									sel <= "110111";
									dig <="10010010"; -- 5
								when 6 =>
									sel <= "110111";
									dig <="10000010"; -- 6
								when 7 =>
									sel <= "110111";
									dig <="11111000"; -- 7
								when 8 =>
									sel <= "110111";
									dig <="10000000"; -- 8
								when 9 => 
									sel <= "110111";
									dig <="10010000"; -- 9
								when others =>
									sel <= "110111";
									dig <="00000000";
							end case;
						when "100" =>
							case(uses(4)) is 
								when 0 => 
									sel <= "101111";
									dig <= "01000000";
								when 1 => 
									sel <= "101111"; 
									dig <="01111001"; -- 1
								when 2 =>
									sel <= "101111";
									dig <="00100100"; -- 2
								when 3 =>
									sel <= "101111";
									dig <="00110000"; -- 3
								when 4 =>
									sel <= "101111";
									dig <="00011001"; -- 4
								when 5 =>
									sel <= "101111";
									dig <="00010010"; -- 5
								when 6 =>
									sel <= "101111";
									dig <="00000010"; -- 6
								when 7 =>
									sel <= "101111";
									dig <="01111000"; -- 7
								when 8 =>
									sel <= "101111";
									dig <="00000000"; -- 8
								when 9 => 
									sel <= "101111";
									dig <="00010000"; -- 9
								when others =>
									sel <= "101111";
									dig <="00000000";
							end case;	
						when "101" =>
							case(uses(5)) is 
								when 0 => 
									sel <= "011111";
									dig <= "11000000";
								when 1 => 
									sel <= "011111"; 
									dig <="11111001"; -- 1
								when 2 =>
									sel <= "011111";
									dig <="10100100"; -- 2
								when 3 =>
									sel <= "011111";
									dig <="10110000"; -- 3
								when 4 =>
									sel <= "011111";
									dig <="10011001"; -- 4
								when 5 =>
									sel <= "011111";
									dig <="10010010"; -- 5
								when 6 =>
									sel <= "011111";
									dig <="10000010"; -- 6
								when 7 =>
									sel <= "011111";
									dig <="11111000"; -- 7
								when 8 =>
									sel <= "011111";
									dig <="10000000"; -- 8
								when 9 => 
									sel <= "011111";
									dig <="10010000"; -- 9
								when others =>
									sel <= "011111";
									dig <="00000000";
							end case;					
						when others => 
							sel <= "011111";
							dig <="00000000";
							sel <= "101111";
							dig <="00000000";
							sel <= "110111";
							dig <="00000000";
							sel <= "111011";
							dig <="00000000";
							sel <= "111101";
							dig <="00000000";
							sel <= "111110";
							dig <="00000000";
						end case;
						digit := digit + 1;
						if digit = "110" then
							digit := "000";
						end if;
					end if;
				end process;
				process(clockDig1)
				begin
					if (rising_edge(clockDig1)) then 
						if(key3 = '0') then
							push_button_sig_display_lap <= 1;
						elsif (key3 = '1') then
							push_button_sig_display_lap <= 0;
						end if;
						push_button_sig3 <= push_button_sig_display_lap;
						if (push_button_sig3 = 0 and push_button_sig_display_lap = 1) then
							displayer <= '1';
							lap_display <= lap_display + 1;
							if (lap_display = 3) then
								lap_display <= 1;
							end if;
						elsif (push_button_sig3 = 1 and push_button_sig_display_lap = 0) then
								displayer <= '0';
						end if;

						if (key2 = '0') then
							push_button_sig_save_lap <= 1;
						elsif(key2 = '1') then
							push_button_sig_save_lap <= 0;
						end if;
						push_button_sig2 <= push_button_sig_save_lap;
						if (push_button_sig2 = 0 and push_button_sig_save_lap = 1) then
							lap <= '1';
							lap_count <= lap_count + 1;
							if (lap_count = 3) then
								lap_count <= 1;
							end if;
						elsif (push_button_sig2 = 1 and push_button_sig_save_lap = 0) then
							lap <= '0';
						end if;
						if (key1 = '0') then 
							push_button_sig_start <= 1;
						elsif (key1 = '1') then 
							push_button_sig_start <= 0;
							
						end if;
						push_button_sig1 <= push_button_sig_start;
						if (push_button_sig1 = 0 and push_button_sig_start = 1) then
							en <= not en;
							lap_display <= 0;
						end if;
						if (rst = '0' and en = '0') then
							lap_count <= 0;
							lap_display <= 0;
						end if;
					end if;
			  end process; 
end struct;
