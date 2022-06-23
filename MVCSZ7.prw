#include 'Protheus.ch'
#include 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCSZ7
    Funÿÿo principal para a construÿÿo da tela de Solicitaÿÿo de  Compras da empresa
    Protheuzeiro Strong S/A, como base na proposta fictÿcia do treinamento da Sistematizei
    @type  Function
    @author Jonatan Lucas
    @since 20/01/2021
    @version version
    @see (links_or_references)
    /*/
User Function MVCSZ7()
Local aArea     := GetArea()

/*Farÿ o instanciamento da classe FwmBrowse, passando
 para o oBrowse a possibilidade de executar todos os mÿtodos da classe
*/
Local oBrowse   := FwmBrowse():New() 

oBrowse:SetAlias("SZ7")
oBrowse:SetDescription("Solicita??o de Compras")

oBrowse:Activate()

RestArea(aArea)

Return 


/*/{Protheus.doc} MenuDef
    (long_description)
    @type  Static Function
    @author user
    @since 21/01/2021
    @version version
    @param , param_type, param_descr
    @return aRotina, array, array com Opÿÿes do Menu
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function MenuDef()
//Primeira Opÿÿo de Menu
Local aRotina := FwMvcMenu("MVCSZ7")

/*Segunda Opÿÿo de Menu
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.MVCSZ7'   OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.MVCSZ7'   OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.MVCSZ7'   OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.MVCSZ7'   OPERATION 5 ACCESS 0

//1- pesquisar
//2- visualizar
//3- incluir
//4- alterar
//5- excluir
//6- outras funÿÿes
//7- copiar
*/

/*Terceira Opÿÿo de Menu
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.MVCSZ7'  OPERATION  MODEL_OPERATION_VIEW      ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.MVCSZ7'  OPERATION  MODEL_OPERATION_INSERT    ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.MVCSZ7'  OPERATION  MODEL_OPERATION_UPDATE    ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.MVCSZ7'  OPERATION  MODEL_OPERATION_DELETE    ACCESS 0
*/

Return aRotina



/*/{Protheus.doc} ModelDef
    Static function responsÿvel pela criaÿÿo do modelo de dados
    @type  Static Function
    @author user
    @since 20/01/2021
    @version version
    @return oModel, return_type, return_description
    @see https://tdn.totvs.com/display/framework/FWFormModelStruct
    @see https://tdn.totvs.com/display/framework/FWFormStruct
    @see https://tdn.totvs.com/display/framework/MPFormModel
    @see https://tdn.totvs.com/display/framework/FWBuildFeature    
    @see https://tdn.totvs.com/display/framework/FWFormGridModel
    /*/
Static Function ModelDef()
//Objeto responsÿvel pela CRIAÿÿO da estrutura TEMPORÿRIA do cabeÿalho 
Local oStCabec      := FWFormModelStruct():New()

//Objeto responsÿvel pela estrutura dos itens
Local oStItens      := FwFormStruct(1,"SZ7") //1 para model 2 para view


Local bVldCom       := {|| u_GrvSZ7()} //Chamada da User Function Commit que validarÿ a INCLUSÿO/ALTERAÿÿO/EXCLUSÿO dos itens


/*Objeto principal do desenvolvimento em MVC MODELO2, ele traz as caracterÿsticas do dicionÿrio de dados
bem como ÿ o responsÿvel pela estrutura de tabelas, campos e registros*/
Local oModel        := MPFormModel():New("MVCSZ7m",/*bPre*/, /*bPos*/, bVldCom /*bCommit*/,/*bCancel*/)

//Criaÿÿo da tabela temporÿria que serÿ utilizada no cabeÿalho
oStCabec:AddTable("SZ7",{"Z7_FILIAL","Z7_NUM","Z7_ITEM"},"Cabeÿalho SZ7")

//Criaÿÿo dos campos da tabela temporÿria
oStCabec:AddField(;
    "Filial",;                                                                                  // [01]  C   Titulo do campo
    "Filial",;                                                                                  // [02]  C   ToolTip do campo
    "Z7_FILIAL",;                                                                               // [03]  C   Id do Field
    "C",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_FILIAL")[1],;                                                                    // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de validaÿÿo do campo
    Nil,;                                                                                       // [08]  B   Code-block de validaÿÿo When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatÿrio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_FILIAL,FWxFilial('SZ7'))" ),;   // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operaÿÿo de update.
    .F.)                                                                                        // [14]  L   Indica se o campo ÿ virtual

