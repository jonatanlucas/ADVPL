#include 'Protheus.ch'
#include 'FWMVCDEF.ch' //Include principal do MVC


/*/{Protheus.doc} User Function MVCSZ9
    (long_description)
    @type  Function
    @author user
    @since 06/01/2021
    @version version
    @param , param_type, param_descr
    @return , return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MVCSZ9()
Local aArea := GetArea() 
Local oBrowseSZ9 //Varivel Objeto que receber o instanciamento da classe FwmBrose

oBrowseSZ9 := FwmBrowse():New()

//Passo como parametro a tabela que eu quero mostrar no Browse
oBrowseSZ9:SetAlias("SZ9") 

oBrowseSZ9:SetDescription("Meu primeiro Browse - Tela de Protheuzeiros SZ9")

//Faz com que somente estes campos apaream no GRID;
//oBrowseSZ9:SetOnlyFields({"Z9_CODIGO","Z9_NOME","Z9_SEXO","Z9_STATUS"}) 

                    /*EXPRESSAO             / COR    / DESCRIO*/
oBrowseSZ9:AddLegend("SZ9->Z9_STATUS == '1'","GREEN", "Protheuzeiro Ativo")
oBrowseSZ9:AddLegend("SZ9->Z9_STATUS == '2'","RED"  , "Protheuzeiro Inativo")

//oBrowseSZ9:SetFilterDefault("Z9_STATUS == '1'")

oBrowseSZ9:DisableDetails()

oBrowseSZ9:Activate()

RestArea(aArea)

Return 


/*/{Protheus.doc} MenuDef
    (long_description)
    @type  Static Function
    @author user
    @since 06/01/2021
    @version version
    @param , param_type, param_descr
    @return aRotina, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function MenuDef()
Local aRotina       := {}
Local aRotinaAut    := FwMvcMenu("MVCSZ9") //Recebe os menus automaticamente

//Populo a varivel aRotina
ADD OPTION aRotina TITLE 'Legenda'      ACTION 'u_SZ9LEG'         OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE 'Sobre'        ACTION 'u_SZ9SOBRE'       OPERATION 6 ACCESS 0


//Adiciona dentro do array aRotina, o contedo do array aRotinaAut
For n := 1 To Len(aRotinaAut)
    aAdd(aRotina,aRotinaAut[n])
Next n

Return aRotina


/*/{Protheus.doc} ModelDef
Static function ModelDef do meu programa em MVC
    @type  Static Function
    @author user
    @since 06/01/2021
    @version version
    @param , param_type, param_descr
    @return oModel, Objeto, Objeto da funo MVC meu modelo de Dados
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function ModelDef()
Local oModel := Nil

//traz a estrutura da SZ9(tabela e caracterstica dos campos), PARA O MODELO, por isso o parametro 1 no incio
Local oStructSZ9 := FwFormStruct(1,"SZ9") 

oModel := MPFormModel():New("MVCSZ9M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)

//Atribuindo formulario para o modelo de dados.
oModel:AddFields("FORMSZ9",/*Owner*/,oStructSZ9)

//Definindo chave primria para a aplicao
oModel:SetPrimaryKey({"Z9_FILIAL","Z9_CODIGO"})

oModel:SetDescription("Modelo de Dados do Cadastro de Protheuzeiro(a)")

oModel:GetModel("FORMSZ9"):SetDescription("Formulrio de Cadastro Protheuzeiro(a)")

Return oModel


/*/{Protheus.doc} ViewDef
    (long_description)
    @type  Static Function
    @author user
    @since 06/01/2021
    @version version
    @param , param_type, param_descr
    @return oView, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function ViewDef()
Local oView := Nil

//Funcao que retorna um objeto de model de determinado fonte.
Local oModel := FwLoadModel("MVCSZ9")

Local oStructSZ9 := FwFormStruct(2,"SZ9") //Traz a estrutura da SZ9 - (1 Model | 2 View)

//Removendo campo para o USURIO
oStructSZ9:RemoveField("Z9_ESTCIV")

//Construindo a parte de Viso dos Dados
oView := FwFormView():New()

//Passando o modelo de dados informado
oView:SetModel(oModel)

//Atribuio da estrutura de dados  camada de VISO
oView:AddField("VIEWSZ9",oStructSZ9,"FORMSZ9")

//Criando um container com o identificador TELA
oView:CreateHorizontalBox("TELASZ9",100)

//Adicionando titulo ao formulrio
oView:EnableTitleView("VIEWSZ9","Visualizao dos Protheuzeiros(as)")

//fora o fechamento da janela, PASSANDO O PARAMETRO .T.
oView:SetCloseOnOk({|| .T.})

oView:SetOwnerView("VIEWSZ9","TELASZ9")

Return oView


/*/{Protheus.doc} User Function SZ9LEG
    (long_description)
    @type  Function
    @author user
    @since 06/01/2021
    @version version
    @param , param_type, param_descr
    @return aLegenda, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function SZ9LEG()
Local aLegenda := {}

aAdd(aLegenda,{"BR_VERDE"   , "Ativo"})
aAdd(aLegenda,{"BR_VERMELHO", "Inativo"})

BrwLegenda("Protheuzeiros(as)","Ativos/Inativos",aLegenda)

Return aLegenda


/*/{Protheus.doc} User Function SZ9SOBRE
    (long_description)
    @type  Function
    @author user
    @since 06/01/2021
    @version version
    @param , param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function SZ9SOBRE()
Local cSobre 

cSobre := "-<b>Minha primeira tela em MVC Modelo 1<br> Este fonte foi desenvolvido por Jonatan Lucas."

MsgInfo(cSobre)

Return 
