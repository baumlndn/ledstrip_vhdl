library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

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
type STATES is (CLKSYNC,IDLE,START,SYNC,B1,B2,B3,B4,B5,B6,B7,STOP);
type SYNCSTATES is (IDLE,STRT,S1,S2,S3,S4,S5,S6,S7,S8,EVAL);
type SYNCARY is array(0 to 8) of integer range 0 to 1023;
signal sm_state : STATES := CLKSYNC;
signal sync_state : SYNCSTATES := IDLE;
signal synctimes : SYNCARY;
signal data_received : std_logic_vector(7 downto 0) := (others => '0');
begin

	process (clock)
	variable sm_counter : integer range 0 to 1023;
	variable sm_reference : integer range 0 to 9207; -- 9*1023
	variable sm_halfref : integer range 0 to 511;
	begin
		if clock'event and clock='1' then
			if enable = '1' then
				case sm_state is 
					when CLKSYNC =>
						case sync_state is
							when IDLE =>
								if data_in = '0' then
									sync_state <= STRT;
								end if;
							when STRT =>
								if data_in = '0' then
									synctimes(0) <= synctimes(0)+1;
								else
									sync_state <= S1;
								end if;
							when S1 =>
								if data_in = '1' then
									synctimes(1) <= synctimes(1)+1;
								else
									sync_state <= S2;
								end if;
							when S2 =>
								if data_in = '0' then
									synctimes(2) <= synctimes(2)+1;
								else
									sync_state <= S3;
								end if;
							when S3 =>
								if data_in = '1' then
									synctimes(3) <= synctimes(3)+1;
								else
									sync_state <= S4;
								end if;
							when S4 =>
								if data_in = '0' then
									synctimes(4) <= synctimes(4)+1;
								else
									sync_state <= S5;
								end if;
							when S5 =>
								if data_in = '1' then
									synctimes(5) <= synctimes(5)+1;
								else
									sync_state <= S6;
								end if;
							when S6 =>
								if data_in = '0' then
									synctimes(6) <= synctimes(6)+1;
								else
									sync_state <= S7;
								end if;
							when S7 =>
								if data_in = '1' then
									synctimes(7) <= synctimes(7)+1;
								else
									sync_state <= S8;
								end if;
							when S8 =>
								if data_in = '0' then
									synctimes(8) <= synctimes(8)+1;
								else
									sync_state <= EVAL;
								end if;
							when EVAL =>
								sm_reference := (synctimes(0) + synctimes (1) + 
									synctimes(2) + synctimes(3) + synctimes(4) +
									synctimes(5) + synctimes(6) + synctimes(7));
								sm_reference := to_Integer(to_Unsigned(sm_reference,15) srl 3);	
								sm_halfref :=  to_Integer(to_Unsigned(sm_reference,10) srl 1);
								sm_state <= IDLE;
							when others =>
						end case;							
					when IDLE => 
						if data_in = '0' then
							sm_counter := 0;
							sm_state <= START;
						end if;
					when START =>
						if sm_counter = sm_halfref then
							sm_counter := 0;
							sm_state <= SYNC;
						else
							sm_counter := sm_counter + 1;
						end if;
					when SYNC =>
						if sm_counter = sm_reference then
							data_received(0) <= data_in;
							sm_state <= B1;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B1 => 
						if sm_counter = sm_reference then
							data_received(1) <= data_in;
							sm_state <= B2;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B2 => 
						if sm_counter = sm_reference then
							data_received(2) <= data_in;
							sm_state <= B3;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B3 => 
						if sm_counter = sm_reference then
							data_received(3) <= data_in;
							sm_state <= B4;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B4 => 
						if sm_counter = sm_reference then
							data_received(4) <= data_in;
							sm_state <= B5;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B5 => 
						if sm_counter = sm_reference then
							data_received(5) <= data_in;
							sm_state <= B6;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B6 => 
						if sm_counter = sm_reference then
							data_received(6) <= data_in;
							sm_state <= B7;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when B7 => 
						if sm_counter = sm_reference then
							data_received(7) <= data_in;
							sm_state <= STOP;
							sm_counter := 0;
						else
							sm_counter := sm_counter + 1;
						end if;
					when STOP =>
						if sm_counter = (sm_halfref-1) then
							data_ready <= '1';
						end if;
						if sm_counter = sm_halfref then
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
--				sm_state <= IDLE;
			end if;
		end if;
	end process;

	data_out <= data_received;	
	
end behv;