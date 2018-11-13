library verilog;
use verilog.vl_types.all;
entity kung_adder is
    port(
        sum             : out    vl_logic_vector(15 downto 0);
        carry_out       : out    vl_logic;
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0);
        cin             : in     vl_logic
    );
end kung_adder;
