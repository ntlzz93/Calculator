# Calculator
a calculator program that allows the use of real number constants and generate to graphviz dot formate
﻿![Calculator using flex&bison](https://github.com/Flex-Bison/Calculator/blob/master/Calculator/outfile.png)
* calculator in flex-bison
* To make this file, "yacc -d clac.y" and "flex clac.l "  let you make file  into y.tab.c & y.tab.h lex.yy.c
* and "gcc lex.yy.c y.tab.c -lfl -o thangdn" to generate an executable file
* You can run ./thangdn and enter an regular expression. EX: "max(2+(2+3)*3-2**5,pow(5,6)-log 15/2+sin 30)".
* To finish up, you can use "dot -Tpdf tree.dot -o outfile.pdf" to generate an grapviz dot is pdf file
* version: 2.0
* January, 26, 2016
*
* This lib was written by thangdn
* Contact:thangdn.tlu@outlook.com
*
* Every comment would be appreciated.
*
* If you want to use parts of any code of mine:
* let me know and
* use it!
