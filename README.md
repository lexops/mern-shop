# Hotmart DevOps Challenge

## Introdução

### Overview da aplicação

Esse repositório foi criado com base no repo aplicação [mern-ecommerce](https://github.com/RishiBakshii/mern-ecommerce).
Trata-se um app MERN (MongoDB, ExpressJS, React e NodeJS). Recomendo ler a documentação original também.

> [!NOTE]
> Foram realizadas modificações simples no código-fonte da aplicação. Como, por exemplo, subir o backend na rota `/api`.

Criei os arquivos `Dockerfile` para o [frontend](frontend/Dockerfile) e [backend](backend/Dockerfile), assim como o [docker-compose](docker-compose.yml).
Para acelerar o processo de criação dos manifestos Kubernetes utilizei a ferramenta [Kompose](https://kompose.io/).
Para criar um "esqueleto" Helm a partir dos manifestos utilizei o [Helmify](https://github.com/arttor/helmify).

### Overview de Infraestrutura

A infraestrutura foi erguida utilizando Terraform.
- O módulo `networking` cria uma VPC contando com 4 subnets, em 2 AZs diferentes. Sendo 2 públicas com máscara `/20` e duas privadas com máscara `/24`. 
- O módulo `k8s` cria um cluster EKS com node group simples com 3 instâncias `t3.medium`. 
- O módulo `k8s-addons` implementa o [aws-load-balancer-controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/), além do [external-dns](https://kubernetes-sigs.github.io/external-dns/v0.14.0/) para resolução automática do nome do ALB. 
- A configuração de roteamento do tráfego para o frontend `lexops.xyz` e o backend `lexops.xyz/api` é feito através de annotations no kind Ingress e no kind Service do backend.
- O deploy da aplicação é feito utilizando Helm via resource `helm_release` do Terraform.
- O repositório conta com uma série de `pre-commit` hooks. Eles são utilizados para formatar e gerar automaticament as documentações do Terraform e do Helm. Além de "lintar" os workflows, evitando commits que iriam falhar. 
- A ferramenta [pre-commit](https://pre-commit.com/) pode ser instalada com `pip install -r requirements.txt`. Certifique de também se referir a documentação oficial dos "hooks" que pretende utilizar.

## Configuração das Pipelines CICD (Esteiras)

### Autenticação GitHub OIDC x AWS
As esteiras obtém a permissão para gerenciar recurso na AWS através de uma role autenticada via OIDC. Por favor, leia a documentação: [Github OIDC x AWS](https://aws.amazon.com/pt/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/)

## Como subir e desligar o ambiente

### Automatico

1. Vá para [Actions](https://github.com/lexops/mern-shop/actions) e clique no workflow [Deploy Infra](https://github.com/lexops/mern-shop/actions/workflows/deploy-infra.yml)
2. Na lado direito, clique em **Run workflow**. Isso abrir um pop-up.
3. Escolhe um ambiente para subir no menu drop-down.
4. Clique no botão verde **Run workflow**.
![[Pasted image 20241118131920.png]]
5. Espere a conclusão do workflow.
![[Pasted image 20241118132213.png]]

6. Para destruir o ambiente o processo é muito similar. Porém você deverá rodar o workflow chamado [Tear Down Infra](https://github.com/lexops/mern-shop/actions/workflows/tear-down-infra.yml)

### Manual

1. Clone o repositório:
   ```bash
   git clone https://github.com/lexops/mern-shop.git
   ```
2. Navegue até o diretório do ambiente terraform que deseja subir (ex.: dev):
   ```bash
   cd terraform/dev
   ```
3. Instale as dependências:
   ```bash
   terraform init
   ```
4. Execute o projeto:
   ```bash
   terraform apply
   ```
5. Isso irá criar um plano para subir a infraestrutura. Leia o plano gerado no terminal e aprove-o digitando `yes`.

6. Para desligar o ambiente basta executar e confirmar digitando `yes`.
   ```bash
   terraform destroy
   ```

## Como atualizar a versão da app

### Em desenvolvimento

#### Automático

Para atualizar a versão da aplicação em desenvolvimento basta abrir um PR para a branch `develop`e conseguir aprová-lo. 

> [!IMPORTANT]  
> É obrigatório submeter o PR com exatamente **uma** das seguintes **labels** : `major`, `minor` ou `patch`. Isso garante que automação que realiza o [semver](semver.org) não quebre.
![[Pasted image 20241118134548.png]]

Isso rodará o workflow chamado `Continous Integration`, realizando o build das imagens docker e fará um commit automático mudando o valor da variável `mern_shop_version` no arquivo `terraform/dev/terraform.tfvars`.

#### Manual

Também é possível fazer o mesmo manualmente, alterando a variável `mern_shop_version` no arquivo [`terraform/dev/terraform.tfvars`] e rodando os comandos ensinados anteriormente:
`terraform init` e `terraform apply`.

### Em produção 

#### Manual

Em produção é necessário alterar a variável `mern_shop_version` no arquivo [`terraform/prod/terraform.tfvars`]  e submeter um PR a branch `main`.
Isso rodará o workflow `Create terraform plan for prod`, que gera o plano do terraform e posta um comentário no PR. Caso o PR seja aprovado, o workflow `Terraform Apply in prod` realizar a mudança proposta.

> [!NOTE]  
> Não é possível alterar a versão de produção automaticamente por motivos de segurança.

## Como modificar a infraestrutura

Para modificar a infraestrutura é necessário realizar alterações no arquivos dos diretório `terraform` e realizar um PR para a branch main. O processo é o similar ao da alteração da versão da app em produção. Após feito o PR, a automação criado um comentário com o plan gerado e caso seja mergeado, aplicará as mudanças.
## Roadmap

- [ ] Criar um banco **documentdb** via terraform (ao invés de passar diretamente a variável `MONGO_URI`), integrando-o ao módulo **secrets**. Sugestão: utilizar o módulo [terraform-aws-documentdb-cluster](https://github.com/cloudposse/terraform-aws-documentdb-cluster)
- [ ] Criar um repositório ECR via terraform (ao invés de simplesmente apontar a URL). Sugestão: utilizar o módulo [terraform-aws-ecr](https://github.com/terraform-aws-modules/terraform-aws-ecr)
- [ ] Remover o usuário root das imagens docker. Ref: https://cloudyuga.guru/blogs/manage-docker-as-non-root-user/

## Contribuições

Explicação sobre como contribuir com o projeto.

## Licença

Informações sobre a licença do projeto.