oStCabec:AddField(;
    "Pedido",;                                                                                  // [01]  C   Titulo do campo
    "Pedido",;                                                                                  // [02]  C   ToolTip do campo
    "Z7_NUM",;                                                                                  // [03]  C   Id do Field
    "C",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_NUM")[1],;                                                                       // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de validaÿÿo do campo
    Nil,;                                                                                       // [08]  B   Code-block de validaÿÿo When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatÿrio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_NUM,'')" ),;                    // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operaÿÿo de update.
    .F.)                                                                                        // [14]  L   Indica se o campo ÿ virtual

oStCabec:AddField(;
    "Emissao",;                                                                     // [01]  C   Titulo do campo
    "Emissao",;                                                                     // [02]  C   ToolTip do campo
    "Z7_EMISSAO",;                                                                  // [03]  C   Id do Field
    "D",;                                                                           // [04]  C   Tipo do campo
    TamSX3("Z7_EMISSAO")[1],;                                                       // [05]  N   Tamanho do campo
    0,;                                                                             // [06]  N   Decimal do campo
    Nil,;                                                                           // [07]  B   Code-block de validaÿÿo do campo
    Nil,;                                                                           // [08]  B   Code-block de validaÿÿo When do campo
    {},;                                                                            // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                           // [10]  L   Indica se o campo tem preenchimento obrigatÿrio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_EMISSAO,dDataBase)" ),;    // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                           // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                           // [13]  L   Indica se o campo pode receber valor em uma operaÿÿo de update.
    .F.)                                                                            // [14]  L   Indica se o campo ÿ virtual


oStCabec:AddField(;
    "Fornecedor",;                                                              // [01]  C   Titulo do campo
    "Fornecedor",;                                                              // [02]  C   ToolTip do campo
    "Z7_FORNECE",;                                                              // [03]  C   Id do Field
    "C",;                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_FORNECE")[1],;                                                   // [05]  N   Tamanho do campo
    0,;                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                       // [07]  B   Code-block de validaÿÿo do campo
    Nil,;                                                                       // [08]  B   Code-block de validaÿÿo When do campo
    {},;                                                                        // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatÿrio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_FORNECE,'')" ),;// [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                       // [13]  L   Indica se o campo pode receber valor em uma operaÿÿo de update.
    .F.)                                                                        // [14]  L   Indica se o campo ÿ virtual

oStCabec:AddField(;
    "Loja",;                                                                      // [01]  C   Titulo do campo
    "Loja",;                                                                      // [02]  C   ToolTip do campo
    "Z7_LOJA",;                                                                   // [03]  C   Id do Field
    "C",;                                                                         // [04]  C   Tipo do campo
    TamSX3("Z7_LOJA")[1],;                                                        // [05]  N   Tamanho do campo
    0,;                                                                           // [06]  N   Decimal do campo
    Nil,;                                                                         // [07]  B   Code-block de validaÿÿo do campo
    Nil,;                                                                         // [08]  B   Code-block de validaÿÿo When do campo
    {},;                                                                          // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                         // [10]  L   Indica se o campo tem preenchimento obrigatÿrio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_LOJA,'')" ),;     // [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                         // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                         // [13]  L   Indica se o campo pode receber valor em uma operaÿÿo de update.
    .F.)                                                                          // [14]  L   Indica se o campo ÿ virtual

oStCabec:AddField(;
    "Usuario",;                                                                     // [01]  C   Titulo do campo
    "Usuario",;                                                                     // [02]  C   ToolTip do campo
    "Z7_USER",;                                                                     // [03]  C   Id do Field
    "C",;                                                                           // [04]  C   Tipo do campo
    TamSX3("Z7_USER")[1],;                                                          // [05]  N   Tamanho do campo
    0,;                                                                             // [06]  N   Decimal do campo
    Nil,;                                                                           // [07]  B   Code-block de validaÿÿo do campo
    Nil,;                                                                           // [08]  B   Code-block de validaÿÿo When do campo
    {},;                                                                            // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                           // [10]  L   Indica se o campo tem preenchimento obrigatÿrio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_USER,__cuserid)" ),;// [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                           // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                           // [13]  L   Indica se o campo pode receber valor em uma operaÿÿo de update.
    .F.)                                                                            // [14]  L   Indica se o campo ÿ virtual

