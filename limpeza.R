# carrega os pacotes necessários
library(sf)
library(tidyverse)


# importa os dados do Panorama Legislativo Municipal
vereadores <- read_csv2(
  'https://www.senado.gov.br/institucional/datasenado/strans/arquivos_panorama/bases/vereadores.csv',
  locale = locale(encoding = 'ISO-8859-1'))

funcionarios <- read_csv2(
  'https://www.senado.gov.br/institucional/datasenado/strans/arquivos_panorama/bases/funcionarios.csv',
  locale = locale(encoding = 'ISO-8859-1'))


# limpa e transforma a base de dados dos vereadores
vereadores <- vereadores %>%
  filter(UF == 'PR',
         Ano == 2020) %>%
  mutate(Escolaridade_vereador = ifelse(Escolaridade == 'ENSINO SUPERIOR COMPLETO', 1, 0),
         Profissao_vereador = ifelse(
           # Ocupações intermediárias (Carney, 2007):
           Profissao == 'SOCIÓLOGO' 
           | Profissao == 'CIENTISTA POLÍTICO'
           | Profissao == 'ECONOMISTA'
           | Profissao == 'ADVOGADO'
           | Profissao == 'ASSISTENTE SOCIAL'
           | Profissao == 'JORNALISTA E REDATOR'
           | Profissao == 'SERVIDOR PÚBLICO MUNICIPAL'
           # Ocupações instrumentais (Carney, 2007):
           | Profissao == 'VEREADOR'
           | Profissao == 'OCUPANTE DE CARGO EM COMISSÃO'
           | Profissao == 'SERVIDOR PÚBLICO ESTADUAL'
           | Profissao == 'PROFESSOR DE ENSINO SUPERIOR'
           | Profissao == 'SERVIDOR PÚBLICO FEDERAL'
           | Profissao == 'SERVIDOR PÚBLICO CIVIL APOSENTADO',
           1, 0)) %>%
  select(Codigo_IBGE, Municipio, Escolaridade_vereador, Profissao_vereador) %>%
  group_by(Codigo_IBGE, Municipio) %>%
  summarise(
    n_vereadores = n(),
    vereadores_com_graduacao = mean(Escolaridade_vereador, na.rm = TRUE),
    vereadores_profissionais = mean(Profissao_vereador, na.rm = TRUE))


# limpa e transforma a base de dados dos funcionários
funcionarios <- funcionarios %>%
  filter(ANO == 2019,
         Cod_IBGE %in% vereadores$Codigo_IBGE) %>%
  mutate(Escolaridade_funcionarios = ifelse(
    Escolaridade1 %in% c('Ensino superior completo', 'Mestrado', 'Doutorado'), 1, 0)) %>%
  select(Cod_IBGE, Escolaridade_funcionarios) %>%
  group_by(Cod_IBGE) %>%
  summarise(
    n_funcionarios = n(),
    funcionarios_com_graduacao = mean(Escolaridade_funcionarios, na.rm = TRUE)
  )

dataset <- vereadores %>%
  full_join(funcionarios, by = c('Codigo_IBGE' = 'Cod_IBGE')) %>%
  mutate(funcionarios_por_vereador = n_funcionarios / n_vereadores,
         Codigo_IBGE = as.character(Codigo_IBGE)) %>%
  ungroup()


# cria formula que será usada para normalização dos dados
min_max_norm <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

# normaliza os dados para criação do ranking
dataset_norm <- as.data.frame(lapply(dataset[3:8], min_max_norm))
names(dataset_norm) <- paste(names(dataset_norm), '_norm', sep = '')
dataset <- cbind(dataset, dataset_norm)


# baixa e extrai o arquivo ZIP com os polígonos municipais
temp_zip <- tempfile(fileext = '.zip')
download.file('https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2022/UFs/PR/PR_Municipios_2022.zip', temp_zip, mode = 'wb')
temp_dir <- tempdir()
unzip(temp_zip, exdir = temp_dir)

# lê o arquivo .shp e seleciona as colunas desejadas
shp_path <- file.path(temp_dir, 'PR_Municipios_2022.shp')
PR_Municipios <- st_read(shp_path) %>%
  ungroup() %>%
  select(CD_MUN, geometry)

# salva a imagem da área de trabalho
save.image('dados.RData')
