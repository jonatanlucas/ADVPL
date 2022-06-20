#include 'Totvs.ch'

/*/{Protheus.doc} User Function CustomerVendor
    
    @type  Function
    @author user
    @since 13/06/2022
    @version version
    @param , param_type, param_descr
    @return xRet, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CustomerVendor()
    
Local aParam    := PARAMIXB
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formul�rio ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execu��o do ponto de entrada(se �  p�s valida��o, pr� valida��o, commit, etc)
Local cIdModel  := aParam[3] //ID do formul�rio

Local cRazSoc   := Alltrim(M->A2_NOME) //Raz�o social
Local cFantasia := Alltrim(M->A2_NREDUZ) // Nome Reduzido

IF aParam[2] <> Nil
    IF cIdPonto == "MODELPOS" //Se estiver na P�s Valida��o(Clicou em Confirma)
        IF Len(AllTrim(cRazSoc)) < 20
           Help(NIL, NIL, "RAZSOC", NIL, "Raz�o social inv�lida",;
		   1,0, NIL, NIL, NIL, NIL, NIL,{"A Raz�o social <b> "+cRazSoc + "</b> deve ter no m�nimo <b>20</b> caracteres"})
 
            xRet    := .F.
        
        //Verifica se o campo de descri��o do produto possui no m�nimo 15 caracteres 
        ELSEIF  Len(AllTrim(cFantasia)) < 10
            	Help(NIL, NIL, "NOMFAN", NIL, EncodeUTF8("Nome fantasia inv�lido"),;
			1,0, NIL, NIL, NIL, NIL, NIL,{"O Nome Fantasia <b> "+cFantasia + "</b> deve ter no m�nimo <b>10</b> caracteres"})
            xRet    := .F.
        ENDIF  
    ELSEIF cIdPonto == "BUTTONBAR" 
        xRet := {{"Produto x Fornecedor", "Produto x Fornecedor",{||MATA061()},"Chama a amarra��o Prod x Forn"}}

    Endif
Endif

Return xRet
