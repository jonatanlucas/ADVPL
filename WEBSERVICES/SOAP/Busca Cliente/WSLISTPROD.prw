#include 'Protheus.ch'
#include 'APWEBSRV.ch'
#include 'TOPCONN.ch'


//Estrutura de Dados
WSSTRUCT STProdutoSQL
    WSDATA produtoB1CODIGO              AS STRING     OPTIONAL
    WSDATA produtoB1DESCRICAO           AS STRING     OPTIONAL
    WSDATA produtoB1UM                  AS STRING     OPTIONAL  
    WSDATA produtoB1TIPO                AS STRING     OPTIONAL
    WSDATA produtoB1NCM                 AS STRING     OPTIONAL
    WSDATA produtoB1GRUPO               AS STRING     OPTIONAL
ENDWSSTRUCT

//Array e retorno
WSSTRUCT STListProdutosSQL
    WSDATA aRegsProdutos            AS ARRAY OF STProdutoSQL

    WSDATA cRet                     AS STRING OPTIONAL
    WSDATA cMessage                 AS STRING OPTIONAL
ENDWSSTRUCT

WSSERVICE   WSLISTPRODUTOS DESCRIPTION "Lista os produtos do Protheus com base nos parametros passados e Token Válido"
    //Parametros de Entrada
    WSDATA cProdutoDe       AS STRING
    WSDATA cProdutoAte      AS STRING
    WSDATA cToken           AS STRING

    //Estrutura de Saída
    WSDATA WsListaProdutos AS STListProdutosSQL

    //Métodos
    WSMETHOD BuscaProdutos  DESCRIPTION "Busca os produtos do Protheus, através de query SQL, com base nos parametros"
ENDWSSERVICE
