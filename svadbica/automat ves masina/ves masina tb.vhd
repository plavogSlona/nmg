library ieee;
use ieee.std_logic_1164.all;

entity aut_tb is
end aut_tb;

architecture behavioral of aut_tb is

    component aut is port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_run : in std_logic;
        i_water : in std_logic;
        i_detergent : in std_logic;
        i_door_closed : in std_logic;
        i_wl_max : in std_logic;
        i_hw : in std_logic_vector(1 downto 0);
        i_temp_ok : in std_logic;
        i_wl_min : in std_logic;
        i_door_open : in std_logic;
        o_lock : out std_logic;
        o_valve_in : out std_logic;
        o_heater : out std_logic;
        o_motor_run : out std_logic_vector(1 downto 0);
        o_valve_out : out std_logic;
        o_pump_out : out std_logic
    );
    end component;

    constant i_clk_period : time := 10 ns;

    signal i_clk : std_logic := '0';
    signal i_rst : std_logic := '0';
    signal i_run : std_logic := '0';
    signal i_water : std_logic := '0';
    signal i_detergent : std_logic := '0';
    signal i_door_closed : std_logic := '0';
    signal i_wl_max : std_logic := '0';
    signal i_hw : std_logic_vector(1 downto 0) := "00";
    signal i_temp_ok : std_logic := '0';
    signal i_wl_min : std_logic := '0';
    signal i_door_open : std_logic := '0';
    signal o_lock : std_logic := '0';
    signal o_valve_in : std_logic := '0';
    signal o_heater : std_logic := '0';
    signal o_motor_run : std_logic_vector(1 downto 0) := "00";
    signal o_valve_out : std_logic := '0';
    signal o_pump_out : std_logic := '0';

begin

    -- uut
    uut: aut port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_run => i_run,
        i_water => i_water,
        i_detergent => i_detergent,
        i_door_closed => i_door_closed,
        i_wl_max => i_wl_max,
        i_hw => i_hw,
        i_temp_ok => i_temp_ok,
        i_wl_min => i_wl_min,
        i_door_open => i_door_open,
        o_lock => o_lock,
        o_valve_in => o_valve_in,
        o_heater => o_heater,
        o_motor_run => o_motor_run,
        o_valve_out => o_valve_out,
        o_pump_out => o_pump_out
    );

    -- clock process
    process begin
        i_clk <= '1';
        wait for i_clk_period / 2;
        i_clk <= '0';
        wait for i_clk_period / 2;
    end process;

    -- stimulus process
    -- nakon puštanja simulacije i provere, na nekim mestima sam korigovao trajanje ulaza za 1 takt da bi trajanje stanja bilo tačno prema specifikaciji zadatka
    process begin
        i_rst <= '1';
        wait for 5.25 * i_clk_period;
        i_rst <= '0';

        -- prvi ciklus
        i_run <= '1';
        i_water <= '1';
        i_detergent <= '1';
        i_door_closed <= '1';
        wait for i_clk_period;

        i_run <= '0';
        i_water <= '0';
        i_detergent <= '0';
        i_door_closed <= '0';
        wait for 9 * i_clk_period;
        i_wl_max <= '1';
        i_hw <= "00";
        wait for i_clk_period;       -- 9 taktova ništa i posle 10. takta prelaz u S_COLD_W

        i_wl_max <= '0';
        wait for 9 * i_clk_period;
        i_temp_ok <= '1';
        wait for i_clk_period;       -- 9 taktova ništa i posle 10. takta prelaz u S_WASHING

        i_temp_ok <= '0';
        wait for 60 * i_clk_period;  -- 51 takt u S_WASHING (jer brojač broji od 50 do 0), 9 taktova ništa (dok je u S_WATER_OUT)
        i_wl_min <= '1';
        wait for i_clk_period;       -- u 10. taktu u S_WATER_OUT, aktiviramo prelaz u S_CENTRIFUGA

        i_wl_min <= '0';
        wait for 21 * i_clk_period;  -- čekamo 21 takt u S_CENTRIFUGA (jer brojač broji od 20 do 0)
        i_door_open <= '1';
        wait for i_clk_period;       -- aktiviramo prelaz u S_IDLE
        i_door_open <= '0';

        -- drugi ciklus
        i_run <= '1';
        i_water <= '1';
        i_detergent <= '1';
        i_door_closed <= '1';
        wait for i_clk_period;

        i_run <= '0';
        i_water <= '0';
        i_detergent <= '0';
        i_door_closed <= '0';
        wait for 9 * i_clk_period;
        i_wl_max <= '1';
        i_hw <= "01";
        wait for i_clk_period;       -- 9 taktova ništa i posle 10. takta prelaz u S_COLD_W

        i_wl_max <= '0';
        wait for 9 * i_clk_period;
        i_temp_ok <= '1';
        wait for i_clk_period;       -- 9 taktova ništa i posle 10. takta prelaz u S_WASHING

        i_temp_ok <= '0';
        wait for 60 * i_clk_period;  -- 51 takt u S_WASHING (broji od 50 do 0), 9 taktova ništa (dok je u S_WATER_OUT)
        i_wl_min <= '1';
        wait for i_clk_period;       -- u 10. taktu u S_WATER_OUT, aktiviramo prelaz u S_CENTRIFUGA

        i_wl_min <= '0';
        wait for 21 * i_clk_period;  -- čekamo 21 takt u S_CENTRIFUGA (broji od 20 do 0)
        i_door_open <= '1';
        wait for i_clk_period;       -- aktiviramo prelaz u S_IDLE
        i_door_open <= '0';

        -- treci ciklus
        i_run <= '1';
        i_water <= '1';
        i_detergent <= '1';
        i_door_closed <= '1';
        wait for i_clk_period;

        i_run <= '0';
        i_water <= '0';
        i_detergent <= '0';
        i_door_closed <= '0';
        wait for 9 * i_clk_period;
        i_wl_max <= '1';
        i_hw <= "10";
        wait for i_clk_period;       -- 9 taktova ništa i posle 10. takta prelaz u S_COLD_W

        i_wl_max <= '0';
        wait for 9 * i_clk_period;
        i_temp_ok <= '1';
        wait for i_clk_period;       -- 9 taktova ništa i posle 10. takta prelaz u S_WASHING

        i_temp_ok <= '0';
        wait for 60 * i_clk_period;  -- 51 takt u S_WASHING (broji od 50 do 0), 9 taktova ništa (dok je u S_WATER_OUT)
        i_wl_min <= '1';
        wait for i_clk_period;       -- u 10. taktu u S_WATER_OUT, aktiviramo prelaz u S_CENTRIFUGA

        i_wl_min <= '0';
        wait for 21 * i_clk_period;  -- čekamo 21 takt u S_CENTRIFUGA (broji od 20 do 0)
        i_door_open <= '1';
        wait for i_clk_period;       -- aktiviramo prelaz u S_IDLE
        i_door_open <= '0';

        wait;
    end process;

end behavioral;