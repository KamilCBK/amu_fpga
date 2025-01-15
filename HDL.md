# Wprowadzenie do języków opisu sprzętu - VHDL

Języki opisu sprzętu na pierwszy rzut oka mogą w składni przypominać 
klasyczne języki programowania jak C czy Basic (będę też zazwyczaj wspierać
konstrukty pozwalająca na opis procedury realizującej algorytm matematyczny,
czy dostęp do plików). Ważna jest jednak świadomość, że nie do tego zostały 
stworzone i głównym ich zadaniem jest opisanie sprzetu zgodnie z intencjami 
projektanta. 

Sam opis może zostać zrealizowany na różnych poziomie abstrakcji. Przykładowo
operacja dodawania może zostać opisana bezpośrednio na bramkach logicznych 
(n-bitowy ciąg XOR) lub przy użyciu operatora `+` działającego na wektorach 
bitowych. 

`Verilog` (plus `SystemVerilog`) oraz `VHDL` są najczęściej używanymi jezykami 
opisu sprzętu. Często są też jednymi wspieranymi przez narzędzia dostarczone
przez producenta układu FPGA. Zarówno Verilog jak i HDL doczekały się
wersji (rozwinięcia) z dopiskiem `-AMS`: odpowiednio `Verilog-AMS`, `VHDL-AMS`. 
Rozwinięcie AMS - Analog and Mixed Signals. Na potrzeby zajęć skupimy się 
na wersjach podstawowych, ponieważ nie będziemy pracować jedynie z układami 
cyfrowymi możliwymi do realizacji w standardowych układach FPGA.

# Dwuelementowa Algebra Boola
Dwuelementowa algebra Boola to specjalny typ ogólne Algebry Boola, która 
ma tylko dwa elementy `0` oraz `1`. Wartości `0` oraz `1` można określić 
jako stany logiczne, `0` - logiczne zero/fałsz, `1` - liczna jedynka/prawda.
Układy cyfrowe, w których podstawowe układy są układami przełączającymi 
pomiędzy stanami niskiego oraz wysokiego napięcia (przykładowo logika 
CMOS) można łatwo powiązać do dwuelementowej algebry Boola i sprowadzić 
projektowanie do opisu algorytmów realizowanych w tej algebrze.

Grafika poniżej przedstawia zestaw podstawowych komórek logiki Bool'a. 
Używając tylko tych elementów jesteśmy w stanie zrealizować bardzo skomplikowane 
operacje, przykładowo mnożenie wielo-bitowych wektorów. 

![cnt_logic](img/logic_gates.svg "Komórki logiczne.")

Tablica prawdy dla komórki OR:
| In_A | in_B | Out |
|------|------|-----|
| 0    | 0    | 0   |
| 0    | 1    | 1   |
| 1    | 0    | 1   |
| 1    | 1    | 1   |

Tablica prawdy dla komórki AND:
| In_A | in_B | Out |
|------|------|-----|
| 0    | 0    | 0   |
| 0    | 1    | 0   |
| 1    | 0    | 0   |
| 1    | 1    | 1   |

Tablica prawdy dla komórki XOR:
| In_A | in_B | Out |
|------|------|-----|
| 0    | 0    | 0   |
| 0    | 1    | 1   |
| 1    | 0    | 1   |
| 1    | 1    | 0   |

# Logika kombinacyjna
Logika kombinacyjna to taka, której stan (na wyjściu) zależy jedynie 
od stanu na wejściu. Wszystkie bramki logiki Boola (oraz ich dowolne, 
nawet wieloelementowe kombinacje) będą zaliczone do logiki kombinacyjnej.

Bloki, dalej uważane za podstawowe, które można zrealizować na używając
podstawowych komórek z logiki boola:

    - komutatory:
        * multiplexery (N:1, N - wejście -> 1 wyjście)
        * demultiplexer (1:N, 1 - wejście -> 1 z N wyjście)
    - dekodery, kodery
    - bloki arytmetyczne:
        * sumatory
        * komparatory
        * inne

# Logika sekwencyjna
Logika sekwencyjna to taka, której stan (na wyjściu) zależy od od stanu na 
wejściach oraz od aktualnego ***stanu***. Stan aktualny musi zostać zapamiętany
- będę służyły do tego elementy takie jak zatrzask (and. latch) lub rejestr. 

