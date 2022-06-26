#include "Protheus.ch"
#include "FwMvcDef.ch"

/*/{Protheus.doc} User Function MVCZ2Z3
    (long_description)
    @type  Function
    @author Jonatan
    @since 26/06/2022
    @version version
    @return 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MVCZ2Z3()
Local oBrowse := FwLoadBrw("MVCZ2Z3") //Digo o fonte que eu estou buscando o BrowseDef

//Ativo o Browse
oBrowse:Activate()

Return 

/*/{Protheus.doc} BrowseDef
Fun??oo respons?vel por criar o Brose e retorno-lo para o Menu que invoc?-lo
Quando eu tenho uma Static Function BrowseDef no meu fonte, significa
que eu posso emprest?-la para outros fontes, atrav?s do FwLoadBr
    @type  Static Function
    @author Jonatan
    @since 26/06/2022
    @version version
    @param , param_type, param_descr
    @return oBrowse , object, objetoBrowse
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function BrowseDef()
Local aArea := GetArea()

Local oBrowse := FwMBrowse():New() 

oBrowse:SetAlias("SZ2")
oBrowse:SetDescription("Cadastro de Chamados")

oBrowse:AddLegend("SZ2->Z2_STATUS == '1'","GREEN"   ,"Chamado Aberto")
oBrowse:AddLegend("SZ2->Z2_STATUS == '2'","RED"     ,"Chamado Finalizado")
oBrowse:AddLegend("SZ2->Z2_STATUS == '3'","YELLOW"  ,"Chamado em Andamento")

//Deve definir de onde vir˜ o MenuDef devo chamar o meu menu
oBrowse:SetMenudef("MVCZ2Z3") //Coloco o fonte de onde vir˜ o meu menu

RestArea(aArea)

Return oBrowse 

/*/{Protheus.doc} MenuDef
    (long_description)
    @type  Static Function
    @author Jonatan
    @since 26/06/2022
    @version version
    @param , param_type, param_descr
    @return aMenu, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function MenuDef()
Local aMenu     := {}


//Trago atrav˜s da FwMvcMenu, o menu para o array aMenuAut
Local aMenuAut      := FwMvcMenu("MVCZ2Z3")   

/*Adiciono dentro da vari?vel aMenu, o t?tulo Legenda e Sobre, junto com a a˜˜o
de chamar as UserFunctions de legenda e Sobre, essas opera˜˜es s˜o de c˜digo 6, e
eu passo o n˜vel de usu˜rio 0
*/
ADD OPTION aMenu TITLE 'Legenda'      ACTION 'u_SZ2LEG'         OPERATION 6 ACCESS 0
ADD OPTION aMenu TITLE 'Sobre'        ACTION 'u_SZ2SOBRE'       OPERATION 6 ACCESS 0

/*Utilizo um la˜o de repeti˜˜o para adicionar ˜ vari˜vel aMenu, 
o que eu criai automaticamente para a vari˜vel aMenuAut*/

For n:= 1 to Len(aMenuAut)
    aAdd(aMenu,aMenuAut[n])
Next n


Return aMenu


/*/{Protheus.doc} ModelDef
    (long_description)
    @type  Static Function
    @author Jonatan
    @since 26/06/2022
    @version version
    @param , param_type, param_descr
    @return oModel, object, objeto modelo
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function ModelDef()
//Declaro o meu modelo de dados sem passar blocos de valida˜˜o pois usaremos a valida˜˜o padr˜o do MVC
Local oModel := MPFormModel():New("MVCZ23M",/*bPre*/,  /*bPos*/,  /*bCommit*/,/*bCancel*/)

//Crio as estruturas das tabelas PAI(SZ2) e FILHO(SZ3)
Local oStPaiZ2      := FwFormStruct(1,"SZ2")
Local oStFilhoZ3    := FwFormStruct(1,"SZ3")

//Ap˜s declarar a estrutura de dados, eu posso modificar o campo com SetProperty

oStFilhoZ3:SetProperty("Z3_CHAMADO",MODEL_FIELD_INIT,FwBuildFeature(STRUCT_FEATURE_INIPAD, "SZ2->Z2_COD"))


//Crio Modelos de dados Cabe˜alho e Item
oModel:AddFields("SZ2MASTER",,oStPaiZ2)
oModel:AddGrid("SZ3DETAIL","SZ2MASTER",oStFilhoZ3,,,,,)//ESSAS v˜rgulas em branco, s˜o blocos de valida˜˜o que n˜o vamos usar