//Agora vamos tratar a estrutura dos Itens, que serÿo utilizados no Grid da aplicaÿÿo

//Modificando Inicializadores Padrao,  para nÿo dar mensagem de colunas vazias
oStItens:SetProperty("Z7_NUM",      MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
oStItens:SetProperty("Z7_USER",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '__cUserId')) //Trazer o usuÿrio automatico
oStItens:SetProperty("Z7_EMISSAO",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'dDatabase')) //Trazer a data automÿtica
oStItens:SetProperty("Z7_FORNECE",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
oStItens:SetProperty("Z7_LOJA",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))

/*A partir de agora, eu faÿo a uniÿo das estruturas, vinculando o cabeÿalho com os itens
tambÿm faÿo a vinculaÿÿo da Estrutura de dados dos itens, ao modelo
*/

oModel:AddFields("SZ7MASTER",,oStCabec) //Faÿo a vinculaÿÿo com o oStCabe(cabeÿalho e itens temporÿrios)
oModel:AddGrid("SZ7DETAIL","SZ7MASTER",oStItens,,,,,)


//Seto a relaÿÿo entre cabeÿaho e item, neste ponto, eu digo atravÿs de qual/quais campo(s) o grid estÿ vinculado com o cabeÿalho
aRelations := {}
aAdd(aRelations,{"Z7_FILIAL",'Iif(!INCLUI, SZ7->Z7_FILIAL, FWxFilial("SZ7"))'})
aAdd(aRelations,{"Z7_NUM","SZ7->Z7_NUM"})
oModel:SetRelation("SZ7DETAIL",aRelations,SZ7->(IndexKey(1)))

oModel:SetRelation('SZ7DETAIL',{{'Z7_FILIAL','Iif(!INCLUI, SZ7->Z7_FILIAL, FWxFilial("SZ7"))'},{'Z7_NUM','SZ7->Z7_NUM'}},SZ7->(IndexKey(1)))

//Seto a chave primÿria, lembrando que, se ela estiver definida no X2_UNICO, faz valer o que estÿ no X2_UNICO
oModel:SetPrimaryKey({})

//ÿ como se fosse a "chave primÿria do GRID"
oModel:GetModel("SZ7DETAIL"):SetUniqueline({"Z7_ITEM"}) //o intuito ÿ que este campo nÿo se repita

//Setamos a descriÿÿo/tÿtulo que aparecerÿ no cabeÿalho 
oModel:GetModel("SZ7MASTER"):SetDescription("CABEÿALHO DA SOLICITAÿÿO DE COMPRAS")

//Setamos a descriÿÿo/tÿtulo que aparecerÿ no GRID DE ITENS
oModel:GetModel("SZ7DETAIL"):SetDescription("ITENS DA SOLICITAÿÿO DE COMPRAS")

//Finalizamos a funÿÿo model
oModel:GetModel("SZ7DETAIL"):SetUseOldGrid(.T.) //Finalizo setando o modelo antigo de Grid, que permite pegar aHeader e aCols

Return oModel


/*/{Protheus.doc} ViewDef
    (long_description)
    @type  Static Function
    @author user
    @since 21/01/2021
    @version version
    @return oView, objeto, Objeto de Visualizaÿÿo do fonte MVC
    @see https://tdn.totvs.com/display/framework/FWFormView
    /*/
Static Function ViewDef()
Local oView         := Nil

/*Faÿo o Load do Movel referente ÿ funÿÿo/fonte MVCSZ7, sendo assim se este Model
 estivesse em um outro fonte eu poderia pegar de lÿ, sem ter que copiar tudooo de novo
 */
Local oModel        := FwLoadModel("MVCSZ7")

//Objeto encarregado de montar a estrutura temporÿria do cabeÿalho da View
Local oStCabec      := FwFormViewStruct():New()

