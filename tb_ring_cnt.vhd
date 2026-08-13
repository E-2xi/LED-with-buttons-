library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ring_cnt is
end entity tb_ring_cnt;

architecture sim of tb_ring_cnt is

    constant CLK_PERIOD : time := 100 ns;

    signal tb_clk : std_logic := '0';
    signal tb_rst : std_logic := '0';
    signal tb_cnt : std_logic_vector(9 downto 0);

	function vec2str(vec : std_logic_vector) return string is
    	variable result : string(1 to vec'length);
    	variable index  : integer := 1;
	begin
    	for i in vec'reverse_range loop
        	result(index) := std_logic'image(vec(i))(2);
        	index := index + 1;
    	end loop;

    	return result;
	end function;

begin

    --------------------------------------------------------------------
    -- Unit Under Test
    --------------------------------------------------------------------
    uut : entity work.ring_cnt
        port map (
            clk => tb_clk,
            rst => tb_rst,
            cnt => tb_cnt
        );

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            tb_clk <= '0';
            wait for CLK_PERIOD / 2;

            tb_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- Test process
    --------------------------------------------------------------------
    stimulus : process
        variable expected : std_logic_vector(9 downto 0);

    begin

        ----------------------------------------------------------------
        -- Reset
        ----------------------------------------------------------------
        tb_rst <= '0';

        wait until rising_edge(tb_clk);
        wait until rising_edge(tb_clk);

        -- During reset, counter should be zero
        assert tb_cnt = "0000000000"
            report "ERROR: Counter is not zero during reset."
            severity error;

        ----------------------------------------------------------------
        -- Release reset
        ----------------------------------------------------------------
        tb_rst <= '1';

        ----------------------------------------------------------------
        -- LED 0
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0000000001";

        assert tb_cnt = expected
            report "ERROR: LED 0 pattern incorrect."
            severity error;

        report "PASS: LED pattern = " & vec2str(tb_cnt)
            severity note;

        ----------------------------------------------------------------
        -- LED 1
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0000000010";

        assert tb_cnt = expected
            report "ERROR: LED 1 pattern incorrect."
            severity error;

        report "PASS: LED pattern = " & vec2str(tb_cnt)
            severity note;

        ----------------------------------------------------------------
        -- LED 2
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0000000100";

        assert tb_cnt = expected
            report "ERROR: LED 2 pattern incorrect."
            severity error;

        ----------------------------------------------------------------
        -- LED 3
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0000001000";

        assert tb_cnt = expected
            report "ERROR: LED 3 pattern incorrect."
            severity error;

        ----------------------------------------------------------------
        -- LED 4
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0000010000";

        assert tb_cnt = expected
            report "ERROR: LED 4 pattern incorrect."
            severity error;

        ----------------------------------------------------------------
        -- LED 5
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0000100000";

        assert tb_cnt = expected
            report "ERROR: LED 5 pattern incorrect."
            severity error;

        ----------------------------------------------------------------
        -- LED 6
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0001000000";

        assert tb_cnt = expected
            report "ERROR: LED 6 pattern incorrect."
            severity error;

        ----------------------------------------------------------------
        -- LED 7
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0010000000";

        assert tb_cnt = expected
            report "ERROR: LED 7 pattern incorrect."
            severity error;

        ----------------------------------------------------------------
        -- LED 8
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0100000000";

        assert tb_cnt = expected
            report "ERROR: LED 8 pattern incorrect."
            severity error;

        ----------------------------------------------------------------
        -- LED 9
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "1000000000";

        assert tb_cnt = expected
            report "ERROR: LED 9 pattern incorrect."
            severity error;

        ----------------------------------------------------------------
        -- Check wrap-around back to LED 0
        ----------------------------------------------------------------
        wait until rising_edge(tb_clk);

        expected := "0000000001";

        assert tb_cnt = expected
            report "ERROR: Counter did not wrap back to LED 0."
            severity error;

        ----------------------------------------------------------------
        -- Simulation finished
        ----------------------------------------------------------------
        report "========================================"
            severity note;

        report "ALL RING COUNTER TESTS PASSED."
            severity note;

        report "========================================"
            severity note;

        wait;

    end process;

end architecture sim;
