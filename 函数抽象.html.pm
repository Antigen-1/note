#lang pollen/markup
◊h1{使用函数构建抽象}

计算过程（◊i{computational process}）是计算科学所研究的对象，其规则称之为程序（◊i{program}）。

◊(br)

对于一切经验科学而言,研究的对象和研究的方法是相区别的，计算科学也不例外。

事实上，在这里我们仿佛是用咒语变戏法而产生了这一计算机的灵魂。

它在这里是抽象的，因为除了它的存在之外我们对它一无所知。

我们思维对它的一切规定，都被认为是外在于它的东西。

◊(br)

在一个正常运转的计算机中，一个计算过程精确地执行着程序，或者说，程序是指导其发展的模式。

因此我们说，程序是计算过程的本质。

◊(br)

首席工程师可以通过组织一个合适的程序来确保计算过程执行指定的任务；

他们懂得构建程序使得未预见的问题不至于引起灾难性后果。

而当问题出现时，他们可以调试（◊i{debug}）程序。

优秀的计算系统应是◊b{模块化的}，以便各个部分可以分开构建、替换和调试。

◊h2{lisp编程}

程序语言是用于表示程序的符号。

就像用自然语言和数学标记描述生活和数学问题那样，我们只是使用lisp刻画程序思想，而不讨论“为什么是lisp”。

因为在这里，选用那一套符号并非是我们所讨论的内容，当然在未来的讨论中，我们会直接或间接的接触到这一问题的答案。

至于lisp（的实现）作为一个程序，其构建是否是科学的，这也并非是这本书所需要专门讨论的问题。

◊(br)

执行lisp语言所描述的过程（或lisp程序）的机器称为lisp解释器（◊i{interpreter}）。

lisp方言众多，在sicp书中使用的lisp方言称之为scheme。

scheme解释器专注于symbol的处理，于是在数值运算的性能上表现得不尽如人意。

但是经过长期的发展，尽管lisp依然以效率低下而闻名，但是在一些不特别注重性能的场合，lisp得到了大量应用。

◊h3{lisp特性}

lisp的独特性质是我们使用它作为教学语言的原因之一。

◊(br)

lisp对过程的描述——即函数（◊i{procedure}）——是可以作为数据（◊i{data}）得到展现和处理的。

这是最重要的一点——通常情况下数据和过程是严格区分的，前者是被动的，后者则是主动的。

然而，在解释器面前，程序本身就是被动的——被动接受执行的。

因此在这里，程序自身即是数据。或者说，数据是作为程序的本质。

◊(br)

将函数也视为数据的能力使得lisp能够将其他程序作为数据来处理，例如实现其他编程语言的解释器或编译器。

◊h2{编程的基本元素}

lisp将程序视为以下基本单元的集合

◊lst{
ul
原始表达式
结合方式
抽象方式}

原始表达式代表了语言中最简单的实体；结合方式由简单的元素构建复杂的元素；抽象方式隐去复合元素的具体实现，抽象地肯定元素本身。

◊h3{表达式}

在经典的交互模式中，你输入一个表达式，解释器输出表达式计算（◊i{evaluate}）的结果。

一种原始表达式是数值（准确来说是仅包含数字的表达式）。它的结果即为数值本身。

代表数值的表达式可以与代表原始函数的表达式结合形成一个复合表达式。

在这个表达式中，函数应用到这些数值。

◊code{eg. (+ 1 2) -> 3}

◊(br)

标志着函数的应用，形如使用括号分隔的表达式的列表，这样一个表达式，被称为结合（◊i{combination}）。

列表中最左侧的成员被称为操作符（◊i{operator}），其他成员被称为操作对象（◊i{operand}）。

将操作符指定的函数应用到参数，即操作对象的值，即可获得结合的值。

将操作符置于操作对象左侧的传统称为◊b{前缀表达式}。这可能是反直觉的，但是它有诸多优势，其中之一是便于容纳任意数量个参数的函数。

此外，前缀表达式还允许直接构成嵌套的结合，也就是说，在一个结合中，其成员本身也是结合。

◊(br)

原则上来讲，这种嵌套是没有深度和复杂性限制的，但是可读性会非常差。

我们可以使用名为◊i{pretty-printing}的格式化传统来加以改善。

它规定长的结合中，操作对象要垂直对齐。这样产生的缩进可以清晰显示表达式的结构。

◊(br)

对于任意复杂的表达式，解释器总是首先读取表达式，然后计算表达式，最后输出结果。

这种操作模式称之为解释器的◊i{read-eval-print loop}。

◊h2{命名和环境}

仅有最基础的部分对于一门成熟的编程语言当然是不够的。

之前的部分仅能提供完整的功能，当然前提是可维护性、代码的复用等等不被包含于其功能之内。

事实上，对于lisp的核心特性而言，◊b{变量}，即指向运算对象的名称，是不可或缺的。

即是说，变量的◊b{值}即为对象。

◊(br)

scheme中使用◊code{define}命名对象。

◊code{define}的作用仅在于将值和名称相关联；而在关联之后，可使用名称来引用对应的值。

◊code{define}是scheme中最简单的抽象方式，它允许我们使用简单的名称引用复合操作的结果。

事实上，复杂的程序都是通过一步一步构建越来越复杂的对象而建立起来的。

解释器使得这个过程尤其便利，因为名称-对象关联可以在连续的交互中逐步创建。

这个特性常用于增量开发和程序的测试，且很大程度上是lisp程序常有大量相对简单函数的原因。

◊(br)

显然，能够将值和标志（◊i{symbol}）相关联、且在未来可能进行提取，就意味着解释器必须维护某种记忆来追踪名称-对象对。

这种记忆称为环境（◊i{environment}），更准确来说是全局环境（◊i{global environment}）。

◊h2{计算的结合}

这一章我们的任务是单独来看“过程化思考”这一问题。

从这个意义上讲，解释器本身就遵循着一个过程。

我们说过，要计算一个结合，要依次进行以下步骤：

◊lst{
ol
计算子表达式
将操作子应用到操作对象
}

◊b{注：根据r6rs，这也是scheme和haskell的一大区别。}

在这样一条简单的规则中，第一条规定了要计算整体，必须首先计算环节。

因此，这条计算规则天生就是递归的（◊i{recursive}）。

也就是说，执行此规则的其中一步就是触发它的下一次执行。

这种递归的思想可用于简明的表达一个本应非常复杂的过程。

我们可以将这种过程表现为树的形式。

每一个结合都是其中的一个节点和对应的若干分支，分别对应着计算结果以及操作子和操作对象。

末端节点代表着操作子和操作对象。

整个计算过程在树上，就是从末端节点开始向上计算操作对象（也可能是操作子），最后得到根节点即最终结果。

◊(br)

从这我们可以了解到，递归是处理分级树状对象的强大工具。

这种向上渗透的过程一般称之为树的累积（◊i{tree accumulation}）。

◊(br)