Logika sekwencyjna może pracować synchronicznie do zegara - wówczas będzie 
określana jako logika synchroniczna. Przy braku zegara praca będzie asynchroniczna, 
stąd nazwa - logika asynchroniczna. 

Na potrzeby zajęć będziemy zajmować się głównie logiką synchroniczną. 

Najprostszym elementem logiki synchronicznej jest rejestr - element zapamiętujący.
Przełączenie odbywa się jedynie w czasie zbocza zegarowego (najczęściej zbocze 
narastające).

![dff_pa3](img/dff_pa3.png "Bramka DFF w układach ProAsic3E")

# VHDL - VHSIC Hardware Description Language
`VHDL` (podobnie jak `Verilog`) jest językiem, którego kolejne wersje są 
opracowywane przez komitet standaryzujący IEEE. `VHDL` jest określany jako 
tzw. "strongly typed" tj. jest wymusza na projektancie dokładne zdefiniowanie 
typu każdej zmiennej/sygnały. 

`VHDL` jest mniej popularny niż `Verilog`, ale jest językiem używanym
w projektach Europejskiej Agencji Kosmicznej, stąd to własnie na nim skupimy 
się na zajęciach.

Kolejne wydania `VHDL` oznaczane są rokiem wprowadzenie standardu opisującego 
daną wersję. Najbardziej istotne będą wydania 1995 i 2008. Ostatnie oficjalne 
wydanie jest z roku 2019. 

Podobnie jak w przypadku C++, symulatory oraz syntezatory `VHDL` wprowadzają 
wsparcie dla kolejnych wydaj z dużym opóźnienie. Większość narzędzi komercyjnych 
oraz open-source wspiera kluczowe elementy standardu 2008. Rewizja 2019 jest
jest wspierana głównie w narzędziach komercyjnych (przykładowo Xilinx Vivado), 
ale nawet wówczas w ograniczonym zakresie.

`VHDL` jest językiem, który nie rozróżnia wielkości liter w składni 
(case insensitive) (uwaga, zaleca się używania konsekwentnie dużych 
lub małych liter, jeżeli sam `VHDL` nie rozróżni sygnałów `i_in` oraz 
`i_IN` to, zdarzały się przypadki, gdzie narzędzia syntezy kopiowały 
nazwy bezpośrednio z VHDL do innego języka opisującego układ po syntezie 
co powodowało problemy na kolejnych etapach generacji projektu).

# VHDL - Słowa kluczowe
Tabelka poniżej wypisuje słowa kluczowe języka `VHDL`. Te najbardziej kluczowe 
zostaną użyte w przykładach poniżej. Zainteresowanych definicjami pozostałych 
odsyłam do standardu

| abs             |   case           |   generate  |   map     |   package    |   select     |   unaffected  |
|-----------------|------------------|-------------|-----------|--------------|--------------|---------------|
|   access        |   component      |   generic   |   mod     |   port       |   severity   |   units       |
|   after         |   configuration  |   group     |           |   postponed  |   signal     |   until       |
|   alias         |   constant       |   guarded   |   nand    |   procedure  |   shared     |   use         |
|   all           |                  |             |   new     |   process    |   sla        |               |
|   and           |   disconnect     |   if        |   next    |   pure       |   sll        |   variable    |
|   architecture  |   downto         |   impure    |   nor     |              |   sra        |               |
|   array         |                  |   in        |   not     |   range      |   srl        |   wait        |
|   assert        |   else           |   inertial  |   null    |   record     |   subtype    |   when        |
|   attribute     |   elsif          |   inout     |           |   register   |              |   while       |
|                 |   end            |   is        |   of      |   reject     |   then       |   with        |
|   begin         |   entity         |             |   on      |   rem        |   to         |               |
|   block         |   exit           |   label     |   open    |   report     |   transport  |   xnor        |
|   body          |                  |   library   |   or      |   return     |   type       |   xor         |
|   buffer        |   file           |   linkage   |   others  |   rol        |              |               |
|   bus           |   for            |   literal   |   out     |   ror        |              |               |
|                 |   function       |   loop      |           |              |              |               |


## VHDL - Moduły (entity)
Pracując z `VHDL` 

## Przykłady opisu logiki kombinacyjnej

### Bramka AND

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
    port(
        i_A     : in std_logic;
        i_B     : in std_logic;
        o_Y     : out std_logic
    );
end entity;

architecture behavioral of and_gate is
begin
    o_Y <= i_A and i_B;
