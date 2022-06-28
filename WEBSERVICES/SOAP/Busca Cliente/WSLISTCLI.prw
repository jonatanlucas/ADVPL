#include "Protheus.ch"
#include "APWEBSRV.ch" //Include principal dos WebServices
#include "TOPCONN.ch"


//Estrutura de dados C�digo, nome, endere�o, bairro, cidade, estado e CEP
WSSTRUCT StClientes

    WSDATA clienteA1CODIGO   AS STRING OPTIONAL
    WSDATA clienteA1NOME     AS STRING OPTIONAL
    WSDATA clienteA1END      AS STRING OPTIONAL
    WSDATA clienteA1CEP      AS STRING OPTIONAL
    WSDATA clienteA1BAIRRO   AS STRING OPTIONAL
    WSDATA clienteA1CIDADE   AS STRING OPTIONAL
    WSDATA clienteA1ESTADO   AS STRING OPTIONAL

ENDWSSTRUCT

//Estrutura de dados no formato/tipo Array, para receber a lista de cliente com base na 

WSSTRUCT StListClientes
        
        //CRIO ARRAY aRegsClientes com base na estrutura StClientes
        WSDATA aRegsClientes    AS ARRAY OF StClientes OPTIONAL
        
        //STRINGS DE RETORNO
        WSDATA cRet             AS STRING OPTIONAL
        WSDATA cMessage         AS STRING OPTIONAL
ENDWSSTRUCT

WSSERVICE WSLISTCLIENTES DESCRIPTION "Servi�o para listar os dados dos clientes dentro de um intervalo especificado"
    //Par�metros de entrada
    WSDATA cClienteDe           AS STRING
    WSDATA cClienteAte          AS STRING

    //TOKEN DE AUTENTICA��O
    WSDATA cToken          AS STRING

    //Estrutura de sa�da
    WSDATA WsListaClientes      AS StListClientes

    WSMETHOD BuscaClientes  DESCRIPTION "Lista os Clientes da SA1 conforme filtros/parametros especificados na entrada"
ENDWSSERVICE

//Meetodo               Entrada                           Sa�da                                 Webservice dono do m�todo
WSMETHOD BuscaClientes WSRECEIVE cToken,cClienteDe, cClienteAte WSSEND  WsListaClientes WSSERVICE WSLISTCLIENTES
    Local cCodDe             := ::cClienteDe
    Local cCodAte            := ::cClienteAte
    Local cTokenDefault      := "#souprotheuzeiro"

//�ndice utilizado no Array
Local nIndex    := 1

    IF Empty(::cToken)
        SetSoapFault("Token n�o informado","Opera��o n�o permitida!")
        RETURN .F.
    ELSEIF cTokenDefault <> ::cToken
        SetSoapFault("Token inv�lido, informe o Token correto","Opera��o n�o permitida!")
        RETURN .F.
    ELSE
//Invertendo par�metro caso o De seja maior que o At�
IF cCodDe > cCodAte
    cCodDe  := ::cClienteAte
    cCodAte := ::cClienteDe
ENDIF

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+cCodDe))

//Enquanto for menor que o par�metor cClienteAte/cCodAte
WHILE SA1->(!EOF()) .AND. SA1->A1_COD <= cCodAte

        //Criando a estrutura de array com base na classe de dados criada no inicio
        aAdd(::WsListaClientes:aRegsClientes,WsClassNew("StClientes"))

        //Popular as linhas e colunas do array com os dados do banco(Tabela SA1)
        ::WsListaClientes:aRegsClientes[nIndex]:clienteA1CODIGO    := SA1->A1_COD
        ::WsListaClientes:aRegsClientes[nIndex]:clienteA1NOME      := SA1->A1_NOME
        ::WsListaClientes:aRegsClientes[nIndex]:clienteA1END       := SA1->A1_END
        ::WsListaClientes:aRegsClientes[nIndex]:clienteA1CEP       := SA1->A1_CEP
        ::WsListaClientes:aRegsClientes[nIndex]:clienteA1BAIRRO    := SA1->A1_BAIRRO
        ::WsListaClientes:aRegsClientes[nIndex]:clienteA1CIDADE    := SA1->A1_MUN
        ::WsListaClientes:aRegsClientes[nIndex]:clienteA1ESTADO    := SA1->A1_EST

        //Pulando para o pr�ximo �ndice do Array
        nIndex++
        SA1->(DbSkip())
ENDDO

SA1->(DbCloseArea())

    IF Len(::WsListaClientes:aRegsClientes) > 0
        ::WsListaClientes:cRet          :=  "[T]"
        ::WsListaClientes:cMessage      :=  "Dados de clientes retornados com sucesso!"
    ELSE
        ::WsListaClientes:cRet          :=  "[F]"
        ::WsListaClientes:cMessage      :=  "FALHA! N�o existem dados para esta consulta!"
    ENDIF

ENDIF
RETURN .T.
