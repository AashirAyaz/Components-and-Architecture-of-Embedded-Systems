
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:26:11 06/12/2017 
-- Design Name: 
-- Module Name:    ALU_E - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.all;
--use ieee.numeric_std_unsigned;


-- Entity for ALU component
-- Use this Entity for your C&A project 2017
-- Other toplevel entities will not be accepted

-- Authors: 	sohaib arif, 454364
--		aashir ayaz, 448046

ENTITY ALU_E IS
  PORT(
    reset_n     : in std_logic;
    clk         : in std_logic;
    OperandA    : in std_logic_vector(3 downto 0);
    OperandB    : in std_logic_vector(3 downto 0);
    Operation   : in std_logic_vector(2 downto 0);
    Go          : in std_logic;
    Result_Low	: out std_logic_vector(3 downto 0);
    Result_High	: out std_logic_vector(3 downto 0);
    Completed	: out std_logic;
    Errorsig	: out std_Logic);
END ALU_E;

architecture Behavioral_ALU of ALU_E is 
signal add_result_low,sub_result_low: std_logic_vector(3 downto 0);
signal mult_result_low,mult_result_high,div_result_low,div_result_high: std_logic_vector(3 downto 0);
signal add_cout,sub_neg: std_logic;
signal completed_in, completed_in2,Error_in: std_logic := '0';
signal i_result_low, i_result_high : std_logic_vector(3 downto 0);
signal divider_done:std_logic;
signal divider_go:std_logic:='0';
signal divider_op:std_logic:='0';
component fourbitadder is                                     --4-bit adder
    Port ( a : in  std_logic_vector (3 downto 0) ;
           b : in std_logic_vector (3 downto 0);
           c1 : in  STD_LOGIC;
           sum : out std_logic_vector (3 downto 0);
			  cout : out  STD_LOGIC);
end component;

component fourbitsubtractor  is
    Port ( a : in  std_logic_vector (3 downto 0) ;
           b : in std_logic_vector (3 downto 0);
           c1 : in  STD_LOGIC;
           sum : out std_logic_vector (3 downto 0);
			  cout : out  STD_LOGIC);
end component;

component fourbitmultiplier is
port (a: in std_logic_vector (3 downto 0);
      b: in std_logic_vector (3 downto 0);
		p: out std_logic_vector (7 downto 0));
		
end component;

component fourbitdivider is
port(a:in std_logic_vector(3 downto 0);
     b:in std_logic_vector(3 downto 0);
	  start:in std_logic ;
	  clk : in std_logic;
          completed:out std_logic;
	  quotient:out std_logic_vector(3 downto 0);
	  r:out std_logic_vector (3 downto 0));
	  

end component;

begin
--completed<=completed_in;
divider_go<=go when go='1' and operation="111" else '0';

Result_Low<=i_result_low;
Result_high<=i_result_high;

process(operation,error_in,OperandB)
begin
   errorsig<='0';
   if operation="101" then
	   errorsig<=error_in ;
	elsif operation="111" then
	      if OperandB="0000" then
			   errorsig<='1';
			end if;
	end if;
end process;


add1: fourbitadder port map(a=>OperandA,b=>OperandB,c1=>'0',sum=>add_result_low,cout=>add_cout);

sub2: fourbitsubtractor port map(a=>OperandA,b=>OperandB,c1=>'1',sum=>sub_result_low,cout=>sub_neg);

mul3: fourbitmultiplier port map(a=>OperandA, b=>OperandB,p(7 downto 4)=>mult_result_high ,p(3 downto 0)=>mult_result_low);

div4: fourbitdivider port map (a=>OperandA,b=>Operandb,start=>divider_go,clk=>clk,completed=>divider_done,quotient=>div_result_high,r=>div_result_low);

 process(reset_n,CLK)
variable temp1: std_logic_vector (3 downto 0);
variable temp2:std_logic_vector (3 downto 0);
variable l_shift:std_logic_vector (7 downto 0);
variable r_shift:std_logic_vector (7 downto 0);
variable tmpbit: std_logic;
variable tmp: integer range 0 to 255;

	  BEGIN
    		IF reset_n = '0' THEN
			   i_result_Low <="0000";
			   i_Result_High <="0000";
			   Error_in <= '0';
				divider_op<='0';
			elsif rising_edge(clk) then
			completed_in<='0';
			 completed<=completed_in;
			 Error_in <= '0';
			if (go='1' or divider_op='1' ) then
						case operation is 
			
			
			when "001" =>
			i_result_low<=OperandA xnor OperandB;
			i_result_high<="0000";
			error_in<='0';
			completed<='1';
			completed_in<='1';
			when "010" => 
                        temp1:="0000";
                        temp2:=operanda;                        
                        l_shift := temp1 & temp2;
                        if (operandb(3)='0') then -- left shift 
          		
                        for i in 1 to to_integer(unsigned(operandb(2 downto 0))) loop
                        
                        l_shift(7 downto 0) := l_shift(6 downto 0) & '0';
                        
                        end loop;
                        i_result_low<=l_shift(3 downto 0);
                         i_result_high<=l_shift(7 downto 4);
                        error_in<='0';
                        
                        else 

                        for i in 1 to to_integer(unsigned(operandb(2 downto 0))) loop -- left rotation
                        tmpbit:=temp1(3);
                        
                        l_shift(7 downto 0) := l_shift(6 downto 0) & l_shift(7);
                        
                        end loop;
                         i_result_low<=l_shift(3 downto 0);
                         i_result_high<=l_shift(7 downto 4);
                        error_in<='0';
							
								end if;
                 				completed<='1';
			                 completed_in<='1';
                      

			when "011" =>	
                        temp1:="0000";
                        temp2:=operanda;
			if (operandb(3)='0') then 
                        
                        r_shift:=temp1 & temp2;                        
                        for i in 1 to to_integer(unsigned(operandb(2 downto 0))) loop  --shift right
                      
                        r_shift(7 downto 0):='0' & r_shift(7 downto 1);
                        
                        end loop;
                        i_result_low<=r_shift(3 downto 0);
                         i_result_high<=r_shift(7 downto 4);
                        error_in<='0';
                       
                        elsif(operandb(3) /='0') then 
                        for i in 1 to to_integer(unsigned(operandb(2 downto 0))) loop  --right rotation
                        tmpbit:=temp2(0);
                        temp2:=temp1(0)& temp2(3 downto 1);
                        temp1:=tmpbit & temp1(3 downto 1);
                        
                       
                        end loop;
                        i_result_low<=temp2;
                        i_result_high<=temp1;
                        
                        error_in<='0';
                        end if;
			
                 				completed<='1';
			                 completed_in<='1';
			
			when "100" =>
							i_result_low <= add_result_low;
							i_result_high(0) <= add_cout;
							error_in <= '0';
							completed<='1';
							completed_in<='1';
						
			when "101" =>
							i_result_low<=sub_result_low;
							-- for error in sig we need to do 
							error_in <=not sub_neg;
							completed<='1';
							completed_in<='1';
	
			when "110" =>
							i_result_low<=mult_result_low;
							i_result_high<=mult_result_high;
							error_in<='0';
							completed<='1';
							completed_in<='1';
						
			when "111"=>
			   divider_op<='1';
				completed<=divider_done;
            completed_in<=divider_done;             
			
  			i_result_high <= div_result_high; 	 
  			i_result_high <= div_result_high; 	 
			i_result_low <= div_result_low;
			
         
			
			
			
			when others=>
			
null;
			
			end case;
			

				
		    end if;	
			end if;		
	end process;

			
			
			
			
		
end Behavioral_ALU;




