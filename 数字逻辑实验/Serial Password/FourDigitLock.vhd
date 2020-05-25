LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 提高要求
entity FourDigitLock is
    port (
        rst, clk:       in  STD_LOGIC;
        Code:           in  STD_LOGIC_VECTOR(3 downto 0);
        Mode:           in  STD_LOGIC_VECTOR(1 downto 0);
        Unlock:         out STD_LOGIC;
        Err:            out STD_LOGIC;
        Alarm:          out STD_LOGIC
    );
    -- password is vector of digits 
    subtype digit is integer range 0 to 15;
    type pass is array (3 downto 0) of digit;
    -- all states - described in the document 
    subtype states is integer range 1 to 8;
end FourDigitLock;

architecture struct of FourDigitLock is
    constant admin_pass     :   pass := (8,8,8,8); -- Initial Password
    signal password: pass   :=  admin_pass;
    signal enter_digit      :   digit;
    signal ADMIN            :   STD_LOGIC;
    signal USER             :   STD_LOGIC;
    signal STATE            :   states;
    signal COUNT            :   integer := 0;
begin 
    enter_digit <= conv_integer(Code); -- convert Code into an Integer
    process(clk, rst)
    begin
        if (rst = '1') then
            STATE   <= 1;
            Unlock  <= '0';
            Err     <= '0';
        elsif (clk'event and clk='1') then
            -- set password if Mode = "00", Alarm is off, and haven't failed yet.
            if(Mode = "00" and COUNT = 0)  then               -- Set Password
                case STATE is 
                    when 1 => password(STATE - 1) <= enter_digit; STATE <= STATE + 1;
                    when 2 => password(STATE - 1) <= enter_digit; STATE <= STATE + 1;
                    when 3 => password(STATE - 1) <= enter_digit; STATE <= STATE + 1;
                    when 4 => password(3)         <= enter_digit; STATE <= 8; Unlock <= '1';
                    when others => NULL;
                end case;
            elsif(Mode = "01") then   -- Verify Password
                case STATE is
                    when 1 => 
                        -- if first digit equals regular password or master password
                        if (((enter_digit = password(0))) OR (enter_digit = admin_pass(0))) then
                            if ((enter_digit = password(0))) then
                                USER <= '1';
                            else
                                USER <= '0';
                            end if;
                            if (enter_digit = admin_pass(0)) then
                                ADMIN <= '1';
                            else 
                                ADMIN <= '0';  
                            end if;                      
                            STATE <= 5;
                            Err <= '0';
                        else 
                            Err <= '1';  
                            if (COUNT > 1) then
                                Alarm <= '1';
                                COUNT <= 0;
                            else 
                                COUNT <= COUNT + 1; 
                            end if;                         
                        end if ;
                    when 5 | 6 | 7 =>
                        if ((((enter_digit = password(STATE - 4)) and USER = '1')) OR ((enter_digit = admin_pass(STATE - 4) AND (ADMIN = '1')))) then
                            if(STATE = 7) then 
                                Unlock <= '1';
                                --STATE <= 1; -- Return Back to State One After Unlocked
                                ALARM <= '0';
                                COUNT <= 0;
                            end if;
                            state <= state + 1;
                            if(enter_digit /= password(STATE - 4)) then 
                                USER <= '0';
                            end if;
                            if(enter_digit /= admin_pass(STATE - 4)) then
                                ADMIN <= '0';
                            end if;
                        else 
                            Err <= '1';
                            State <= 1;
                            if (COUNT > 1) then
                                Alarm <= '1';
                                COUNT <= 0;
                            else 
                                COUNT <= COUNT + 1;
                            end if;
                        end if;
                    when others => NULL;
                end case;
            end if;
        end if;
    end process;
end struct;