//O meu grid, ir˜ se relacionar com o cabe˜alho, atrav˜s dos campos FILIAL e CODIGO DE CHAMADO
oModel:SetRelation("SZ3DETAIL",{{"Z3_FILIAL","xFilial('SZ2')"},{"Z3_CHAMADO","Z2_COD"}},SZ3->(IndexKey(1)))

//Setamos a chave prim˜ria, prevalece o que est˜ na SX2(X2_UNICO), se na X2 estiver preenchido
//N˜o podemos ter dentro de uma chamado, dois coment˜rios com o mesmo c˜digo
oModel:SetPrimaryKey({"Z3_FILIAL","Z3_CHAMADO","Z3_CODIGO"})

//Combina˜˜o de campos que n˜o podem se repetir, ficarem iguais
oModel:GetModel("SZ3DETAIL"):SetUniqueLine({"Z3_CHAMADO","Z3_CODIGO"})

oModel:SetDescription("Modelo 3 - Sistema de Chamados")
oModel:GetModel("SZ2MASTER"):SetDescription("CABE?ALHO DO CHAMADO")
oModel:GetModel("SZ3DETAIL"):SetDescription("COMENT?RIOS DO CHAMADO")

/*
Como n˜o vamos manipular aCols nem aHeader, n˜o vou usar o SetOldGrid
*/

Return oModel


/*/{Protheus.doc} ViewDef
    (long_description)
    @type  Static Function
    @author Jonatan
    @since 26/06/2022
    @version version
    @param , param_type, param_descr
    @return oView, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function ViewDef()
Local oView     := Nil

//Invoco o Model da fun˜˜o que quero
Local oModel    := FwLoadModel("MVCZ2Z3")

/*
A grande diferen˜a das estruturas de dados do modelo 2 para o modelo 3, ˜ que no modelo 2
a estrutura de dados do cabe˜alho ˜ tempor˜ria/imagin˜ria/fict˜cia, j˜aaaaaaaa no modelo 3/x
todas as estruturas de dados, tendem ˜ ser REAIS, ou seja, importamos via FwFormStruct, a(s) tabela(s)
propriamente ditas
*/
Local oStPaiZ2      := FwFormStruct(2,"SZ2")
Local oStFilhoZ3    := FwFormStruct(2,"SZ3")

//Removo o campo para n˜o aparecer, j˜ que ele estar˜ sendo preenchido automaticamente pelo c˜digo do chamado do cabe˜alho
oStFilhoZ3:RemoveField("Z3_CHAMADO")

//Travo o campo de Codigo para n˜o ser editado, ou seja, o campo CODIGO DE COMENTARIO do chamado, ser˜ autom˜tico e n˜o poder˜ ser modificado
oStFilhoZ3:SetProperty("Z3_CODIGO",    MVC_VIEW_CANCHANGE, .F.)



//Fa˜o a instancia da fun˜˜o FwFormView para a vari˜vel oView
oView   := FwFormView():New()

//Carrego o model importado para a View
oView:SetModel(oModel)

//Crio as views de cabe˜alho e item, com as estruturas de dados criadas acima
oView:AddField("VIEWSZ2",oStPaiZ2,"SZ2MASTER")
oView:AddGrid("VIEWSZ3",oStFilhoZ3,"SZ3DETAIL")

//Fa˜o o campo de Item ficar incremental
oView:AddIncrementField("SZ3DETAIL","Z3_CODIGO") //Soma 1 ao campo de Item

//Criamos os BOX horizontais para CABE?ALHO E ITENS
oView:CreateHorizontalBox("CABEC",60)
oView:CreateHorizontalBox("GRID",40)

//Amarro as views criadas aos BOX criados
oView:SetOwnerView("VIEWSZ2","CABEC")
oView:SetOwnerView("VIEWSZ3","GRID")

//Darei t˜tulos personalizados ao cabe˜alho e coment˜rios do chamado
oView:EnableTitleView("VIEWSZ2","Detalhes do Chamado/Cabe?alho")
oView:EnableTitleView("VIEWSZ3","Coment?rios do do chamado/Itens")

Return oView



User Function SZ2LEG()
Local aLegenda := {}

aAdd(aLegenda,{"BR_VERDE","Chamado Aberto"})
aAdd(aLegenda,{"BR_AMARELO" , 	"Chamado em Andamento"})
aAdd(aLegenda,{"BR_VERMELHO", 	"Chamado Finalizado"})

BrwLegenda("Status dos Chamados",,aLegenda)

return aLegenda


User Function SZ2SOBRE()
Local cSobre

cSobre := "-<b>Minha primeira tela em MVC Modelo 3<br>"+;
"Este Sistema de Chamados foi desenvolvido por Jonatan Lucas."

MsgInfo(cSobre,"Sobre o Programador...")

return
