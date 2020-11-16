Tradutor da linguagem de programação Di para C
==============================================

Tradutor Di
-----------

Isto é um tradutor de linguagem que traduz a linguagem de programação Di, criada
para a disciplina ECOM06 – Compiladores. Ele realiza a tradução dos arquivos .di
para seu equivalente C, que podem então serem compilados na linguagem nativa C.
O tradutor foi criado utilizando o programa Bison e Flex.


Como compilar
-------------

gcc lex.yy.c sin.tab.c -o di.exe

Para a compilação foi utilizado o Mingw64, com o Bison e Flex instalados e suas
bibliotecas adicionadas nas variaveis de ambiente.

Como utilizar o tradutor
------------------------

Para utilizar o tradutor, deve-se usar o comando:

di.exe [sourcefile.di] [destinationfile.c]

Será criado um arquivo chamado comandos.txt, listando os comandos utilizados.
