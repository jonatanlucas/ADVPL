#Include 'Protheus.ch'
#Include 'APWEBSRV.CH'
#Include 'TOPCONN.CH'


//ESTRUTURA DE DADOS
WSSTRUCT STProdutoSQL
    WSDATA produtoB1CODIGO          AS STRING OPTIONAL
    WSDATA produtoB1DESCRICAO       AS STRING OPTIONAL
    WSDATA produtoB1UM              AS STRING OPTIONAL
    WSDATA produtoB1TIPO            AS STRING OPTIONAL
    WSDATA produtoB1NCM             AS STRING OPTIONAL
    WSDATA produtoB1GRUPO           AS STRING OPTIONAL
ENDWSSTRUCT 


//ARRAY E RETORNO
WSSTRUCT STListProdutosSQL
    WSDATA aRegsProdutos            AS ARRAY OF STProdutoSQL

    WSDATA cRet                     AS STRING OPTIONAL
    WSDATA cMessage                 AS STRING OPTIONAL
ENDWSSTRUCT

WSSERVICE WSLISTPRODUTOS    DESCRIPTION "Lista os produtos do Protheus com base nos parametros passados e Token válido"
    //PARAMETROS DE ENTRADA
    WSDATA cProdutoDe       AS STRING
    WSDATA cProdutoAte      AS STRING
    WSDATA cToken           AS STRING

    //ESTRUTUA DE SAÍDA
    WSDATA WsListaProdutos  AS STListProdutosSQL

    //MÉTODOS
    WSMETHOD BuscaProdutos  DESCRIPTION "Busca os produtos do Protheus, através de query SQL, com base nos parametros"
ENDWSSERVICE 


WSMETHOD BuscaProdutos  WSRECEIVE cToken, cProdutoDe, cProdutoAte  WSSEND WsListaProdutos WSSERVICE WSLISTPRODUTOS
Local cCodProdDe        := ::cProdutoDe
Local cCodProdAte       := ::cProdutoAte
Local cTokenDefault     := "#souprotheuzeiro"
Local cAlias   
Local nIndex            := 1

IF Empty(::cToken)
    SetSoapFault("Token não informado","Operação não permitida!")
    RETURN .F.
ELSEIF cTokenDefault <> ::cToken
    SetSoapFault("Token inválido, informe o Token correto","Operação não permitida!")
    RETURN .F.
ELSE
    //Conserto caso tenha código de maior que código até
    IF cCodProdDe > cCodProdAte
        cCodProdDe        := ::cProdutoAte 
        cCodProdAte       := ::cProdutoDe
    ENDIF

    //Gerar um nome automático para o ALIAS
    cAlias := GetNextAlias()

    BeginSql Alias cAlias
        SELECT B1_COD, B1_DESC, B1_UM, B1_TIPO,B1_POSIPI, BM_DESC FROM %table:SB1% SB1 
        LEFT JOIN %table:SBM% SBM ON SB1.B1_GRUPO = BM_GRUPO 
        WHERE SB1.%notDel%  AND B1_COD BETWEEN %exp:cCodProdDe% AND %exp:cCodProdAte%
        ORDER BY B1_COD
    EndSql

    //Gerar um arquivo .SQL com o a query concatenaada com o filtro passado no parametro
    MemoWrite("WSLISTPROD.sql",GetLastQuery()[2])

    //Posicionar no primeiro registro
    (cAlias)->(dbGoTop())
    WHILE (cAlias)->(!Eof())

        //Criando a estruura de array com base na classe de dados criada no incio
        aAdd(::WsListaProdutos:aRegsProdutos,WsClassNew("STProdutoSQL"))    

        ::WsListaProdutos:aRegsProdutos[nIndex]:produtoB1CODIGO         := (cAlias)->B1_COD
        ::WsListaProdutos:aRegsProdutos[nIndex]:produtoB1DESCRICAO      := (cAlias)->B1_DESC
        ::WsListaProdutos:aRegsProdutos[nIndex]:produtoB1UM             := (cAlias)->B1_UM
        ::WsListaProdutos:aRegsProdutos[nIndex]:produtoB1TIPO           := (cAlias)->B1_TIPO
        ::WsListaProdutos:aRegsProdutos[nIndex]:produtoB1NCM            := (cAlias)->B1_POSIPI
        ::WsListaProdutos:aRegsProdutos[nIndex]:produtoB1GRUPO          := (cAlias)->BM_DESC


        //Passo pro próximo índice do array
        nIndex++
        //Passa para o próximo registro da tabela
        (cAlias)->(DbSkip())
    ENDDO

    (cAlias)->(DbCloseArea())

    IF LEN(::WsListaProdutos:aRegsProdutos) > 0
        ::WsListaProdutos:cRet            := "[T]"
        ::WsListaProdutos:cMessage        := "SUCESSO! A sua consulta retornou o total de "+cValToChar(LEN(::WsListaProdutos:aRegsProdutos))+" REGISTROS"
    ELSE
        ::WsListaProdutos:cRet            := "[F]"
        ::WsListaProdutos::cMessage        := "FALHA! Não foram encontrados registros para os seus parametros"
    ENDIF

ENDIF

RETURN .T.