end architecture;
```

![and_gate](img/and_gate.svg "Bramka AND opisana w VHDL.")

### Bramka z 4 wejściami 1-bitowymi 

Poniżej przedstawimy dwa sposoby opisu logiki kombinacyjnej realizującej funkcję:
`Y = (A and B) xor (C and D)`

1. Bezpośrednio w architekturze

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity logic4 is
    port(
        i_A     : in std_logic;
        i_B     : in std_logic;
        i_C     : in std_logic;
        i_D     : in std_logic;
        o_Y     : out std_logic
    );
end entity;

architecture behavioral of logic4 is
begin
    o_Y <= (i_A and i_B) xor (i_C and i_D);
end architecture;
```

2. W procesie

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity logic4_proc is
    port(
        i_A     : in std_logic;
        i_B     : in std_logic;
        i_C     : in std_logic;
        i_D     : in std_logic;
        o_Y     : out std_logic
    );
end entity;

architecture behavioral of logic4_proc is
begin
    proc_comb: process(i_A, i_B, i_C, i_D)
    begin
        o_Y <= (i_A and i_B) xor (i_C and i_D);
    end process;
end architecture;
```
W obu przypadkach narzędzie wyjście z narzędzie syntezy jest dokładnie takie samo:

![logic4](img/logic4.svg "Moduł z 4 wejściami 1-bitowymi.")


## Przykłady 

### Licznik

```vhdl
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY cnt IS
    GENERIC (
        G_DATA_WIDTH        : integer := 16
    );
    PORT (
        i_clk               : IN  std_logic;
        i_clr               : IN  std_logic;
        i_load              : IN  std_logic;
        iv_cnt              : IN  std_logic_vector (G_DATA_WIDTH-1 DOWNTO 0);
        ov_cnt              : OUT  std_logic_vector (G_DATA_WIDTH-1 DOWNTO 0)
    );
END cnt;

ARCHITECTURE behavioral OF cnt IS
    SIGNAL cnt_int  : unsigned (G_DATA_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
BEGIN
 
    P_MAIN: PROCESS(i_clk)
    BEGIN
        IF rising_edge(i_clk) THEN
            IF i_clr = '1' THEN
                cnt_int <= (others => '0');
            ELSE
                IF i_load = '1' then 
                    cnt_int <= unsigned(iv_cnt);
                ELSE
                    cnt_int <= cnt_int + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    ov_cnt <= std_logic_Vector(cnt_int); 
END behavioral;
    
```

![cnt_logic](img/cnt_logic.svg "Schemat logiczny układu licznika.")


### Maszyny stanu

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity fsm is
    port (
        i_clk, i_rst, i_x: in std_logic;
        o_z : out std_logic_vector(1 downto 0)
    );
end entity;

architecture arch of fsm is

    type t_state is (S1, S2, S3, S4);
    signal state: t_state;

begin

    proc_fsm: process (i_clk)
        begin

        if rising_edge(i_clk) then
            if i_rst='1' then
                state <= S1;
            else
                case state is
                    when S1 =>
                        if i_x='0' then
                            state <= S1;
                        elsif i_x='1' then
                            state <= S2;
                        end if;
                    when S2 =>
                        if i_x='1' then
                            state <= S2;
                        elsif i_x='0' then
                            state <= S3;
                        end if;
                    when S3 =>
                        if i_x='1' then
                            state <= S4;
                        elsif i_x='0' then
                            state <= S1;
                        end if;
                    when S4 =>
                        if i_x='0' then
                            state <= S3;
                        elsif i_x='1' then
                            state <= S2;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

o_z <= "00" when (state = S1 and i_x='0') else
    "01" when (state = S1 and i_x='1') else
    "00" when (state = S2 and i_x='1') else
    "00" when (state = S2 and i_x='0') else
    "00" when (state = S3 and i_x='1') else
    "00" when (state = S3 and i_x='0') else
    "00" when (state = S4 and i_x='0') else
    "10" when (state = S4 and i_x='1') else
    "11";

end arch;
```

Logika z syntezy powyższego modułu:

![fsm_logic](img/fsm_logic.svg "Schemat logiczny modułu realizującego maszynę stanu.")


Diagram przedstawiający schemat przejść maszyny stanu:

![fsm](img/fsm_0.svg "Schemat logiczny modułu realizującego maszynę stanu.")
