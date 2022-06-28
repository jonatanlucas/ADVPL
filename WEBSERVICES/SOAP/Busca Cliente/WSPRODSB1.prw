#include 'Protheus.ch'
#include 'APWEBSRV.ch'
#include 'TOPCONN.ch'


//Código, descrição, Unidade de Medida. Tipo, NCM e Grupo;
//Estrutura de dados do Produto
WSSTRUCT StProduto
    WSDATA produtoB1COD             AS STRING OPTIONAL
    WSDATA produtoB1DESC            AS STRING OPTIONAL
    WSDATA produtoB1UM              AS STRING OPTIONAL
    WSDATA produtoB1TIPO            AS STRING OPTIONAL
    WSDATA produtoB1POSIPI          AS STRING OPTIONAL
    WSDATA produtoB1GRUPO           AS STRING OPTIONAL //Buscar da SBM através de Posicione
ENDWSSTRUCT

//Estrutura de Dados para retorno de mensagem
WSSTRUCT StRetMsgProd
    WSDATA cRet          AS STRING OPTIONAL
    WSDATA cMessage      AS STRING OPTIONAL
ENDWSSTRUCT


//Classe de dados para reotorno geral, aqui será uma ponte para as duas classes/estruturas acima
WSSTRUCT STRetGeralProd 
    WSDATA WsBuscaProd  AS StProduto
    WSDATA WsRetMsg     AS StRetMsgProd
ENDWSSTRUCT 

//Estrutura de dados da Quantidade e valor total de vendas
WSSTRUCT StProdVenda
    WSDATA produtoCODIGO          AS STRING   OPTIONAL  //B1_COD  
    WSDATA produtoDESCRICAO       AS STRING   OPTIONAL  //B1_DESC
    WSDATA produtoQTDTOTAL        AS INTEGER  OPTIONAL  /*D2_QUANT*/ 
    WSDATA produtoVALORTOTAL      AS FLOAT    OPTIONAL  /*D2_TOTAL*/  

    WSDATA cRet                   AS STRING   OPTIONAL
    WSDATA cMessage               AS STRING   OPTIONAL
ENDWSSTRUCT



WSSERVICE WSPRODSB1 DESCRIPTION "Serviço para retornar os dados de um Produto específico"
    //Parametros de entrada
    WSDATA _cCodProduto   AS STRING
    //Parametro de retorno Através deste dado, ele acessará a classe de dados StRetGeralProd, e através dela, acessará o StProduto eo StRetMsgProd
    WSDATA WsRetornoGeral  AS STRetGeralProd

    WSDATA WsBuscaProdVend AS StProdVenda

    //Método
    WSMETHOD BuscaProduto  DESCRIPTION "Lista dados do PRODUTO através do Código"

    WSMETHOD BuscaProdVend DESCRIPTION "Busca quantidade de produtos vendidos e total de vendas"

ENDWSSERVICE

WSMETHOD BuscaProduto WSRECEIVE _cCodProduto WSSEND WsRetornoGeral WSSERVICE WSPRODSB1

Local cCodProduto := ::_cCodProduto

DbSelectArea("SB1")
SB1->(DbSetOrder(1))

//Se encontrar vai retornar SUCESSO no WebService
    IF SB1->(DbSeek(xFilial("SB1")+cCodProduto))
        ::WSRetornoGeral:WsRetMsg:cRet                := "[T]"
        ::WSRetornoGeral:WsRetMsg:cMessage            := "Sucesso! O produto foi encontrado"

        ::WsRetornoGeral:WsBuscaProd:produtoB1COD     := SB1->B1_COD
        ::WsRetornoGeral:WsBuscaProd:produtoB1DESC    := SB1->B1_DESC
        ::WsRetornoGeral:WsBuscaProd:produtoB1UM      := SB1->B1_UM
        ::WsRetornoGeral:WsBuscaProd:produtoB1TIPO    := SB1->B1_TIPO
        ::WsRetornoGeral:WsBuscaProd:produtoB1POSIPI  := SB1->B1_POSIPI
        ::WsRetornoGeral:WsBuscaProd:produtoB1GRUPO   := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC")
//Senão, ele vai retornar falso
    ELSE
        ::WSRetornoGeral:WsRetMsg:cRet                := "[F]"
        ::WSRetornoGeral:WsRetMsg:cMessage            := "Falha! O produto não foi encontrado para o código especificado"
    ENDIF
SB1->(DbCloseArea())
RETURN .T.

WSMETHOD BuscaProdVend WSRECEIVE _cCodProduto WSSEND WsBuscaProdVend WSSERVICE WSPRODSB1

    Local cCodProduto := ::_cCodProduto

    //Variáveis que receberão os totais de quantidade e valor de venda dos produtos
    Local nQtdVend   := 0
    Local nTotalVend := 0

    //Selecionar tabela
    DbSelectArea("SD2")

    //Ordenar por índice 1
    SD2->(DbSetOrder(1))

    //Faço uma busca para ver se o produto existe dentro da SD2
    SD2->(DbSeek(xFilial("SD2")+cCodProduto))

    //EOF END OF FILE OU FINAL DO ARQUIVO
    While SD2->(!EOF()) .AND. SD2->D2_COD = cCodProduto
        
        //Vai incrementar os totais dentro dessas variáveis
        nQtdVend    += SD2->D2_QUANT
        nTotalVend  += SD2->D2_TOTAL
    //Passar para o próximo registro
    SD2->(DbSkip())
    ENDDO

    //Fecho a area aberta
    SD2->(DbCloseArea())

//Se ele achar o produto dentro da SD2, se tiver tido alguma venda, eu mostro no WebService
IF nQtdVend > 0
        ::WsBuscaProdVend:cRet                   := "[T]"
        ::WsBuscaProdVend:cMessage               := "Sucesso! O produto foi encontrado"

        ::WsBuscaProdVend:produtoCODIGO          := cCodProduto
        ::WsBuscaProdVend:produtoDESCRICAO       := Posicione("SB1",1,xFilial("SB1")+cCodProduto,"B1_DESC") //TRAZER A DESCRIÇÃO DO PRODUTO COM BASE NO CÓDIGO PASSADO
        ::WsBuscaProdVend:produtoQTDTOTAL        := nQtdVend
        ::WsBuscaProdVend:produtoVALORTOTAL      := nTotalVend
ELSE
        ::WsBuscaProdVend:cRet                := "[F]"
        ::WsBuscaProdVend:cMessage            := "Falha! O produto não foi encontrado para o código especificado"
ENDIF

Return .T.
