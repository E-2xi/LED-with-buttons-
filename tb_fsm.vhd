library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

-- this is a test brench of fsm
entity tb_fsm is 
end tb_fsm; 

architecture bhv of tb_fsm is 

	component fsm is 
		port(btn, clk, rst : in std_logic; 
	     	     LEDR	   : out std_logic_vector (9 downto 0) 
	     	); 
	end component; 

	---------------------------------------------------------------------------
    --  Helper function: converts a std_logic_vector to a string so we can print
    --  it in assert messages (useful for debugging mismatches).
    ---------------------------------------------------------------------------
    function vec2str(vec: std_logic_vector) return string is
        variable stmp    : string(vec'high+1 downto 1);
        variable counter : integer := 1;
    begin
        -- Iterate MSB?>LSB and collect '0'/'1' ascii characters
        for i in vec'reverse_range loop
            stmp(counter) := std_logic'image(vec(i))(2); -- character at index 2
            counter := counter + 1;
        end loop;
        return stmp;
    end vec2str;

    ---------------------------------------------------------------------------
    --  Generic timing constants & simulation signals
    ---------------------------------------------------------------------------
    constant clk_period : time := 100 ns;        -- 10 MHz effective clock

	-- Primary test?bench signals 
	signal tb_clk, tb_rst, tb_btn : std_logic := '0'; -- all those are input std_logic
	signal tb_ledr : std_logic_vector(9 downto 0); -- it contains a vector of 9 red leds 
	-- signal tb_cnt : std_logic; -- it is an output of std_logic. 

begin

	---------------------------------------------------------------------------
    --  Instantiate the Unit Under Test (UUT)
    ---------------------------------------------------------------------------
	uut: fsm
		port map (
			 clk => tb_clk,
			 rst => tb_rst,
			 btn => tb_btn,
			 LEDR => tb_ledr
		); 
	
	---------------------------------------------------------------------------
    --  Clock generation: simple free?running 50 % duty cycle
    ---------------------------------------------------------------------------
	clk_process: process 
	begin 
		tb_clk <= '0';
		wait for clk_period / 2;
		tb_clk <= '1'; 
		wait for clk_period / 2;
	end process; 

    ---------------------------------------------------------------------------
    --  Reset process: generates an asynchronous clear pulse for the control?SM.
    --  * clear_sm = '0' holds the FSM in reset
    --  * clear_sm = '1' releases it
    ---------------------------------------------------------------------------
	rst_process: process
	begin 
		tb_rst <= '0';                    -- assert reset
        wait for clk_period/4;            -- keep it for 25 ns
	    tb_rst <= '1';                    -- de?assert reset
 	    wait;                               -- no further action
    end process;
	
    --------------------------------------------------------------------------
    --  Stimulus process: applies operands, pulses *start*, waits for the
    --  computation to finish (fixed 5?cycle wait for turning leds on at instruction), then
    --  checks the result with assert.
    ---------------------------------------------------------------------------
	stim_process: process 
	begin 
		--------------------------------------------------------------------
        -- Wait until reset is released before driving anything
        --------------------------------------------------------------------
        -- wait until rst = '1'; -- Wait for reset to finish
        -- wait until ready = '1'; drive into receive undefined waveform.
        --------------------------------------------------------------------
        -- Test vector #1 to see red led turns on 
        --------------------------------------------------------------------	
		wait until tb_rst = '1'; 
		wait for clk_period * 5;
		
		report "=== Starting FSM Simulation ===" severity note;
		
		report "Curret LED Output" & vec2str(tb_ledr) severity note;
		-- Pulse button to transition FSM mode
		report "Action: Pressing Button" severity note; 
		tb_btn <= '1';
		wait for clk_period * 2; 
		tb_btn <= '0'; 
		wait for clk_period * 10; 
		
		assert tb_ledr'length = 10; 
			report "Error: Unexpected LED vector size" 
			severity failure; 

		-- Pulse button again 
		report "Action: Pressing Button" severity note; 
		tb_btn <= '1';
		wait for clk_period * 2; 
		tb_btn <= '0'; 
		wait for clk_period * 20; 

		-- Final verification 
		report "=== Simulation completed with no error. Final LED state: " & vec2str(tb_ledr) severity note;
		
		wait; --keep simulation running 
	end process; 
end bhv;
