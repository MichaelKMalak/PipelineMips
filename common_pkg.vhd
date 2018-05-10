library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package common_pkg is
    subtype word is std_logic_vector(15 downto 0);
    subtype address_size is std_logic_vector(9 downto 0);
    subtype ALUflags is std_logic_vector(3 downto 0);
    subtype regAddr is std_logic_vector (2 downto 0);
    subtype opcode is std_logic_vector(4 downto 0);

end package common_pkg;

