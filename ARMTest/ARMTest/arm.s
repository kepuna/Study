// .stack 是栈段
// .data 是代表数据段
// .text 代表代码段，将来下面的内容会被放到代码段里面
// ARM64汇编中注释其实用 分号表示；
.text
.global _test

_test:
mov x0, 8
ret


