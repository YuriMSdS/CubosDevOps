
# Cubos DevOps - Desafio Técnico Cubos

Este projeto foi desenvolvido como parte de um desafio técnico para criar um ambiente seguro utilizando **Infraestrutura como Código (IaC)** com Terraform. O ambiente é replicável, configurando redes internas para aplicações e redes externas para acesso de usuários. A aplicação inclui uma página HTML (frontend), um backend que interage com o banco de dados e infraestrutura gerenciada inteiramente via Terraform.

---

## Estrutura do projeto
```
CubosDevOps/
│   ├── src/
│       ├──app/  
│           ├──back/
│                ├──node_modules                 //Ignorado no controle de versão             
│                ├── script.js
│                ├── package.json
│                └── package-lock.json
│           ├──front/
│                └── index.html
│           ├──sql/
│                ├──data/                        //Ignorado no controle de versão
│                └── script.sql
│
│   ├──infrastructure/
│             ├──.terraform/                     //Ignorado no controle de versão
│             ├──.terraform.lock.hcl             //Ignorado no controle de versão
│             ├── main.tf
│             ├── providers.tf
│             ├── secrets.tfvars                 //Ignorado no controle de versão
│             ├── terraform.tfstate              //Ignorado no controle de versão
│             ├── terraform.tfstate.backup       //Ignorado no controle de versão
│             └── variables.tf
│
│
├──.env                                          //Ignorado no controle de versão
├──.gitignore
└──README.md
```

##  **Requisitos**

Certifique-se de ter as seguintes ferramentas instaladas:

- [Terraform](https://www.terraform.io/)
- [Node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/) ou [yarn](https://yarnpkg.com/)
- [Git](https://git-scm.com/) para clonar o repositório

---

##  **Arquitetura do Projeto**

A infraestrutura foi projetada para incluir:

1. **Rede Externa**: Permite que os usuários acessem o frontend.
2. **Rede Interna**: Exclusiva para comunicação entre backend e banco de dados.
3. **Frontend**: Uma página HTML acessível publicamente.
4. **Backend**: API que processa os dados e se comunica com o banco.
5. **Banco de Dados**: Armazena as informações da aplicação.

---

##  **Como Iniciar o Projeto**

### 1. **Clone o Repositório**

```bash
git clone -b testing https://github.com/YuriMSdS/CubosDevOps.git
cd CubosDevOps
```

### 2. **Configuração da Infraestrutura**

#### Variáveis de Ambiente

Edite o arquivo `secrets.tfvars` com os valores necessários. Exemplo:

```hcl
db_username = "yuri"
db_password = "SenhaDoYuri"
```

Após inserir o nome da varíavel no `secrets.tfvars`, chame-os no arquivo `variables.tf`. Exemplo: 

```hcl
variable "db_username" {}
variable "db_password" {}
``` 

Assim, podendo assim, utilizar essas variáveis no código sem expor nenhuma informação sensível.

Também deve estar incluso no projeto, o arquivo .env, utilizado no backend. Exemplo:

```env
POSTGRESQL_USERNAME="admin"
POSTGRESQL_PASSWORD="admin"
```

#### Inicialização e Criação da Infraestrutura

1. Inicialize o Terraform:

```bash
terraform init
```

2. Valide a configuração para verificar possíveis erros:

```bash
terraform validate
```

3. Aplique a infraestrutura:

```bash
terraform apply -var-file="secrets.tfvars"  --auto-approve
```

Após a execução, o Terraform exibirá os endereços do frontend e backend.

4. Volumes:

Neste projeto utilizei caminhos absolutos para a configuração dos volumes, como:
```hcl
  volumes {
    host_path      = "C:/Users/Administrador/Desktop/CubosDevOps/src/app/sql/script.sql"  //este caminho deve estar de acordo com seu caminho local
    container_path = "/usr/src/app/sql/script.sql"
  }
```
Conforme mencionado no comentário presente no trecho acima, este é o caminho absoluto em minha máquina, portanto deve estar de acordo com o caminho local de quem estará rodando o projeto. O mesmo se aplica para todos os `host_path` presentes em todos os volumes.


##  **Aplicações**

### 1. **Frontend**

Navegue até a pasta do frontend e inicie o projeto:

```bash
cd frontend
npm install
npm start
```

Acesse o frontend no endereço informado durante a execução da infraestrutura.

### 2. **Backend**

Navegue até a pasta do backend e inicie o projeto:

```bash
cd ../backend
npm install
npm start
```

O backend será executado na URL exibida pelo Terraform.

---

## .gitignore
É indispensável (por questões de segurança e também de organização) não incluir determinados arquivos no controle de versão. Segue abaixo quais não estão sendo enviados para o git e o porquê:
  - terraform.tfstate -> Contém informações sensíveis, como chaves de API, tokens, e credenciais.

  - terraform.tfstate e terraform.tfstate.backup -> Contêm o estado atual da infraestrutura gerenciada pelo Terraform, incluindo IDs de recursos e configurações, além de mudar constantemente.

  - .terraform -> Diretório gerado automaticamente pelo Terraform, usado para armazenar plugins e metadados. Não há necessidade de versionar, pois se tratam de arquivos temporários ou dependências que podem ser recriados em qualquer máquina ao executar `terraform init`.

  - .env -> Armazena variáveis de ambiente com informações sensíveis, como tokens e URLs privadas.

  - node_modules -> Aumento significativo no tamanho do repositório, com arquivos redundantes e desnecessários.

  - data -> Pode conter informações sensíveis ou simplesmente aumentar o tamanho do repositório sem necessidade.

---

## **Licença**

Este projeto está licenciado sob a [MIT License](LICENSE).

---
