----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:11:00 05/19/2017 
-- Design Name: 
-- Module Name:    fourbitsubtractor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity fourbitsubtractor  is
    Port ( a : in  std_logic_vector (3 downto 0) ;
           b : in std_logic_vector (3 downto 0);
           c1 : in  STD_LOGIC;
           sum : out std_logic_vector (3 downto 0);
			  cout : out  STD_LOGIC);
end fourbitsubtractor;

architecture Behavioral of fourbitsubtractor is

component full_adder
port (a: in std_logic;
      b: in std_logic;
		carry_in: in std_logic;
		sum:out std_logic;
		carry:out std_logic);
end component;
signal c: std_logic_vector (2 downto 0);
signal b_not0,b_not1,b_not2,b_not3 : std_logic;
signal c1_sig:std_logic:='1';

begin

b_not0<= not b(0);
b_not1<= not b(1);
b_not2<= not b(2);
b_not3<= not b(3);


fa1: full_adder port map(a(0),b_not0,c1_sig,sum(0),c(0));
fa2: full_adder port map(a(1),b_not1,c(0),sum(1),c(1));
fa3: full_adder port map(a(2),b_not2,c(1),sum(2),c(2));
fa4: full_adder port map(a(3),b_not3,c(2),sum(3),cout);
c1_sig<=c1;




end Behavioral;