/* Objeto responsÿvel por montar a parte de estrutura dos itens/grid
Como estou usando FwFormStruct, ele traz a estrutura de TODOS OS CAMPOS, sendo assim
caso eu nÿo queira que algum campo, apareÿa na minha grid, eu devo remover este campo com RemoveField
*/
Local oStItens      := FwFormStruct(2,"SZ7") //1 para model 2 para view

//Crio dentro da estrutura da View, os campos do cabeÿalho

oStCabec:AddField(;
    "Z7_NUM",;                  // [01]  C   Nome do Campo
    "01",;                      // [02]  C   Ordem
    "Pedido",;                  // [03]  C   Titulo do campo
    X3Descric('Z7_NUM'),;       // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_NUM"),;       // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;    	// [10]  L   Indica se o campo ÿ alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opÿÿo do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo ÿ virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)                        // [18]  L   Indica pulo de linha apÿs o campo

oStCabec:AddField(;
    "Z7_EMISSAO",;                // [01]  C   Nome do Campo
    "02",;                      // [02]  C   Ordem
    "Emissao",;                  // [03]  C   Titulo do campo
    X3Descric('Z7_EMISSAO'),;    // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "D",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_EMISSAO"),;    // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo ÿ alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opÿÿo do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo ÿ virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)  

oStCabec:AddField(;
    "Z7_FORNECE",;                  // [01]  C   Nome do Campo
    "03",;                          // [02]  C   Ordem
    "Fornecedor",;                  // [03]  C   Titulo do campo
    X3Descric('Z7_FORNECE'),;       // [04]  C   Descricao do campo
    Nil,;                           // [05]  A   Array com Help
    "C",;                           // [06]  C   Tipo do campo
    X3Picture("Z7_FORNECE"),;       // [07]  C   Picture
    Nil,;                           // [08]  B   Bloco de PictTre Var
    "SA2",;                         // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;         // [10]  L   Indica se o campo ÿ alteravel
    Nil,;                           // [11]  C   Pasta do campo
    Nil,;                           // [12]  C   Agrupamento do campo
    Nil,;                           // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                           // [14]  N   Tamanho maximo da maior opÿÿo do combo
    Nil,;                           // [15]  C   Inicializador de Browse
    Nil,;                           // [16]  L   Indica se o campo ÿ virtual
    Nil,;                           // [17]  C   Picture Variavel
    Nil) 

oStCabec:AddField(;
    "Z7_LOJA",;                 // [01]  C   Nome do Campo
    "04",;                      // [02]  C   Ordem
    "Loja",;                    // [03]  C   Titulo do campo
    X3Descric('Z7_LOJA'),;      // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_LOJA"),;      // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo ÿ alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opÿÿo do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo ÿ virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)

oStCabec:AddField(;
    "Z7_USER",;                 // [01]  C   Nome do Campo
    "05",;                      // [02]  C   Ordem
    "Usu?rio",;                 // [03]  C   Titulo do campo
    X3Descric('Z7_USER'),;      // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_USER"),;      // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    .F.,;                       // [10]  L   Indica se o campo ÿ alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opÿÿo do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo ÿ virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil) 

oStItens:RemoveField("Z7_NUM")
oStItens:RemoveField("Z7_EMISSAO")
oStItens:RemoveField("Z7_FORNECE")            
oStItens:RemoveField("Z7_LOJA")      
oStItens:RemoveField("Z7_USER") 

/*Agora vamos para a segunda parte da ViewDef, onde nÿs amarramos as estruturas de dados, montadas acima
com o objeto oView, e passamos para a nossa aplicaÿÿo todas as caracterÿsticas visuais do projetos
*/

//Instancio a classe FwFormView para o objeto view
oView := FwFormView():New()

//Passo para o objeto View o modelo de dados que quero atrelar ÿ ele Modelo + Visualizaÿÿo
oView:SetModel(oModel)

//Monto a estrutura de visualizaÿÿo do Master e do Detalhe (Cabeÿalho e Itens)
oView:AddField("VIEW_SZ7M",oStCabec,"SZ7MASTER") //Cabeÿalho/Master
oView:AddGrid("VIEW_SZ7D", oStItens,"SZ7DETAIL") //Itens/Grid

//Criamos a telinha, dividindo proporcionalmente o tamanho do cabeÿalho e o tamanho do Grid
oView:CreateHorizontalBox("CABEC",30)
oView:CreateHorizontalBox("GRID", 60)

/*Abaixo, digo para onde vÿo cada View Criada, VIEW_SZ7M irÿ para a cabec
VIEW_SZ7D irÿ para GRID... Sendo assim, eu associo o View ÿ cada Box criado
*/
oView:SetOwnerView("VIEW_SZ7M","CABEC") 
oView:SetOwnerView("VIEW_SZ7D","GRID") 

//Ativar o tÿtulos de cada VIEW/Box criado
oView:EnableTitleView("VIEW_SZ7M","Cabeÿalho Solicitaÿÿo de Compras")
oView:EnableTitleView("VIEW_SZ7D","Itens de Solicitacao de Compras")

/*Metodo que seta um bloco de cÿdigo para verificar se a janela deve ou nÿo
ser fechada apÿs a execuÿÿo do botÿo OK.
*/
oView:SetCloseOnOk({|| .T.})

Return oView



/*/{Protheus.doc} User Function GrvSZ7()
    (long_description)
    @type  Function
    @author user
    @since 22/01/2021
    @version version
    @return lRet, logical, Retorna TRUE ou FALSE para INCLUSAO, ALTERAÿÿO E EXCLUSÿO
    @example
    (examples)
    @see https://tdn.totvs.com/pages/viewpage.action?pageId=23889360
    @see https://tdn.totvs.com/display/tec/DBSkip
    /*/
User Function GrvSZ7()
Local aArea     := GetArea()  

//Variÿvel de controle da gravaÿÿo, por enquanto estÿ TRUE mas poderÿ ser FALSE
Local lRet      := .T.

//Capturo o modelo ativo, no caso o objeto de modelo(oModel) que estÿ sendo manipulado em nossa aplicaÿÿo
Local oModel        := FwModelActive()

//Criar modelo de dados MASTER/CABEÿALHO com base no model geral que foi capturado acima
//Carregando o modelo do CABEÿALHO
Local oModelCabec    := oModel:GetModel("SZ7MASTER")

/*Criar modelo de dados DETALHE/ITENS com base no model geral que foi capturado acima
Carregando o modelo dos ITENS
Este modelo serÿ responsÿvel, pela estrutura do aHeader aCols da Grid
*/
Local oModelItem     := oModel:GetModel("SZ7DETAIL") 


/*
Capturo os valores que estÿo no CABEÿALHO, atravÿs do mÿtodo GetValue
Carrego os campos dentro das variÿveis, estas variÿveis serÿo utilizadas para
inserir o que foi digitao na tela, dentro do banco
*/
Local cFilSZ7   :=  oModelCabec:GetValue("Z7_FILIAL")
Local cNum      :=  oModelCabec:GetValue("Z7_NUM")
Local dEmissao  :=  oModelCabec:GetValue("Z7_EMISSAO")
Local cFornece  :=  oModelCabec:GetValue("Z7_FORNECE")
Local cLoja     :=  oModelCabec:GetValue("Z7_LOJA")
Local cUser     :=  oModelCabec:GetValue("Z7_USER")

//Variÿveis que farÿo a captura dos dados com base no aHeader e aCols
Local aHeaderAux    := oModelItem:aHeader //Captura o aHeader do Grid
Local aColsAux      := oModelItem:aCols   //Captura o aCols do Grid

/*Precisamos agora pegar a posiÿÿo de cada campo dentro do grid
Lembrando que neste caso, sÿ precisamos pegar a posiÿÿo dos campos que nÿo
estÿo no cabeÿalho, somente os campos da GRID
*/
Local nPosItem      :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_ITEM")})
Local nPosProd      :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRODUTO")})
Local nPosQtd       :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_QUANT")})
Local nPosPrc       :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRECO")})
Local nPosTotal     :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_TOTAL")})

//Preciso pegar a linha atual que o usuÿrio estÿ posicionado, para isso usarei uma variÿvel
//Esta variÿvel irÿ para dentro do FOR
Local nLinAtu       := 0


//Preciso identificar qual o tipo de operaÿÿo que o usuÿrio estÿ fazendo(INCLUSÿO/ALTERAÿÿO/EXCLUSÿO)
Local cOption       := oModelCabec:GetOperation()

/*Fazemos a seleÿÿo da nossa ÿrea que serÿ manipulada, ou seja, 
colocamos a tabela SZ7, em evidÿncia juntamente com um ÿndice de ordenaÿÿo

OU SEJA...->>> VOCÿ FALA PAR A O PROTHEUS O SEGUINTE: 
"-E a? cara a partir de agora eu vou modificar a SZ7"=
*/

DbSelectArea("SZ7")
SZ7->(DbSetOrder(1)) //ÿNDICE FILIAL+NUMEROPEDIDO


//Se a operaÿÿo que estÿ sendo feita, for uma inserÿÿo, ele farÿ a inserÿÿo
IF cOption == MODEL_OPERATION_INSERT
    For nLinAtu:= 1 to Len(aColsAux) //Mede o tamanho do aCOls, ou seja quantos itens existem no grid
        //Porÿeeeeeem, antes de tentar inserir, eu devo verificar, se a linha estÿ deletada
        IF !aColsAux[nLinAtu][Len(aHeaderAux)+1] //Expressÿo para verificar se uma linha estÿ excluÿda no aCols(se nÿo estiver excluÿda ele prossegue)
            RecLock("SZ7",.T.) //.T. para inclusÿo .F. para alteraÿÿo/exclusÿo
                //DADOS DO CABEÿALHO
                Z7_FILIAL       :=  cFilSZ7 //Variÿvel com o dado da filial no cabeÿalho
                Z7_NUM          :=  cNum   //variÿvel com o dado do numero do pedido no cabeÿalho
                Z7_EMISSAO      :=  dEmissao
                Z7_FORNECE      :=  cFornece
                Z7_LOJA         :=  cLoja
                Z7_USER         :=  cUser

                //DADOS DO GRID
                Z7_ITEM         :=  aColsAux[nLinAtu,nPosItem] //array acols, posicionado na linha atual
                Z7_PRODUTO      :=  aColsAux[nLinAtu,nPosProd]
                Z7_QUANT        :=  aColsAux[nLinAtu,nPosQtd]
                Z7_PRECO        :=  aColsAux[nLinAtu,nPosPrc]
                Z7_TOTAL        :=  aColsAux[nLinAtu,nPosTotal] 
            SZ7->(MSUNLOCK())
        ENDIF
    Next n //Incremento de linha do for

ELSEIF  cOption == MODEL_OPERATION_UPDATE

    For nLinAtu:= 1 to Len(aColsAux) //Mede o tamanho do aCOls, ou seja quantos itens existem no grid
        //Por?eeeeeem, antes de tentar inserir, eu devo verificar, se a linha estÿ deletada
        IF aColsAux[nLinAtu][Len(aHeaderAux)+1] //Expressÿo para verificar se uma linha estÿ excluÿda no aCols(SE ESTIVER EXCLUÿDA ELE VERIFICA SE ESTÿ NO BANCO
            //Se a linha estiver deletada, eu ainda preciso verificar se a linha deletada estÿ inclusa ou nÿo no sistema
            SZ7->(DbSetOrder(2)) //ÿNDICE FILIAL+NUMEROPEDIDO+ITEM
            IF SZ7->(DbSeek(cFilSZ7 + cNum + aColsAux[nLinAtu,nPosItem])) //Faz a busca, se encontrar, ele deve deletar do banco
                RECLOCK("SZ7",.F.)
                    DbDelete()
                SZ7->(MSUNLOCK())
            ENDIF
        
        ELSE //SE A LINHA NÿO ESTIVER EXCLUÿDA, FAÿO A ALTERAÿÿO
        /*EMBORA SEJA UMA ALTERAÿÿO, EU POSSO TER NOVOS ITENS INCLUSOS NO MEU PEDIDO
        SENDO ASSIM, PRECISO VALIDAR SE ESTES ITENS EXISTEM NO BANCO DE DADOS OU NÿO
        CASO ELES NÿO EXISTAM, EU FAÿO UMA INCLUSÿO RECLOCK("SZ7",.T.)
        */
            SZ7->(DbSetOrder(2)) //ÿNDICE FILIAL+NUMEROPEDIDO+ITEM
            IF SZ7->(DbSeek(cFilSZ7 + cNum + aColsAux[nLinAtu,nPosItem])) //Faz a busca, se encontrar, ele FARÿ UMA ALTERAÿÿO
                RecLock("SZ7",.F.) //.T. para inclusÿo .F. para alteraÿÿo/exclusÿo
                    //DADOS DO CABEÿALHO
                    Z7_FILIAL       :=  cFilSZ7 //Variÿvel com o dado da filial no cabeÿalho
                    Z7_NUM          :=  cNum   //variÿvel com o dado do numero do pedido no cabeÿalho
                    Z7_EMISSAO      :=  dEmissao
                    Z7_FORNECE      :=  cFornece
                    Z7_LOJA         :=  cLoja
                    Z7_USER         :=  cUser
                    //DADOS DO GRID
                    Z7_ITEM         :=  aColsAux[nLinAtu,nPosItem] //array acols, posicionado na linha atual
                    Z7_PRODUTO      :=  aColsAux[nLinAtu,nPosProd]
                    Z7_QUANT        :=  aColsAux[nLinAtu,nPosQtd]
                    Z7_PRECO        :=  aColsAux[nLinAtu,nPosPrc]
                    Z7_TOTAL        :=  aColsAux[nLinAtu,nPosTotal] 
                SZ7->(MSUNLOCK())
            ELSE //SE ELE NÿO ACHAR, ÿ PORQUE O ITEM NÿO EXISTE AINDA NA BASE DE DADOS, LOGO IRÿ INCLUIR
                RecLock("SZ7",.T.) //.T. para inclusÿo .F. para alteraÿÿo/exclusÿo
                    //DADOS DO CABEÿALHO
                    Z7_FILIAL       :=  cFilSZ7 //Variÿvel com o dado da filial no cabeÿalho
                    Z7_NUM          :=  cNum   //variÿvel com o dado do numero do pedido no cabeÿalho
                    Z7_EMISSAO      :=  dEmissao
                    Z7_FORNECE      :=  cFornece
                    Z7_LOJA         :=  cLoja
                    Z7_USER         :=  cUser
                    //DADOS DO GRID
                    Z7_ITEM         :=  aColsAux[nLinAtu,nPosItem] //array acols, posicionado na linha atual
                    Z7_PRODUTO      :=  aColsAux[nLinAtu,nPosProd]
                    Z7_QUANT        :=  aColsAux[nLinAtu,nPosQtd]
                    Z7_PRECO        :=  aColsAux[nLinAtu,nPosPrc]
                    Z7_TOTAL        :=  aColsAux[nLinAtu,nPosTotal] 
                SZ7->(MSUNLOCK())            
            ENDIF        
        ENDIF
    Next n //Incremento de linha do for

ELSEIF cOption == MODEL_OPERATION_DELETE
    SZ7->(DbSetOrder(1)) //FILAL + NUMEROPEDIDO

    /*Ele vai percorrer todo arquivo, e enquanto a filial for igual a do pedido e o n?mero
    do pedido for igual ao n?mero que est? posicionado para exclur(pedido que voc? quer excluir)
    ele far? a DELE??O/EXCLUS?O DO REGISTROS
    */
    WHILE !SZ7->(EOF()) .AND. SZ7->Z7_FILIAL = cFilSZ7 .AND. SZ7->Z7_NUM = cNum 
        RECLOCK("SZ7",.F.) //PARAMETRO FALSE PORQUE ? EXCLUS?O
            DbDelete()
        SZ7->(MSUNLOCK())

    SZ7->(dbSkip())
    ENDDO

/* OUTRA FORMA DE EXCLUSÿO COM BASE NO QUE ESTÿ NO GRID.
    SZ7->(dbSetOrder(2))
    For nLinAtu := 1 to Len(aColsAux)
        //Regrinha para verificar se a linha est? exclu?da, se n?o tiver ir? incluir
        IF SZ7->(DbSeek(cFilSZ7+cNum+aColsAux[nLinAtu][nPosItem]))
            RECLOCK("SZ7",.F.)
                DbDelete()
            SZ7->(MsUnlock())
        Endif
    Next nLinAtu
*/	


ENDIF 

RestArea(aArea)
return lRet
