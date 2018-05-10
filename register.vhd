library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_block is
  port(
	clk	   : in std_logic;
	read_add_a : in std_logic_vector(2 downto 0);
	read_add_b : in std_logic_vector(2 downto 0);
	write_en   : in std_logic;
	write_val  : in std_logic_vector(15 downto 0);
	write_add  : in std_logic_vector(2 downto 0);
	write_stackVal: in std_logic_vector(15 downto 0);
	write_stackEn : in std_logic;
	rega, regb : out std_logic_vector(15 downto 0);
	read_STACK : out std_logic_vector(15 downto 0)
  );
end register_block;

architecture register_block_a of register_block is
	constant SPintializtion : std_logic_vector(15 downto 0):="0000001111111111";
	constant PC_add : std_logic_vector (read_add_a'range) := (others=>'1');
	constant STACK_add:  std_logic_vector (read_add_a'range) := PC_add(2 downto 1)&'0';
   	type regBank is array (0 to 6) of std_logic_vector (15 downto 0);
	signal regBank0 : regBank := ((others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),SPintializtion);
begin
    -- asynchronous read
    rega <= regbank0(to_integer(unsigned(read_add_a)));
    regb <= regbank0(to_integer(unsigned(read_add_b)));
    read_STACK <= regbank0(to_integer(unsigned(STACK_add)));
    process (clk) is
    begin 
        if rising_edge(clk) then
            if (write_en = '1') then
                regbank0(to_integer(unsigned(write_add))) <= write_val;
            end if;
	if (write_stackEn = '1') then
                regbank0(to_integer(unsigned(STACK_add))) <= write_stackVal;
            end if;

        end if;
    end process;
end architecture register_block_a; 
