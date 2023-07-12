library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity aut is port (
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
end aut;

architecture behavioral of aut is

    signal s_w_timer_elapsed : std_logic;
    signal s_c_timer_elapsed : std_logic;
    signal s_w_init : std_logic;
    signal s_c_init : std_logic;
    signal s_clr_w_c : std_logic;

    type t_state is (S_IDLE, S_WATER_IN, S_COLD_W, S_WARM_W, S_HOT_W, S_WASHING, S_WATER_OUT, S_CENTRIFUGA, S_WAIT);
    signal s_state : t_state;
    signal s_next_state : t_state;
    signal s_control : std_logic_vector(9 downto 0);

    signal s_w_timer : std_logic_vector(5 downto 0);
    signal s_c_timer : std_logic_vector(4 downto 0);
    
begin

    -- automat funkcija prelaza
    process (i_run, i_water, i_detergent, i_door_closed, i_wl_max, i_hw, i_temp_ok, s_w_timer_elapsed, i_wl_min, s_c_timer_elapsed, i_door_open, s_state) begin
        case (s_state) is
            when S_IDLE =>
                if (i_run = '1' and i_water = '1' and i_detergent = '1' and i_door_closed = '1') then
                    s_next_state <= S_WATER_IN;
                else
                    s_next_state <= S_IDLE;
                end if;
            when S_WATER_IN =>
                if (i_wl_max = '1') then
                    case (i_hw) is
                        when "00" => s_next_state <= S_COLD_W;
                        when "01" => s_next_state <= S_WARM_W;
                        when others => s_next_state <= S_HOT_W;
                    end case;
                else
                    s_next_state <= S_WATER_IN;
                end if;
            when S_COLD_W =>
                if (i_temp_ok = '1') then
                    s_next_state <= S_WASHING;
                else
                    s_next_state <= S_COLD_W;
                end if;
            when S_WARM_W =>
                if (i_temp_ok = '1') then
                    s_next_state <= S_WASHING;
                else
                    s_next_state <= S_WARM_W;
                end if;
            when S_HOT_W =>
                if (i_temp_ok = '1') then
                    s_next_state <= S_WASHING;
                else
                    s_next_state <= S_HOT_W;
                end if;
            when S_WASHING =>
                if (s_w_timer_elapsed = '1') then
                    s_next_state <= S_WATER_OUT;
                else
                    s_next_state <= S_WASHING;
                end if;
            when S_WATER_OUT =>
                if (i_wl_min = '1') then
                    s_next_state <= S_CENTRIFUGA;
                else
                    s_next_state <= S_WATER_OUT;
                end if;
            when S_CENTRIFUGA =>
                if (s_c_timer_elapsed = '1') then
                    s_next_state <= S_WAIT;
                else
                    s_next_state <= S_CENTRIFUGA;
                end if;
            when S_WAIT =>
                if (i_door_open = '1') then
                    s_next_state <= S_IDLE;
                else
                    s_next_state <= S_WAIT;
                end if;
            when others =>
                s_next_state <= S_IDLE;
        end case;
    end process;

    -- automat registar
    process (i_clk, i_rst) begin
        if (i_rst = '1') then
            s_state <= S_IDLE;
        elsif (i_clk'event and i_clk = '1') then
            s_state <= s_next_state;
        end if;
    end process;

    -- automat funkcija izlaza
    o_lock <= s_control(9);
    o_valve_in <= s_control(8);
    o_heater <= s_control(7);
    o_motor_run <= s_control(6 downto 5);
    o_valve_out <= s_control(4);
    o_pump_out <= s_control(3);
    s_w_init <= s_control(2);
    s_c_init <= s_control(1);
    s_clr_w_c <= s_control(0);

    process (s_state) begin
        case (s_state) is
            when S_IDLE => s_control <= "0000000001";
            when S_WATER_IN => s_control <= "1100000000";
            when S_COLD_W => s_control <= "1000000000";
            when S_WARM_W => s_control <= "1010000000";
            when S_HOT_W => s_control <= "1010000000";
            when S_WASHING => s_control <= "1000100100";
            when S_WATER_OUT => s_control <= "1000011000";
            when S_CENTRIFUGA => s_control <= "1001011010";
            when S_WAIT => s_control <= "0000000000";
            when others => s_control <= "0000000000";
        end case;
    end process;

    -- w_timer
    process (i_clk, i_rst) begin
        if (i_rst = '1') then
            s_w_timer <= "110010";
        elsif (i_clk'event and i_clk = '1') then
            if (s_clr_w_c = '1') then
                s_w_timer <= "110010";
            elsif (s_w_init = '1') then
                s_w_timer <= s_w_timer - 1;
            end if;
        end if;
    end process;

    s_w_timer_elapsed <= '1' when s_w_timer = 0 else '0';

    -- c_timer
    process (i_clk, i_rst) begin
        if (i_rst = '1') then
            s_c_timer <= "10100";
        elsif (i_clk'event and i_clk = '1') then
            if (s_clr_w_c = '1') then
                s_c_timer <= "10100";
            elsif (s_c_init = '1') then
                s_c_timer <= s_c_timer - 1;
            end if;
        end if;
    end process;

    s_c_timer_elapsed <= '1' when s_c_timer = 0 else '0';

end behavioral;
