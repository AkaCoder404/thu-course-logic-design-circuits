-- Create a digital tube display using VHDL

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lights is
	port(	
		clk, rst: in STD_LOGIC; 								-- clk -> PIN_30,  rst -> PIN_29
		testbench: out STD_LOGIC; 				
		display:out STD_LOGIC_VECTOR(6 downto 0); 		-- without decoded, 				PIN_21-PIN_15
		display_even:out STD_LOGIC_VECTOR(3 downto 0);  -- decoded, even numbers 		PIN_40-PIN_37
		display_odd:out STD_LOGIC_VECTOR(3 downto 0)    --	decoded, odd numbers			PIN_36-PIN_33
	);
end lights;

architecture bhv of lights is
	signal sig_natural: STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); -- natural numbers
	signal sig_even: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');    -- even numbers
	signal sig_odd: STD_LOGIC_VECTOR(3 downto 0) := "0001";					-- odd numbers
begin
	process(clk, rst)
	begin
		if(clk'event AND clk='1') then 
			if (sig_natural = "1111") then           	-- For all natural numbers 0 - F
				sig_natural <= "0000"; 
			else 
				sig_natural <= sig_natural + '1';
			end if;
			if (sig_even = "1000") then					-- For all even numbers 0 - 8
				sig_even <= "0000";
			else
				sig_even <= sig_even + 2;
			end if;
			if (sig_odd = "1001") then						-- For all odd numbers 1 - 9
				sig_odd <= "0001";
			else 
				sig_odd <= sig_odd + 2;					
			end if;
			if(rst = '1') then							
				sig_natural <= "0000";
				sig_even <= "0000";
				sig_odd <= "0001";	
			end if;
		end if;
	end process;
	
	process(sig_even) begin
		display_even <= sig_even;
	end process;
	
	process(sig_odd) begin
		display_odd <= sig_odd;
	end process;
	
	process(sig_natural)begin
		case sig_natural is
			when "0000" => display <= "1111110"; -- 0 -- correct
			when "0001"	=> display <= "0110000"; -- 1 -- correct
			when "0010" => display <= "1101101"; -- 2 -- correct 
			when "0011" => display <= "1111001"; -- 3 -- correct
			when "0100" => display <= "0110011"; -- 4 -- correct
			when "0101" => display <= "1011011"; -- 5 -- correct
			when "0110" => display <= "0011111"; -- 6 -- correct
			when "0111" => display <= "1110000"; -- 7 -- correct
			when "1000" => display <= "1111111"; -- 8 -- correct
			when "1001" => display <= "1110011"; -- 9 -- correct
			when "1010" => display <= "1110111"; -- A -- correct
			when "1011" => display <= "0011111"; -- b -- correct
			when "1100" => display <= "1001110"; -- C -- correct
			when "1101" => display <= "0111101"; -- d -- correct
			when "1110" => display <= "1001111"; -- E -- correct
			when "1111" => display <= "1000111"; -- F -- correct
			when others => display <= "0000000"; -- If all others fail
			end case;	
	end process;
end bhv;
