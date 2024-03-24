# carrega os pacotes necessários
library(leaflet)
library(sf)
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(tidyverse)

# define a ui usando a estrutura de dashboardPage
ui <- dashboardPage(
  
  # define o título da aplicação
  dashboardHeader(title = strong('Profissionalização Legislativa das Câmaras Municipais do Paraná'),
                  titleWidth = '100%'),
  
  # define o título da aba no navegador
  title = "Profissionalização Legislativa das Câmaras Municipais do Paraná",
  
  # define a estrutura dos menus laterais
  dashboardSidebar(
    sidebarMenu(
      menuItem(HTML('<h4><i class="fa fa-align-left" style="margin-left: 10px;"></i> Introdução</h4>'), tabName = 'Introdução'),
      menuItem(HTML('<h4><i class="fa fa-user-tie" style="margin-left: 10px;"></i> Vereadores</h4>'), tabName = 'Vereadores'),
      menuItem(HTML('<h4><i class="fa fa-people-group" style="margin-left: 10px;"></i> Funcionários</h4>'), tabName = 'Funcionários'),
      menuItem(HTML('<h4><i class="fa fa-ranking-star" style="margin-left: 10px;"></i> Ranking</h4>'), tabName = 'Ranking'),
      menuItem(HTML('<h4><i class="fa fa-align-right" style="margin-left: 10px;"></i> Conclusões</h4>'), tabName = 'Conclusões'),
      menuItem(HTML('<h4><i class="fa fa-quote-left" style="margin-left: 10px;"></i> Referências</h4>'), tabName = 'Referências')
    )),
  
  # define o conteúdo de cada seção
  dashboardBody(
    
    tags$head(
      tags$style(HTML("
        body, .content-wrapper, .right-side {
          font-size: 18px;
        }
      "))
    ),
    
    tabItems(
      
      tabItem(tabName = 'Introdução',
              h2(strong('Introdução')),
              br(),
              p('A profissionalização legislativa é um conceito amplamente debatido na literatura institucionalista da
                Ciência Política, caracterizando-se principalmente pelo aprimoramento da capacidade da legislatura em
                desempenhar seu papel ao fornecer aos seus membros recursos adequados para cumprir suas responsabilidades
                de forma comparável a outros atores políticos; e pelo estabelecimento de estruturas organizacionais e
                procedimentos que facilitam a elaboração de leis (MOONEY, 1994).'),
              br(),
              p('Fatores como a qualificação dos parlamentares, suas profissões de origem e o número de funcionários
                de apoio em cada casa legislativa emergem como indicadores cruciais para avaliar o nível de
                profissionalização política de uma legislatura. Entretanto, pesquisas com esse foco tendem a ser
                escassas no nível municipal, em grande parte devido à limitada disponibilidade de dados.'),
              br(),
              p('Nesse cenário, o projeto Panorama do Legislativo Municipal, lançado em 2023 pelo Senado Federal,
                representa um marco significativo. Trata-se de uma plataforma de dados abertos que se destaca por
                sua importância ímpar para estudos dessa natureza, oferecendo um leque de informações pertinentes
                para a medição do grau de profissionalização dos legislativos de cada município.'),
              br(),
              p('Os painéis a seguir avaliam esses dados para os municípios paranaenses, observando o número de
                vereadores; a proporção dos vereadores com formação superior em cada legislatura; a proporção de
                vereadores profissionais (seguindo os critérios propostos por Cairney, 2007); o número de funcionários;
                a proporção de funcionários com ensino superior; e a relação entre o número de funcionários e de
                vereadores em cada câmara municipal. Ao final da análise, os dados são normalizados (min-max) e
                empregados na construção de um índice, apresentado tanto em forma de tabela quanto de um mapa
                interativo.'),
              br(),
              p(HTML('A análise empregou os pacotes 
                      <code>leaflet</code>, 
                      <code>sf</code>, 
                      <code>shiny</code>, 
                      <code>shinydashboard</code>, 
                      <code>shinycssloaders</code> e  
                      <code>tidyverse</code>. 
                      O código completo utilizado para coleta, tratamento e apresentação dos dados se encontra 
                      disponível <a href="https://github.com/DouglasNovelli/profissionalizacao_legislativa_pr">aqui</a>.'))
              ),
      
      tabItem(tabName = 'Vereadores',
              h2(strong('Análise dos Vereadores')),
              h3('Dados de 2020.'),
              br(),
              DT::dataTableOutput("vereadores", width = "100%")),
      
      tabItem(tabName = 'Funcionários',
              h2(strong('Análise dos funcionários das Câmaras Municipais')),
              h3('Dados de 2019.'),
              br(),
              DT::dataTableOutput("funcionarios", width = "100%")),
      
      tabItem(tabName = 'Ranking',
              h2(strong('Ranking de Profissionalização Legislativa das Câmaras Municipais do Paraná')),
              br(),
              fluidRow( # oferece as opções de filtro que irão compor o ranking
                box(selectInput("variaveis", "Selecione as Variáveis para compor o ranking:", 
                                choices = c("Número de vereadores", 
                                            "Vereadores com ensino superior", 
                                            "Vereadores com carreiras políticas",
                                            "Número de funcionários",
                                            "Funcionários com ensino superior",
                                            "Relação de funcionários/vereador"),
                                multiple = TRUE),
                    width = 3),
                box(width = 9, withSpinner(leafletOutput('mapa'), type = 7, color = 'lightskyblue'))),
              fluidRow(box(title = strong('Ranking de profissionalização legislativa - variáveis normalizadas:'),
                           dataTableOutput('ranking'), width = 12))
      ),
      
      tabItem(tabName = 'Conclusões',
              h2(strong('Conclusões')),
              br(),
              p('Os dados fornecidos pelo Panorama do Legislativo Municipal representam um avanço importante
                para estudos sobre a profissionalização dos legislativos municipais no Brasil. Eles oferecem uma
                base para análises preliminares sobre a composição e o funcionamento das câmaras municipais, 
                incluindo informações sobre a formação educacional dos vereadores e o suporte de pessoal disponível.
                Isso permite iniciar uma investigação sobre como esses fatores influenciam a eficácia legislativa e 
                contribuem para a qualidade da governança local. Por meio dessas informações, pesquisadores e o 
                público em geral podem começar a estabelecer comparações entre diferentes municípios e observar 
                tendências ao longo do tempo.'),
              br(),
              p('No entanto, é crucial reconhecer as limitações atuais do banco de dados. 
                A falta de informações completas sobre os funcionários das câmaras municipais e a ausência de 
                detalhes sobre outras variáveis relevantes para a profissionalização legislativa limitam a 
                profundidade das análises que podem ser realizadas. Essas lacunas indicam a necessidade de 
                esforços futuros para garantir o desenvolvimento contínuo do Panorama do Legislativo Municipal, 
                visando habilitar pesquisas mais sofisticadas voltadas para o entendimento das dinâmicas 
                legislativas municipais no Brasil.')),
      
      tabItem(tabName = 'Referências',
              h2(strong('Referências')),
              br(),
              p(tags$ul(
                tags$li(HTML("CAIRNEY, P. The Professionalisation of MPs: Refining the “Politics-Facilitating” Explanation. <strong>Parliamentary Affairs</strong>, v. 60, n. 2, p. 212–233, 1 jan. 2007.")),
                tags$li(HTML("MOONEY, C. Z. Measuring U.S. State Legislative Professionalism: An Evaluation of Five Indices. <strong>State & Local Government Review</strong>, v. 26, n. 2, p. 70–78, 1994.")),
                tags$li(HTML('<strong>Panorama do Legislativo Municipal</strong>. Disponível em: <a href="https://www.senado.leg.br/institucional/datasenado/panorama/#/" target="_blank">https://www.senado.leg.br/institucional/datasenado/panorama/#/</a>. Acesso em: 22 mar. 2024.'))
              )),
              br(),
              div(style="border-bottom: 2px solid #000; margin-top: 20px; margin-bottom: 20px;"),
              br(),
              h2('Sobre o autor'),
              br(),
              p('Douglas H. Novelli é mestre e doutor em Ciência Política pela Universidade Federal do Paraná (UFPR). 
                Assessor na Superintendência Geral de Diálogo e Interação Social do Governo do Estado do Paraná – SUDIS/PR, 
                atualmente é aluno do curso de Inovação, Transformação Digital e e-Gov (INTEGRE II).')
      )
    )
  )
)

# define o servidor
server <- function(input, output, session) {
  
  # carrega a área de trabalho
  load('dados.RData')
  
  
  # traduz os elementos empregados pelo pacote DT
  DT_pt <- list(
    search = "Pesquisar:",
    lengthMenu = "Mostrar _MENU_ registros por página",
    zeroRecords = "Nenhum registro encontrado",
    info = "Mostrando página _PAGE_ de _PAGES_",
    infoEmpty = "Sem registros disponíveis",
    paginate = list(
      'first' = "Primeira",
      'previous' = "Anterior",
      'next' = "Próxima",
      'last' = "Última"))
  
  # gera a tabela apresentada na seção sobre vereadores
  output$vereadores <- DT::renderDataTable({
    tabela_vereadores <- dataset %>%
      select(Municipio, n_vereadores, vereadores_com_graduacao, vereadores_profissionais) %>%
      mutate(vereadores_com_graduacao = as.numeric(sprintf("%.2f", (vereadores_com_graduacao*100))),
             vereadores_profissionais = as.numeric(sprintf("%.2f", (vereadores_profissionais*100)))) %>%
      rename('Município' = 'Municipio',
             'Número de vereadores' = 'n_vereadores',
             'Vereadores com ensino superior (%)' = 'vereadores_com_graduacao',
             'Vereadores com carreiras políticas (%)' = 'vereadores_profissionais')
    DT::datatable(tabela_vereadores,
                  options = list(pageLength = 50, language = DT_pt))
  })
  
  # gera a tabela apresentada na seção sobre funcionários
  output$funcionarios <- DT::renderDataTable({
    tabela_funcionarios <- dataset %>%
      select(Municipio, n_funcionarios, funcionarios_com_graduacao, funcionarios_por_vereador) %>%
      mutate(funcionarios_com_graduacao = as.numeric(sprintf("%.2f", (funcionarios_com_graduacao*100))),
             funcionarios_por_vereador = as.numeric(sprintf("%.2f", funcionarios_por_vereador))) %>%
      rename('Município' = 'Municipio',
             'Número de funcionários' = 'n_funcionarios',
             'Funcionários com ensino superior (%)' = 'funcionarios_com_graduacao',
             'Relação entre o número de funcionários e o de vereadores' = 'funcionarios_por_vereador')
    DT::datatable(tabela_funcionarios,
                  options = list(pageLength = 50, language = DT_pt))
  })
  
  # gera a base da tabela apresentada na seção sobre o ranking
  dados_filtrados <- reactive({
    
    req(input$variaveis)
    
    dataset <- dataset %>%
      select(Codigo_IBGE, Municipio, n_vereadores_norm, vereadores_com_graduacao_norm, vereadores_profissionais_norm,
             n_funcionarios_norm, funcionarios_com_graduacao_norm, funcionarios_por_vereador_norm) %>%
      rename('Código IBGE' = 'Codigo_IBGE',
             'Município' = 'Municipio',
             'Número de vereadores' = 'n_vereadores_norm',
             'Vereadores com ensino superior' = 'vereadores_com_graduacao_norm',
             'Vereadores com carreiras políticas' = 'vereadores_profissionais_norm',
             'Número de funcionários' = 'n_funcionarios_norm',
             'Funcionários com ensino superior' = 'funcionarios_com_graduacao_norm',
             'Relação de funcionários/vereador' = 'funcionarios_por_vereador_norm')
    
    dados_selecionados <- dataset[, c('Código IBGE', "Município", input$variaveis), drop = FALSE]
    dados_selecionados <- dados_selecionados %>%
      rowwise() %>%
      mutate(Ranking = mean(c_across(all_of(input$variaveis)), na.rm = TRUE)) %>%
      ungroup()
  })
  
  # cria o ranking de forma reativa, a partir das variáveis filtradas
  output$ranking <- renderDataTable({dados_filtrados()},
                                    options = list(pageLength = 50, language = DT_pt))
  
  # cria o banco de dados que servirá de base para o mapa na seção sobre o ranking
  dados_mapa <- reactive({
    PR_Municipios %>%
      full_join(dataset, by = c('CD_MUN' = 'Codigo_IBGE')) %>%
      full_join(dados_filtrados(), by = c('CD_MUN' = 'Código IBGE'))
  })
  
  # gera o mapa
  output$mapa <- renderLeaflet({
    
    dm <- dados_mapa()
    
    # cria a paleta de cores a partir do ranking calculado
    pal <- colorNumeric(palette = c("lightblue", "royalblue3"),
                        domain = dm$Ranking,
                        na.color = "lightgrey")
    
    leaflet(options = leafletOptions(zoomSnap = 0.05)) %>%
      addTiles() %>%
      addPolygons(data = dm,
                  color = "#555555",
                  opacity = 1,
                  weight = 1,
                  fillColor = ~pal(Ranking),
                  fillOpacity = 1,
                  highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE),
                  
                  # define as legendas que surgem ao clicar em um município
                  popup = ~paste('<b>', Município, '</b>',
                                 
                                 '<br>','<br>',
                                 
                                 'Número de vereadores: ',
                                 n_vereadores,
                                 
                                 '<br>',
                                 
                                 'Vereadores com ensino superior: ', 
                                 paste(sprintf("%.2f", (vereadores_com_graduacao*100)), '%'),
                                 
                                 '<br>',
                                 
                                 'Vereadores com carreiras políticas: ',
                                 paste(sprintf("%.2f", (vereadores_profissionais*100)), '%'),
                                 
                                 '<br>',
                                 
                                 'Número de funcionários: ',
                                 ifelse(is.na(n_funcionarios), 'Não disponível.', n_funcionarios),
                                 
                                 '<br>',
                                 
                                 'Funcionários com ensino superior: ',
                                 ifelse(is.na(funcionarios_com_graduacao),
                                        'Não disponível.',
                                        paste(sprintf("%.2f", (funcionarios_com_graduacao*100)), '%')),
                                 
                                 '<br>',
                                 
                                 'Relação de funcionários/vereador: ',
                                 ifelse(is.na(funcionarios_por_vereador),
                                        'Não disponível.',
                                        sprintf("%.2f", funcionarios_por_vereador))
                                 ))
    
  })
  
  
}

shinyApp(ui, server)