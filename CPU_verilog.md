#CPU设计草稿
## PC(程序计数器)
>简介：
每个周期地址+4,输出地址。
端口：
out：输出的地址。(输出信号)(31:0)
clk：时钟信号。
in：下一个pc的地址。(31:0)
reset：异步重置信号，当reset为1时，地址归零。
## IM(指令储存器)
>简介：
存储指令数据，输入地址，读取相应的指令。
端口：
address：输入的地址。(31:0)
inster：输出的指令。(输出信号)(31:0)
## NPC
>简介：
计算下一位地址。
端口：
pc：当前pc地址。(31:0)
npc：下一个地址。(输出信号)(31:0)
imm_off:跳转偏移值。(15:0)
imm_j：26位跳转输入地址。(25:0)
jr:32位跳转地址。(31:0)
op简介：
00：当前pc加4作为下一个地址。
01：pc加4加上符号扩展后的偏移值。
10：(31:28)为与原pc相同，imm_j作为低位字节地址。
11:跳转到输入的jr地址。

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
j_op1：是否跳转。
DM_read：DM输出控制信号。(输出信号)
DM_write：DM读入控制信号。(输出信号)
ALU_op：alu选择信号。(输出信号)
we_op：GRF控制信号。(输出信号)
max_alu_op:alu第二运算数选择信号。(输出信号)
max_grf_op:GRF写入数据选择信号。(输出信号)
max_grf_address_op：GRF输入地址选择信号。(输出信号)
PC_op：npc选择控制信号。(输出信号)


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


    p1:
    lui $t2,16
    ori $t1,15
    ori $t2,15
    add $t2,$t2,$t1
    beq $t1,$t2,p1
    sub $t2,$t2,$t1
    jal p2
    sub $t1,$t1,$t1
    sub $t2,$t2,$t2
    p3:
    beq $t1,$t1,p3
    p2:
    ori $t1,17
    ori $t2,17
    jr $ra

    3c0a0010
    3529000f
    354a000f
    01495020
    112afffb
    01495022
    0c000c0a
    01294822
    014a5022
    1129ffff
    35290011
    354a0011
    03e00008

li	$s0, 0
li	$s1, -1000
li	$s2, 1000
lui	$s3, 0x8000	#s3 is  -2147483648
lui	$s4, 0x8000
ori	$s4, 0x0001	#s4 is  -2147483647
lui	$s5, 0x7fff
ori	$s5, 0xffff	#s5 is  2147483647
lui	$s6, 0x7fff
ori	$s6, 0xfffe	#s6 is 2147483646
ori $s7,1

beq_1:	
beq $s0, $s0,beq_1_test
beq_2:	
beq $s1, $s1,beq_2_test

beq_10:  beq	$s5, $s6, beq_10_test
beq_end:

jal_1:	jal	jal_1_test
jal_5:	jal	jal_5_test
jal_end:

sw	$t0, 0($s0)
sw	$t1, 0($s0)
sw	$t2, 0($s0)
sw	$t3, 0($s0)
sw	$t4, 0($s0)
sw	$t5, 0($s0)
loop:
beq $0,$0,loop
	
beq_1_test: add	$t0,$t0, $s7
	   beq $0,$0,beq_2
	   
beq_2_test: add	$t0,$t0, $s7
	   beq $0,$0,beq_10

beq_10_test: add $t0,$t0, $s7
	   beq $0,$0,beq_end
		
jal_1_test:	add	$t4, $4, $s7
		jr	$ra

jal_5_test:	add	$t4, $4, $s7
		jr	$ra

24100000
2411fc18
241203e8
3c138000
3c148000
36940001
3c157fff
36b5ffff
3c167fff
36d6fffe
36f70001
1210000b
1231000c
12b6000d
0c000c1d
0c000c1f
ae080000
ae090000
ae0a0000
ae0b0000
ae0c0000
ae0d0000
1000ffff
01174020
1000fff3
01174020
1000fff2
01174020
1000fff1
00976020
03e00008
00976020
03e00008

ori $a0,$0,1999  
ori $a1,$a0,111 
lui $a2,12345
lui $a3,0xffff
lui $t0,0xffff
beq $a3,$t0,eee
add $s7,$0,$a0
nop
ori $a3,$a3,0xffff
add $s0,$a0,$a1 
add $s1,$a3,$a3
add $s2,$a3,$s0
beq $s2,$s3,eee
sub $s0,$a0,$s2 
sub $s1,$a3,$a3
eee:
sub $s2,$a3,$a0
sub $s3,$s2,$s1
ori $t0,$0,0x0000
sw $a0,0($t0)
nop
sw $a1,4($t0)
sw $s0,8($t0)
sw $s1,12($t0)
sw $s2,16($t0)
sw $s5,20($t0)
lw $t1,20($t0)
lw $t7,0($t0)
lw $t6,20($t0)
sw $t6,24($t0)
lw $t5,12($t0)
jal end
ori $t0,$t0,1
ori $t1,$t1,1
ori $t2,$t2,2
beq $t0,$t2,eee
lui $t3,1111
jal out
end:
add $t0,$t0,$t7
jr $ra
out:
add $t0,$t0,$t3
ori $t2,$t0,0
beq $t0,$t2,qqq
lui $v0,10
qqq:
lui $v0,11
j www
nop
www:
lui $ra,100

#思考题
1.阅读下面给出的 DM 的输入示例中（示例 DM 容量为 4KB，即 32bit × 1024字），根据你的理解回答，这个 addr 信号又是从哪里来的？地址信号 addr 位数为什么是 [11:2] 而不是 [9:0] ？
>addr为alu的输出值，具体为寄存器存储地址加上符号拓展的偏移值。addr为字地址，而dm存储以字节为单位，因此位数为[11:2]。

2.思考上述两种控制器设计的译码方式，给出代码示例，并尝试对比各方式的优劣。
>assign WE_op = add | sub | lw | lui | jal | ori;（控制信号每种取值所对应的指令）
if(add)
begin
WE_op <= 1'b1;
end
else
befin
WE_op <= 1'b0;
end(指令对应的控制信号)
第二种方便拓展，第一种方式便于理解，修改错误。

3.在相应的部件中，复位信号的设计都是同步复位，这与 P3 中的设计要求不同。请对比同步复位与异步复位这两种方式的 reset 信号与 clk 信号优先级的关系。
>在异步复位中，reset优先。在同步复位中，只有clk上升沿，reset才能发挥作用。

4.C 语言是一种弱类型程序设计语言。C 语言中不对计算结果溢出进行处理，这意味着 C 语言要求程序员必须很清楚计算结果是否会导致溢出。因此，如果仅仅支持 C 语言，MIPS 指令的所有计算指令均可以忽略溢出。 请说明为什么在忽略溢出的前提下，addi 与 addiu 是等价的，add 与 addu 是等价的。提示：阅读《MIPS32® Architecture For Programmers Volume II: The MIPS32® Instruction Set》中相关指令的 Operation 部分。
>add和addu，addi和addiu的实现方式基本相同，最大的区别是IntegerOverflow警告，若不考虑溢出，则完全相同，故两者等价。