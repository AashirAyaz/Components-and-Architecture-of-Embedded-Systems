----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:37:21 06/15/2017 
-- Design Name: 
-- Module Name:    fulladder - Behavioral 
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

entity full_adder is
port (a: in std_logic;
      b: in std_logic;
		carry_in: in std_logic;
		sum:out std_logic;
		carry:out std_logic);
end full_adder;

architecture Behavioral of full_adder is

	  
signal sum1,sum2,carry1,carry2: std_logic;

component half_adder is 
port(a:in std_logic;
     b: in std_logic;
	  sum: out std_logic;
	  carry: out std_logic
	  );
	  end component;
	  
 

begin
ha1:half_adder port map(a=>a,b=>b,sum=>sum1,carry=>carry1);
ha2:half_adder port map (a=>sum1,b=>carry_in,sum=>sum2,carry=>carry2);
 
carry<=carry1	or carry2;

sum<=sum2;				  


end Behavioral;



