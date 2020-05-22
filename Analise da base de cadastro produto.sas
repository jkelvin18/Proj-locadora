/*
 * PROGRAMA QUE CHECA A MINHA BASE DE CADASTRO_PRODUTO
*/

/* Declaro o atalho para a minha pasta da AluraPlay */
LIBNAME alura "/folders/myfolders/AluraPlay";

* Vou checar o meu diretório da Alura ;
PROC DATASETS
	lib = alura details;
RUN;

*Checa o conteúdo da minha base de cadastro_produto;
PROC CONTENTS
	data = alura.cadastro_produto;
RUN;

*Imprime minha base de cadastro_produto;
PROC PRINT
	data = alura.cadastro_produto;
RUN;

*Gera as frequências das variáveis gênero, plataforma e nome;
PROC FREQ
	data = alura.cadastro_produto;
	table genero plataforma nome;
RUN;

/* Cria uma nova base com a variável de flag de lançamento e antigo*/	
DATA teste;
set alura.cadastro_produto;

IF data > 201606
	THEN lancamento = 1;
	ELSE lancamento = 0;
	
IF data < 201401
	THEN antigo = 1;
	ELSE antigo = 0;
RUN;

PROC PRINT
	data = teste noobs;
RUN;

PROC FREQ
	data = teste;
	table genero*lancamento;
RUN;

PROC FREQ
    data = alura.cadastro_produto nlevels;
    table nome genero*plataforma;
RUN;

* Gera a frequência cruzada das variáveis Gênero e Lançamento;
PROC FREQ
	data = teste;
	table genero*lancamento
	/ NOCOL NOROW NOPERCENT;
RUN;


PROC FREQ
    data = alura.cadastro_produto;
    table plataforma*genero
    / nopercent nofreq;
RUN;

* Gera a lista cruzada das variáveis Nome e Gênero ;
PROC FREQ
	data=alura.cadastro_produto nlevels;
	table nome;
	table nome*genero
	/ list;
RUN;

/* Salva a minha base intermediária no diretório da AluraPlay */
DATA alura.cadastro_produto_v2;
set teste;
rename lancamento = flag_lancamento;
label Genero = "Gênero"
	lancamento = "Marca 1 para jogos que são lançamento e 0 caso contrário";
RUN;

* Checar se minha base 'cadastro_produto_v2' foi criada corretamente ;
PROC CONTENTS
	DATA=alura.cadastro_produto_v2;
RUN;

/* Corrige a data */
DATA teste2;
set alura.cadastro_produto_v2;

if DATA = . then do; 
	select(nome);
		when ("Firershock") 		data = 201706;
		when ("Forgotten echo")		data = 201411;
		when ("Soccer")				data = 201709;
		otherwise;
	end;
end;

RUN;

/* Salva uma nova versão da base de cadastro_produto */
DATA alura.cadastro_de_produto_v3;
set teste2;

* Cria a flag de lançamento;
if data > 201606
	then flag_lancamento = 1;
	else flag_lancamento = 0;

* Marca o rotulo da flag ;
label lancamento = "Marca 1 para jogos que são lançamentos e 0 caso contrário";

RUN;

/* Ex adicional */
DATA desafio;
set alura.cadastro_de_produto_v3;

if Data > 201606 then do;
	identificador_idade = "Lançamento";
	preco_ajustado = preco - 10;
end;
	else if data < 201401 then do;
		identificador_idade = "Antigo";
		preco_ajustado = preco*1.1;
	end;
		else do;
			identificador_idade = "Outro";
			preco_ajustado = preco;
		end;

RUN;

PROC PRINT
	data=desafio;
RUN;

		
	


























