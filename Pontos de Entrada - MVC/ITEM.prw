#include "Protheus.ch"
#include "Totvs.ch"

/*/{Protheus.doc} User Function Item
    Ponto de entrada utilizado para modificar o cadastro de produtos, quando este(MATA010)
    est� em MVC
    @type  Function
    @author user
    @since 13/02/2021
    @version version
    @return xRet, indefinido, retorno da vari�vel de controle 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function Item()

/*Parametro obrigat�rio nos PEs em MVC, pois eles trazem consigo, informa��es importantes
sobre o estado e ponto de execu��o da rotina*/
Local aParam    := PARAMIXB

/* RETORNO DO ARRAY aParam
1   O     Objeto do formul�rio ou do modelo, conforme o caso
2   C     ID do local de execu��o do ponto de entrada
3   C     ID do formul�rio
*/

/*Esta vari�vel pode retornar no final, tanto l�gico quanto um array, por exemplo, por isso dixamos
a nota��o H�NGARA indefinida com x e n�o com l */
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formul�rio ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execu��o do ponto de entrada(se �  p�s valida��o, pr� valida��o, commit, etc)
Local cIdModel  := aParam[3] //ID do formul�rio

//Captura a opera��o executada na aplica��o
Local nOperation    := oObject:GetOperation()
/*
1- pesquisar
2- visualizar
3- incluir
4- alterar
5- excluir
6- outras fun��es
7- copiar
*/


//Se ele estiver diferente de nulo, quer dizer que alguma a��o est� sendo feita no modelo
IF aParam[2] <> Nil
    IF cIdPonto == "MODELPOS" //Se estiver na P�s Valida��o(Clicou em Confirma)
        //Verifica se o campo de c�digo do produto possui no m�nimo 10 caracteres
        IF Len(AllTrim(M->B1_COD)) < 10
            Help(NIL, NIL, "CODPRODUTO", NIL, "Codigo nao permitido",;
            1,0, NIL, NIL, NIL, NIL, NIL,{"O Codigo <b> "+AllTrim(M->B1_COD) + "</b> deve ter no minimo 10 caracteres <b>"})
            
            xRet    := .F.
        
        //Verifica se o campo de descri��o do produto possui no m�nimo 15 caracteres 
        ELSEIF  Len(AllTrim(M->B1_DESC)) < 15
            Help(NIL, NIL, "DESCPRODUTO", NIL,EncodeUTF8("Descri��o do Produto inv�lida"),;
            1,0, NIL, NIL, NIL, NIL, NIL,{"A descri��o <b." + AllTrim(M->B1_DESC) +" </b> deve ter no m�nimo 15 caracteres"})

            xRet    := .F.
        ENDIF            
    
    ELSEIF nOperation = 5 //Exclus�o
		Help(NIL, NIL, "EXCLUIRPRODUTO", NIL, "Exclus�o n�o permitida",;
		1,0, NIL, NIL, NIL, NIL, NIL,{"O Produto nao pode ser exclu�do em hip�tese alguma<br>"+;
		"Consulte o departamento de TI desta unidade"})
		xRet := .F.	        
    
    //Tarefa para voc� Protheuzeiro, fa�a uma outra valida��o para o Cancelamento, similar � que fizemos dentro do sistema de chamados
    
    Endif
Endif

Return xRet
