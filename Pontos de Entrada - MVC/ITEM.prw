#include "Protheus.ch"
#include "Totvs.ch"

/*/{Protheus.doc} User Function Item
    Ponto de entrada utilizado para modificar o cadastro de produtos, quando este(MATA010)
    estï¿½ em MVC
    @type  Function
    @author user
    @since 13/02/2021
    @version version
    @return xRet, indefinido, retorno da variï¿½vel de controle 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function Item()

/*Parametro obrigatï¿½rio nos PEs em MVC, pois eles trazem consigo, informaï¿½ï¿½es importantes
sobre o estado e ponto de execuï¿½ï¿½o da rotina*/
Local aParam    := PARAMIXB

/* RETORNO DO ARRAY aParam
1   O     Objeto do formulï¿½rio ou do modelo, conforme o caso
2   C     ID do local de execuï¿½ï¿½o do ponto de entrada
3   C     ID do formulï¿½rio
*/

/*Esta variï¿½vel pode retornar no final, tanto lï¿½gico quanto um array, por exemplo, por isso dixamos
a notaï¿½ï¿½o Hï¿½NGARA indefinida com x e nï¿½o com l */
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formulï¿½rio ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execuï¿½ï¿½o do ponto de entrada(se ï¿½  pï¿½s validaï¿½ï¿½o, prï¿½ validaï¿½ï¿½o, commit, etc)
Local cIdModel  := aParam[3] //ID do formulï¿½rio

//Captura a operaï¿½ï¿½o executada na aplicaï¿½ï¿½o
Local nOperation    := oObject:GetOperation()
/*
1- pesquisar
2- visualizar
3- incluir
4- alterar
5- excluir
6- outras funï¿½ï¿½es
7- copiar
*/


//Se ele estiver diferente de nulo, quer dizer que alguma aï¿½ï¿½o estï¿½ sendo feita no modelo
IF aParam[2] <> Nil
    IF cIdPonto == "MODELPOS" //Se estiver na Pï¿½s Validaï¿½ï¿½o(Clicou em Confirma)
        //Verifica se o campo de cï¿½digo do produto possui no mï¿½nimo 10 caracteres
        IF Len(AllTrim(M->B1_COD)) < 10
            Help(NIL, NIL, "CODPRODUTO", NIL, "Codigo nao permitido",;
            1,0, NIL, NIL, NIL, NIL, NIL,{"O Codigo <b> "+AllTrim(M->B1_COD) + "</b> deve ter no minimo 10 caracteres <b>"})
            
            xRet    := .F.
        
        //Verifica se o campo de descriï¿½ï¿½o do produto possui no mï¿½nimo 15 caracteres 
        ELSEIF  Len(AllTrim(M->B1_DESC)) < 15
            Help(NIL, NIL, "DESCPRODUTO", NIL,EncodeUTF8("Descrição do Produto inválida"),;
            1,0, NIL, NIL, NIL, NIL, NIL,{"A descrição <b." + AllTrim(M->B1_DESC) +" </b> deve ter no mínimo 15 caracteres"})

            xRet    := .F.
        ENDIF            
    
    ELSEIF nOperation = 5 //Exclusï¿½o
		Help(NIL, NIL, "EXCLUIRPRODUTO", NIL, "Exclusão não permitida",;
		1,0, NIL, NIL, NIL, NIL, NIL,{"O Produto nao pode ser excluído em hipótese alguma<br>"+;
		"Consulte o departamento de TI desta unidade"})
		xRet := .F.	        
    
    //Tarefa para vocï¿½ Protheuzeiro, faï¿½a uma outra validaï¿½ï¿½o para o Cancelamento, similar ï¿½ que fizemos dentro do sistema de chamados
    
    Endif
Endif

Return xRet
