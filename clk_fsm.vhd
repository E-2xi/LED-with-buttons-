library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--btn is button
entity clk_fsm is 
	port (btn, rst, clk : in std_logic; 
			clk_out 		  : out std_logic
			); 
end entity clk_fsm; 

architecture divide of clk_fsm is 
	signal pres_state, next_state : std_logic_vector(1 downto 0);
	signal c								: unsigned(23 downto 0);
begin 
	counter24: process(clk)
	begin
		if rst = '0' then 
			c <= (others => '0');
		elsif rising_edge(clk) then
			c <= c + 1; 
		end if; 
	end process;
	
	pres_state_logic: process(clk,rst) 
	begin
		if rst = '0' then 
			pres_state <= "00";
		elsif rising_edge(clk) then
			pres_state <= next_state; 
		end if;
	end process;
	
	state_transition_logic: process(pres_state, btn)
	begin 
		if rst = '0' then
			next_state <= "01"; -- you can modify bits based your preference for switching mode of freq motion
		elsif rising_edge(btn) then 
				case pres_state is
					when "00" =>
						next_state <= "01";  -- normal speed
					when "01" => 
						next_state <= "10"; -- stop
					when "10" => 
						next_state <= "11"; -- faster speed
					when "11" => 
						next_state <= "01"; -- go back to normal speed
					when others => 
						next_state <= "00"; -- stop
				end case;
			end if;
	end process; 
	
	output_logic: process(pres_state)
	begin 
		case pres_state is
			when "00" => 
				clk_out <= std_logic(c(23));
			when "01" => 
				clk_out <= std_logic(c(22));
			when "11" => 
				clk_out <= std_logic(c(21));
			when others => 
				clk_out <= '0'; 
			end case; 
	end process;
end architecture divide; 

