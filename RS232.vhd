library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity RS232 is
port(	enable:		in  	std_logic;
		clock: 		in 	std_logic;
		data_in:		in		std_logic;
		data_out:	out 	std_logic_vector(7 downto 0);
		data_ready: out	std_logic
);
end RS232;

-------------------------------------------------

architecture behv of RS232 is
type STATES is (IDLE,START,SYNC,B1,B2,B3,B4,B5,B6,B7,STOP);
signal sm_state : STATES := IDLE;
signal sm_init : std_logic := '0';
signal data_received : std_logic_vector(7 downto 0) := (others => '0');
begin

	process (clock)
	variable sm_counter : integer range 0 to 833;
	begin
		if clock'event and clock='1' then
			if enable = '1' then
				case sm_state is 
					when IDLE => 
						if data_in = '0' then
							sm_counter := 0;
							sm_state <= START;
							sm_init <= '1';
						end if;
					when START =>
						if sm_counter = 416 then
							sm_counter := 0;
							sm_state <= SYNC;
						else
							sm_counter := sm_counter + 1;
						end if;
					when SYNC =>
						if sm_counter = 833 then
							data_received(0) <= data_in;
							sm_state <= B1;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B1 => 
						if sm_counter = 833 then
							data_received(1) <= data_in;
							sm_state <= B2;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B2 => 
						if sm_counter = 833 then
							data_received(2) <= data_in;
							sm_state <= B3;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B3 => 
						if sm_counter = 833 then
							data_received(3) <= data_in;
							sm_state <= B4;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B4 => 
						if sm_counter = 833 then
							data_received(4) <= data_in;
							sm_state <= B5;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B5 => 
						if sm_counter = 833 then
							data_received(5) <= data_in;
							sm_state <= B6;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B6 => 
						if sm_counter = 833 then
							data_received(6) <= data_in;
							sm_state <= B7;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B7 => 
						if sm_counter = 833 then
							data_received(7) <= data_in;
							sm_state <= STOP;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when STOP =>
						if sm_counter = 415 then
							data_ready <= '1';
						end if;
						if sm_counter = 416 then
							if data_in = '1' then
								sm_state <= IDLE;
								sm_counter := 0;
								data_ready <= '0';
							end if;
						else
								sm_counter := sm_counter + 1;
						end if;
					when others =>
						sm_state <= IDLE;
				end case;
			else
				sm_state <= IDLE;
			end if;
		end if;
	end process;

	data_out <= data_received;	
	
end behv;