library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity WS2811_BIT_ENCODER is
port(	I:	in  std_logic;
		O:	out std_logic_vector(9 downto 0)
);
end WS2811_BIT_ENCODER;

-------------------------------------------------

architecture behv of WS2811_BIT_ENCODER is
begin

	process (I)
	begin

		if (I='1') then
			O <= "1111100000";
		else
			O <= "1100000000";
		end if;
	
	end process;
	
end behv;