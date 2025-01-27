#CPU设计草稿
##1.IFU(取指令单元)
>内部包括:
>* PC(程序计数器)
>>简介：
每个周期地址+4,输出地址。
端口：
address：输出的地址。(输出信号)(31:0)
clk：时钟信号。
op：跳转的判断指令，当op为高电平时，地址变为j。
j：地址偏移值。(31:0)
reset：异步重置信号，当reset为1时，地址归零。
>* IM(指令储存器)
>>简介：
存储指令数据，输入地址，读取相应的指令。
端口：
address：输入的地址。(31:0)
inster：输出的指令。(输出信号)(31:0)
>
>简介：
按照时钟周期读取指令。
端口：
clk：时钟信号。
op：跳转的判断指令，当op为高电平时，地址变为j。
j_address：地址偏移值。(31:0)
reset：异步重置信号，当reset为1时，地址归零。
inster：输出的指令。(输出信号)(31:0)

##GRF(通用寄存器组)
>简介：
32个寄存器组成的寄存器组，其中0号寄存器恒定为0。
端口：
clk：时钟信号。
reset：异步重置信号，当reset为1时，所有寄存器归零。
WE_op：但该端口为高电平时，才能写入数据。
A1：一号地址。(4:0)
A2：二号地址。(4:0)
A3：待写入数据的寄存器的地址。(4:0)
RD1：输出一号地址所对应的寄存器的存储的数据。(输出信号)(31:0)
RD2：输出二号地址所对应的寄存器的存储的数据。(输出信号)(31:0)
WE：要写入的数据。(31:0)

##DM(数据存储器)
>简介：
存储，读取数据。
端口：
address：导入数据的地址，或读取数据的地址。(31:0)
in：要写入的数据。
out：读出的数据。
clk：时钟信号。
RE_write：写入控制信号，只有该端口为高电平时才能读入。(31:0)
RE_read：读取控制信号，只有该端口为高电平是才能输出数据。(输出信号)(31:0)

##ALU(算术逻辑单元)
>简介：
提供四种运算。
端口：
ALU_op：输入不同信号进行不同运算。(1:0)
A1：一号运算数。(31:0)
A2：二号运算数。(31:0)
ans：运算结果。(输出信号)(31:0)
ALU_op详细说明；
为00时：ans = A1 + A2
为01时：ans = A1 - A2
为10时：按时 = A1 | A2
为11时：仅当A1 = A1时输出1，其他情况输出0

##EXT(扩展单元)
>简介：
提供三种扩展方式。
端口：
in：输入16位数字。(15:0)
out：输出扩展后的32位数字。(输出信号)(31:0)
EXT_op：输入不同信号进行不同运算。(1:0)
EXT_op详细说明；
为00时：高位0拓展。
为01时，地位0拓展。
为10时：高位符号拓展。

##Controller(控制器)
>简介：
控制单元
端口：
op：操作码。(5:0)
fuc：功能码。(5:0)
Mem_read：DM输出控制信号。
Mem_write：DM读入控制信号。
alu_op：alu控制信号。
we_op：GRF控制信号。
max_alu_op:alu第二运算数和GRF第二地址输入选择信号。
max_grf_op:GRF写入数据选择信号。
IFU：跳转第一选择信号。
注：
1.beq指令需要两个信号控制，故将其独立出来。
2.采用与或门矩阵，而非使用真值表实现，以便后期拓展指令。



#测试指令
    ori $a0, $0, 123
    ori $a1, $a0, 456
    lui $a2,0x8000     #测试边界负数
    ori $a2,1          #测试小立即数
    ori $a2,0
    lui $a2,0x7fff    #测试边界正数
    lui $a2,0x7ffe    
    ori $a2,65535      #测试边界立即数
    ori $a2,65533
    ori $a2,12313       #测试随机立即数
    lui $a2, 123            # 符号位为 0
    lui $a3, 0xffff         # 符号位为 1
    ori $0,$0,1020          #测试$0寄存器
    ori $a3, $a3, 0xffff    # $a3 = -1
    add $s0, $a0, $a2      # 正正
    add $s1, $a0, $a3      # 正负
    add $s2, $a3, $a3      # 负负
    sub $s0, $a0, $a2      # 正正
    sub $s1, $a0, $a3      # 正负
    sub $s2, $a3, $a3      # 负负
    ori $t0, $0, 0x0000
    sw $a0, 0($t0)
    sw $a1, 4($t0)
    sw $a2, 8($t0)
    sw $a3, 12($t0)
    sw $s0, 16($t0)
    sw $s1, 20($t0)
    sw $s2, 24($t0)        #测试sw指令
    lw $a0, 0($t0)
    lw $a1, 12($t0)         #测试lw指令
    sw $a0, 28($t0)
    sw $a1, 32($t0)
    ori $a0, $0, 1
    ori $a1, $0, 2
    ori $a2, $0, 1
    beq $a0, $a1, loop1     # 不相等
    beq $a0, $a2, loop2     # 相等
    loop1:sw $a0, 36($t0)
    loop2:sw $a1, 40($t0)
##机械码
    3404007b
    348501c8
    3c068000
    34c60001
    34c60000
    3c067fff
    3c067ffe
    34c6ffff
    34c6fffd
    34c63019
    3c06007b
    3c07ffff
    340003fc
    34e7ffff
    00868020
    00878820
    00e79020
    00868022
    00878822
    00e79022
    34080000
    ad040000
    ad050004
    ad060008
    ad07000c
    ad100010
    ad110014
    ad120018
    8d040000
    8d05000c
    ad04001c
    ad050020
    34040001
    34050002
    34060001
    10850001
    10860001
    ad040024
    ad050028


#思考题
1.上面我们介绍了通过 FSM 理解单周期 CPU 的基本方法。请大家指出单周期 CPU 所用到的模块中，哪些发挥状态存储功能，哪些发挥状态转移功能。
>GRF发挥状态存储功能，ALU,DM，Controller，EXT等发挥状态转移功能。

2.现在我们的模块中 IM 使用 ROM， DM 使用 RAM， GRF 使用 Register，这种做法合理吗？ 请给出分析，若有改进意见也请一并给出。
>合理，代码写入后就不需要更改，所有应该使用ROM。而GRF需要快速改变，数据流量大，因此使用Register。而DM，需要实现反复读写，因而使用RAM。

3.在上述提示的模块之外，你是否在实际实现时设计了其他的模块？如果是的话，请给出介绍和设计的思路。
>无，但是给模块增加了更多功能，如多种扩展方式，加入跳转控制等。

4.事实上，实现 nop 空指令，我们并不需要将它加入控制信号真值表，为什么？
>空指令不会触发任何控制信号，$0寄存器也恒定为0，因此没有必要将其写入控制真值表。

5.上文提到，MARS 不能导出 PC 与 DM 起始地址均为 0 的机器码。实际上，可以避免手工修改的麻烦。请查阅相关资料进行了解，并阐释为了解决这个问题，你最终采用的方法。
>加一个模块，当地址大于0x3000时减去0x3000。

6.阅读 Pre 的 “MIPS 指令集及汇编语言” 一节中给出的测试样例，评价其强度（可从各个指令的覆盖情况，单一指令各种行为的覆盖情况等方面分析），并指出具体的不足之处。
>该测试没有检查32位边界数，和16位立即数的边界数。同时，也没有检查减法，和测试$0寄存器导入导出的效果。