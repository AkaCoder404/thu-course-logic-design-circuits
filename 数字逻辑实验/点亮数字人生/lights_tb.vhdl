-- testbench for lights 

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity lights_tb is
end;

architecture bench of lights_tb is
  component lights
  	port(	
  		clk, rst: in STD_LOGIC;
  		testbench: out STD_LOGIC; 				
  		display:out STD_LOGIC_VECTOR(6 downto 0);
  		display_even:out STD_LOGIC_VECTOR(3 downto 0);
  		display_odd:out STD_LOGIC_VECTOR(3 downto 0)
  	);
  end component;
	  signal clk, rst: STD_LOGIC;
	  signal testbench: STD_LOGIC;
	  signal display: STD_LOGIC_VECTOR(6 downto 0);
	  signal display_even: std_logic_vector(3 downto 0);
	  signal display_odd: STD_LOGIC_VECTOR(3 downto 0) ;
	  
		constant clock_period: time := 10 ns;
		signal stop_the_clock: boolean;

begin
  uut: lights port map ( clk          => clk,
                         rst          => rst,
                         testbench    => testbench,
                         display      => display,
                         display_even => display_even,
                         display_odd  => display_odd );

  stimulus: process
  begin
      -- Put initialisation code here
	 
	stop_the_clock <= true;
	 
    -- Put test bench stimulus code here
    wait;
  end process;
  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;
end;
