#include "Protheus.ch"
#include "APWEBSRV.ch" //Include principal dos WebServices
#include "TOPCONN.ch"

/*Estrutura de dados que ser� retornada pelo WebService na chamada pelo CLIENT*/
WSSTRUCT STCliente
    WSDATA clienteA1COD         AS STRING OPTIONAL
    WSDATA clienteA1LOJA        AS STRING OPTIONAL
    WSDATA clienteA1NOME        AS STRING OPTIONAL
    WSDATA clienteA1CPF         AS STRING OPTIONAL
    WSDATA clienteA1END         AS STRING OPTIONAL
    WSDATA clienteA1BAIRRO      AS STRING OPTIONAL
    WSDATA clienteA1MUNICIP     AS STRING OPTIONAL
    WSDATA clienteA1ESTADO      AS STRING OPTIONAL
    WSDATA clienteA1CEP         AS STRING OPTIONAL
ENDWSSTRUCT 

//Estrutura de retorno sucesso/sem sucesso
WSSTRUCT STRetMsg
    WSDATA cRet                 AS STRING OPTIONAL
    WSDATA cMessage             AS STRING OPTIONAL
ENDWSSTRUCT


//REtorno do WebService
WSSTRUCT STRetornoGeral
    WSDATA WSSTClient   AS STCliente
    WSDATA WsSTRetMsg   AS STRetMsg
ENDWSSTRUCT


WSSERVICE WSCLISA1 DESCRIPTION "Servi�o para retornar os dados de cliente espec�fico da Protheuzeiro Strong"
    
    //C�digo que ser� requisitado pelo m�todo de Busca do Cliente
    WSDATA _cCodClienteLoja     AS STRING

    //Chamada da estrutura de retorno que ser� retornada pelo m�todo
    WSDATA WSRetornoGeral       AS STRetornoGeral
    // Estrutura de entrada e retorno do m�todo incluirCliente
    WSDATA WsDadosCli           AS STCliente  //Entrada do M�todo
    WSDATA WsRetInclusao        AS STRetMsg   //Retorno do M�todo
    WSDATA cToken               AS STRING     //Entrada do M�todo


    WSMETHOD BuscaCliente      DESCRIPTION "Busca clientes da tabela SA1 com base no C�digo e Loja"

    WSMETHOD incluirCliente    DESCRIPTION "Incluir dados de cliente na base de dados do Protheus/SA1"
ENDWSSERVICE 


//          M�TODO          PARAMETRO DE ENTRADA        RETORNO DO WS          WS A QUAL PERTENCE
WSMETHOD    BuscaCliente    WSRECEIVE _cCodClienteLoja  WSSEND  WSRetornoGeral WSSERVICE WSCLISA1
Local cCliCodLoja  := ::_cCodClienteLoja

DbSelectArea("SA1")
SA1->(DbSetOrder(1))

//Se ele encontrar, popula a estrutura de dados WSSTRUCT STCliente atrav�s do WsRetornoGeral
IF SA1->(DbSeek(xFilial("SA1")+cCliCodLoja))
    ::WsRetornoGeral:WsSTRetMsg:cRet                := "[T]"
    ::WsRetornoGeral:WsSTRetMsg:cMessage            := "Sucesso! Registro encontrado, dados listados."
    ::WSRetornoGeral:WSSTClient:clienteA1COD        := SA1->A1_COD
    ::WSRetornoGeral:WSSTClient:clienteA1LOJA       := SA1->A1_LOJA    
    ::WSRetornoGeral:WSSTClient:clienteA1NOME       := SA1->A1_NOME
    ::WSRetornoGeral:WSSTClient:clienteA1CPF        := SA1->A1_CGC
    ::WSRetornoGeral:WSSTClient:clienteA1END        := SA1->A1_END
    ::WSRetornoGeral:WSSTClient:clienteA1BAIRRO     := SA1->A1_BAIRRO
    ::WSRetornoGeral:WSSTClient:clienteA1MUNICIP    := SA1->A1_MUN
    ::WSRetornoGeral:WSSTClient:clienteA1ESTADO     := SA1->A1_EST
    ::WSRetornoGeral:WSSTClient:clienteA1CEP        := SA1->A1_CEP
