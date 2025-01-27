#CPU设计草稿
## PC(程序计数器)
>简介：
每个周期地址+4,输出地址。
端口：
out：输出的地址。(输出信号)(31:0)
clk：时钟信号。
in：下一个pc的地址。(31:0)
reset：异步重置信号，当reset为1时，地址归零。
en:使能信号，但en有效时，才能读入信号。
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
为10时：ans = A1 | A2

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

##CMP(比较单元)
>简介：比较beq指令是否执行。
端口：
CMP1：第一个比较数。(31:0)
CMP2：第二个比较数。(31:0)
CMP_en：使能信号，该信号为0时，才运行改模块。
j_op:跳转信号。(输出信号)

##D_REG(D级寄存器)
>简介：存储D级所有指令。
端口：
en：当en为1时，寄存器存储的数值恒定不变。

##E_REG(E级寄存器)
>简介：存储E级所有指令。

##M_REG(M级寄存器)
>简介：存储M级所有指令。

##W_REG(W级寄存器)
>简介：存储W级所有指令。

##D_CTRL(D级控制器)
> 输出D级控制信号。
信号说明：
    output [2:0] D_CMP_A1_op
    output [2:0] D_CMP_A2_op
    CMP输入的跳转控制信号
    000：正常输入。
    001：接收E级转发。
    010：接收M级转发。
    output [2:0] D_NPC_JR_op
    jr指令跳转控制信号。
    000：正常输入。
    010：M级转发。

##E_CTRL(E级控制器)
> 输出E级控制信号。
信号说明：
    output [2:0] E_ALU_MUX_A2
    ALU第二接口输入选择信号
    000：输入rt寄存器数值。
    001：输入拓展立即数。
    output [2:0] E_GRF_RD1_op,
    output [2:0] E_GRF_RD2_op,
    RD1和RD2转发控制信号。
    000：正常输入。
    001：接收M级转发。
    010：接收W级ans转发。
    011：接收W级DM_out转发.

##M_CTRL(M级控制器)
> 输出M级控制信号。
信号说明：
    output [1:0] M_DM_op,
    DM写入控制信号
    output [1:0] M_DM_address_mux_op
    DM地址输入控制信号
    00：写入RD1+偏移值
    output [1:0] M_DM_WE_max_op
    DM写入数值控制信号。
    output [2:0] M_GRF_RD2_op
    RD2转发控制信号
    000:正常运行；
    001：接收W级ans转发。
    010：接收W级DW_out转发。

##W_CTRL(W级控制器)
> 输出W级控制信号。
信号说明：
    output W_WE_op
    GRF写入控制信号
    output [1:0] W_grf_address_mux_op,
    GRF地址输入地址控制信号
    00：写入rd寄存器数值。
    01：写入写入rt寄存器数值。
    10：写入31号寄存器。
    output [1:0] W_grf_WE_mux_op,
    GRF写入数值控制信号。
    00：写入ALU计算结果。
    01：写入DM取出的数值。
    10：写入PC+4.

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
1、我们使用提前分支判断的方法尽早产生结果来减少因不确定而带来的开销，但实际上这种方法并非总能提高效率，请从流水线冒险的角度思考其原因并给出一个指令序列的例子。
> 将分支提前预判，可能会导致阻塞，降低运行效率。
例如
lw $t1,0($t1)
beq $t1,$t1,loop


2、因为延迟槽的存在，对于 jal 等需要将指令地址写入寄存器的指令，要写回 PC + 8，请思考为什么这样设计？
>由于流水线的结构，跳转指令后面的指令一定会运行，因此有了延迟槽。跳转需要跳过延迟槽指令。

3、我们要求大家所有转发数据都来源于流水寄存器而不能是功能部件（如 DM 、 ALU ），请思考为什么？
>这样可以降低每一级的关键路径，降低周期，加快运行效率。

4、我们为什么要使用 GPR 内部转发？该如何实现？。
>

5、我们转发时数据的需求者和供给者可能来源于哪些位置？共有哪些转发数据通路？
>需求者：cmp的两个输入，jr跳转的输入地址，alu的两个输入，DM写入输入。
供给者：M级流水寄存器，W级流水寄存器。
在需求端根据寄存器是否相等盘点是否接收转发。在供给端，通过控制单元输出控制信号判断转发哪条信号。

6、在课上测试时，我们需要你现场实现新的指令，对于这些新的指令，你可能需要在原有的数据通路上做哪些扩展或修改？提示：你可以对指令进行分类，思考每一类指令可能修改或扩展哪些位置。
>r型指令可能需要增加alu输出的选择信号，和额外的输出控制信号。
lw类型指令可能要加DM的输出的选择信号，和输入的选择信号。
跳转指令可能要增加新的cmp模块。

7、简要描述你的译码器架构，并思考该架构的优势以及不足。
>我采用分布式译码，优点是方便理解。更加直观。缺点是增加指令很麻烦。