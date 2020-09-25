----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:57:22 05/09/2017 
-- Design Name: 
-- Module Name:    fourbitmultiplier - Behavioral 
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

entity fourbitmultiplier is
port (a: in std_logic_vector (3 downto 0);
      b: in std_logic_vector (3 downto 0);
		p: out std_logic_vector (7 downto 0));
		
end fourbitmultiplier;
architecture behavioral of   fourbitmultiplier is

component fourbitadder 
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0);
           b : in  STD_LOGIC_VECTOR (3 downto 0);
           c1 : in  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (3 downto 0);
           cout : out  STD_LOGIC);

end component ;
signal c: std_logic_vector (7 downto 0);
signal d: std_logic_vector (7 downto 0);
signal e: std_logic_vector (7 downto 0);
signal c2: std_logic  ;
signal p_sig : std_logic_vector (7 downto 0);

begin
c2<='0';
f1: fourbitadder port map (a=>c(7  downto 4) ,b=>c(3 downto 0) ,c1=>c2,sum(0)=>p_sig(1) ,sum(3 downto 1)=> d(2 downto 0),cout=>d(3));
f2: fourbitadder port map (a=>d(7 downto 4),b=>d(3 downto 0),c1=>c2,sum(0)=>p_sig(2),sum(3 downto 1)=>e(2 downto 0),cout=>e(3));
f3: fourbitadder port map (a=>e(7 downto 4),b=>e(3 downto 0),c1=>c2,sum(0)=>p_sig(3),sum( 3 downto 1)=>p_sig(6 downto 4),cout=>p_sig(7));
p_sig(0)<= a(0) and b(0);

p<=p_sig;

c(0)<=a(0)and b(1);     c(4)<=a(1)and b(0);
c(1)<=a(0)and b(2);     c(5)<=a(1)and b(1);
c(2)<=a(0)and b(3);     c(6)<=a(1)and b(2);
c(3)<='0';              c(7)<=a(1)and b(3);

d(4)<=a(2) and b(0);    e(4)<=a(3) and b(0);
d(5)<=a(2) and b(1);    e(5)<=a(3) and b(1);
d(6)<=a(2) and b(2);    e(6)<=a(3) and b(2);
d(7)<=a(2) and b(3);    e(7)<=a(3) and b(3);


end Behavioral;

