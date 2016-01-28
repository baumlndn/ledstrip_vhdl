library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mytypes.all;

-------------------------------------------------

entity MEM is
port(	data_in:		in  	led_data;
		data_out:	out	led_data;
		address:		in		std_logic_vector(7 downto 0);
		write_en:	in		std_logic;
		clk: 			in 	std_logic
);
end MEM;

-------------------------------------------------

architecture behv of MEM is

type mem is array(0 to 255) of led_data;
signal fifo_data : mem := (others => (others => '0'));

begin

process (clk)
begin
	if clk'event and clk = '1' then
		if write_en = '1' then
			fifo_data(to_integer(unsigned(address))) <= data_in;
		else
			data_out <= fifo_data(to_integer(unsigned(address)));
		end if;
	end if;
end process;

end behv;