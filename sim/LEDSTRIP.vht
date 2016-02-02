-- Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Altera and sold by Altera or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "01/19/2016 21:04:35"
                                                            
-- Vhdl Test Bench template for design  :  LEDSTRIP
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY LEDSTRIP_vhd_tst IS
END LEDSTRIP_vhd_tst;
ARCHITECTURE LEDSTRIP_arch OF LEDSTRIP_vhd_tst IS
-- constants
constant clk_period : time := 20 ps;                                                 
-- signals                                                   
SIGNAL clock : STD_LOGIC := '0';
SIGNAL data_in : STD_LOGIC;
SIGNAL data_out : STD_LOGIC;
COMPONENT LEDSTRIP
	PORT (
	clk_in : IN STD_LOGIC;
	data_in : IN STD_LOGIC;
	data_out : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : LEDSTRIP
	PORT MAP (
-- list connections between master ports and signals
	clk_in => clock,
	data_in => data_in,
	data_out => data_out
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations 
procedure sendByte(constant x : std_logic_vector(7 downto 0)) is
begin
	data_in <= '0';
	wait for 10 ns;

	for a in 0 to 7 loop
		data_in <= x(a);
		wait for 10 ns;
	end loop;
	
	data_in <= '1';
	wait for 10 ns;	
end procedure;                                     
BEGIN    
	wait for 10 ns;
	-- Syncbyte
	sendByte("01010101");
	-- No of LEDs
	sendByte("00000010");
	-- First LED
	sendByte("10101010");
	sendByte("11111111");
	sendByte("00001100");
	-- Second LED
	sendByte("01010101");
	sendByte("11001100");
	sendByte("00001111");
        -- code executes for every event on sensitivity list  
WAIT;                                                        
END PROCESS always;    

clock_proc : PROCESS
BEGIN
	clock <= '1';
	wait for clk_period/2;
	clock <= '0';
	wait for clk_period/2;
END PROCESS clock_proc;
                                      
END LEDSTRIP_arch;
