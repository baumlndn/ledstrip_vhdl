library ieee ;
use ieee.std_logic_1164.all;

---------------------------------------------------

entity WS2811_OUTPUT is
port(	
	data_in:		in std_logic_vector(239 downto 0);
	data_out:	out std_logic;
	clock:		in std_logic;
	enable:		in std_logic;
	trans_done: 	out std_logic
);
end WS2811_OUTPUT;

---------------------------------------------------

architecture behv of WS2811_OUTPUT is

	signal S: std_logic_vector(239 downto 0) := (others => '0');
	constant ALL_ZERO : std_logic_vector(239 downto 0) := (others => '0');
	type STATES is (WAITING,RUNNING,DONE);
	signal sm_state : STATES := WAITING;
begin

	process(clock)
	begin

	-- everything happens upon the clock changing
		if clock'event and clock='1' then
			case sm_state is
				when WAITING =>
					if enable = '1' then
						S <= data_in;
						sm_state <= RUNNING;
					end if;
				when RUNNING =>
					if S = ALL_ZERO then
						sm_state <= DONE;
					else
						S <= S(238 downto 0) & '0';
					end if;
				when DONE =>
					if enable = '0' then
						sm_state <= WAITING;
					end if;
			end case;
		end if;

	end process;
	
	-- concurrent assignment
	data_out <= S(239);	
	trans_done <= '1' when sm_state = DONE else '0';

end behv;

----------------------------------------------------
