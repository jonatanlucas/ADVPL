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

Local oObject   := aParam[1] //Objeto do formulï¿½rio ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execuï¿½ï¿½o do ponto de entrada(se ï¿½  pï¿½s validaï¿½ï¿½o, prï¿½ validaï¿½ï¿½o, commit, etc)
Local cIdModel  := aParam[3] //ID do formulï¿½rio

Local cRazSoc   := Alltrim(M->A2_NOME) //Razão social
Local cFantasia := Alltrim(M->A2_NREDUZ) // Nome Reduzido

IF aParam[2] <> Nil
    IF cIdPonto == "MODELPOS" //Se estiver na Pï¿½s Validaï¿½ï¿½o(Clicou em Confirma)
        IF Len(AllTrim(cRazSoc)) < 20
           Help(NIL, NIL, "RAZSOC", NIL, "Razão social inválida",;
		   1,0, NIL, NIL, NIL, NIL, NIL,{"A Razão social <b> "+cRazSoc + "</b> deve ter no mínimo <b>20</b> caracteres"})
 
            xRet    := .F.
        
        //Verifica se o campo de descriï¿½ï¿½o do produto possui no mï¿½nimo 15 caracteres 
        ELSEIF  Len(AllTrim(cFantasia)) < 10
            	Help(NIL, NIL, "NOMFAN", NIL, EncodeUTF8("Nome fantasia inválido"),;
			1,0, NIL, NIL, NIL, NIL, NIL,{"O Nome Fantasia <b> "+cFantasia + "</b> deve ter no mínimo <b>10</b> caracteres"})
            xRet    := .F.
        ENDIF  
    ELSEIF cIdPonto == "BUTTONBAR" 
        xRet := {{"Produto x Fornecedor", "Produto x Fornecedor",{||MATA061()},"Chama a amarração Prod x Forn"}}

    Endif
Endif

Return xRet
