#include "Protheus.ch"

/*/{Protheus.doc} User Function MATA070
    Ponto de entrada para Bancos(MATA070), neste caso
    em especial o IDDAMODEL tem o mesmo nome da FUNCTION, fonte padrùo
    para isto, eu criei o fonte como MATA070_pe.prw
    @type  Function
    @author user
    @since 13/02/2021
    @version version
    @param , param_type, param_descr
    @return xRet, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MATA070()
Local aParam    := PARAMIXB
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formulùrio ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execuùùo do ponto de entrada(se ù  pùs validaùùo, prù validaùùo, commit, etc)
Local cIdModel  := aParam[3] //ID do formulùrio


IF aParam[2] <> Nil
    IF cIdPonto == "MODELPOS"
        IF Empty(M->A6_DVAGE) .OR. Empty(M->A6_DVCTA)
            Help(NIL, NIL, "MATA070", NIL, "DV de Agencia ou Conta em branco",;
            1,0, NIL, NIL, NIL, NIL, NIL,{"O dùgito verificador da <b>Agencia</b> e da <b>Conta</b> devem ser preenchidos"})

            xRet    := .F. //Se retornar false, logo ele nùo deixa passar
        ENDIF
    ENDIF
ENDIF

Return xRet