ELSE 
    ::WsRetornoGeral:WsSTRetMsg:cRet                := "[F]"
    ::WsRetornoGeral:WsSTRetMsg:cMessage            := "Falha! N�o existe registro relacionado � esta entrada(C�digo + Loja)"

ENDIF

SA1->(DbCloseArea())

RETURN .T.

WSMETHOD IncluirCliente WSRECEIVE cToken, WsDadosCli WSSEND WsRetInclusao WSSERVICE WSCLISA1
Local cTokenDefault  := "jonatan"

//Capturamos os dados que est�o sendo enviados e jogamos em vari�veis
Local cA1COD    := Replace(::WsDadosCli:clienteA1COD,"?","")
Local cA1LOJA   := Replace(::WsDadosCli:clienteA1LOJA,"?","")
Local cA1NOME   := Replace(::WsDadosCli:clienteA1NOME,"?","")
Local cA1CPF    := Replace(::WsDadosCli:clienteA1CPF,"?","")
Local cA1END    := Replace(::WsDadosCli:clienteA1END,"?","")
Local cA1BAIRRO := Replace(::WsDadosCli:clienteA1BAIRRO,"?","")
Local cA1MUN    := Replace(::WsDadosCli:clienteA1MUNICIP,"?","")
Local cA1EST    := Replace(::WsDadosCli:clienteA1ESTADO,"?","")
Local cA1CEP    := Replace(::WsDadosCli:clienteA1CEP,"?","")

IF Empty(::cToken)
    SetSoapFault("Token n�o informado","Opera��o n�o permitida!")
    RETURN .F.
ELSEIF cTokenDefault <> ::cToken
    SetSoapFault("Token inv�lido, informe o Token correto","Opera��o n�o permitida!")
    RETURN .F.
ELSE
    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))

    //Verificar se os dados enviados est�o vazios
    IF Empty(cA1COD) .OR. Empty(cA1LOJA) .OR. Empty(cA1NOME) .OR. Empty(cA1CPF) .OR. Empty(cA1END) .OR. Empty(cA1BAIRRO) .OR. Empty(cA1MUN) .OR. Empty(cA1EST) .OR. Empty(cA1CEP)
        ::WsRetInclusao:cRet        := "902"
        ::WsRetInclusao:cMessage    := "OPERA��O N�O PERMITIDA! EXISTEM DADOS VAZIOS, TODOS OS DADOS DE ENTRADA S�O OBRIGAT�RIOS"
    //Verificar se o cliente j� n�o existe no banco de dados
    ELSEIF SA1->(DbSeek(xFilial("SA1")+cA1COD+cA1LOJA))
        ::WsRetInclusao:cRet        := "901"
        ::WsRetInclusao:cMessage    := "OPERA��O N�O PERMITIDA! CLIENTE/LOJA J� EXISTE NO BANCO DE DADOS"
    ELSE
        RecLock("SA1",.T.) //Reclock de inclus�o .T.
            SA1->A1_COD           := cA1COD
            SA1->A1_LOJA          := cA1LOJA
            SA1->A1_NOME          := cA1NOME 
            SA1->A1_CGC           := cA1CPF
            SA1->A1_END           := cA1END
            SA1->A1_BAIRRO        := cA1BAIRRO
            SA1->A1_MUN           := cA1MUN
            SA1->A1_EST           := cA1EST 
            SA1->A1_CEP           := cA1CEP
        SA1->(MsUnlock())

        ::WSRetInclusao:cRet        := "903"
        ::WsRetInclusao:cMessage    := "OPERA��O CONCLU�DA COM SUCESSO! OS SEUS DADOS FORAM ENVIADOS PARA TOTVS PROTHEUS"
    ENDIF

    SA1->(DbCloseArea())
ENDIF


Return .T.
