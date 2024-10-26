# Пример инфраструктурного terragrunt-репозитория для деплоя в Yandex Cloud

Данный репозиторий представлен как пример Infrastructure as Code для развертывания инфраструктуры в Yandex Cloud с помощью terraform и trerragrunt.

## Описание инфраструктуры

Инфраструктура состоит из каталога `common` - для упрощения создается вручную.

Каталог `common` должен содержать следующие ресурсы:

### Virtual Private Cloud

Сеть `default` и подсети, могут быть созданы автоматически при создании каталога.

### Identity and Access Management

Сервисный аккаунт с ролью `admin` на облако. Необходим для работы с инфраструктурой с виртуальной машины `yc-toolbox`.
Статический ключ сервисного аккаунта, необходим для хранения terraform-стейта в бакете Object Storage.

### Compute Cloud

Виртуальная машина `yc-toolbox`, предназначена для управления инфраструктурой.

- Разворачивается из образа [Yandex Cloud Toolbox](https://yandex.cloud/ru/marketplace/products/yc/toolbox)
- Для доступа к виртуальной машине по ssh необходимо присвоить ей публичный статический ip-адрес 
- Для управления инфраструктурой необходимо назначить виртуальной машине сервисный аккаунт с ролью `admin` на облако (описан выше)
- Виртуальная машина настраивается в соответствии с инструкцией из описания образа [Yandex Cloud Toolbox](https://yandex.cloud/ru/marketplace/products/yc/toolbox)
- Для удобства на ВМ можно развернуть [vscode server](https://code.visualstudio.com/docs/remote/vscode-server). Для установки и настройки можно воспользоваться [скриптом](https://gist.github.com/vscoder/23bbc188a1280ec12cf54d6dce79d683). В скрипте необходимо указать свое значение для `EMAIL`. Для корректной работы LensEncrypt может понадобится создать DNS A-запись ссылающуюся на публичный ip виртуальной машиныы и указать её в переменной `FQDN`

### Object Storage и Managed Service for YDB

Бакет для хранения стейта terraform и serverless база данных YDB для хранения блокировок. Создаются и настраиваются в соответствии с [документацией](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-state-lock#db-create).

Полезные ссылки:

- [Начало работы с terraform в Yandex Cloud](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart)
- [Загрузка состояний Terraform в Yandex Object Storage](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-state-storage)
- [Блокировка состояний Terraform с помощью Yandex Managed Service for YDB](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-state-lock)


## Описание репозитория

В репозитории представлены несколько директорий:

### `modules` - модули terraform

- `folder` - Yandex Cloud каталог в облаке
- `subnets` - Yandex Cloud VPC подсети
- `ycr` - Yandex Cloud Container Registry
- `kubernetes` - Yandex Cloud Managed Service for Kubernetes
- `helm` - Деплой helm-чартов в kubernetes
  - `gitlab-runner`
  - `gitlab-agent`
  - `ingress-nginx`
- `gitlab` - Управление пользователями и репозиториями в GitLab

### `env-live-tmpl` - шаблон окружения terragrunt

Шаблон одного окружения. Имеет следующую структуру:

- `yandex` - terragrunt-модули для развертывания сервисов Yandex Cloud
  - `folder` - каталог
  - `subnet` - подсеть
  - `k8s-cluster` - кластер Kubernetes
  - `ycr` - репозиторий в Yandex Container Registry
  - `yandex.hcl` - terragrunt-файл с локальными переменныси относящимися к Yandex Cloud и шаблоном конфигурации terraform-провайдера `yandex`
- `gitlab` - terragrunt-модули для урпавления GitLab
  - `repo` - создает пользователя и репозиторий GitLab из шаблонного репозитория
  - `gitlab.hcl` - terragrunt-файл с локальными переменныси относящимися к GitLab и шаблоном конфигурации terraform-провайдера `gitlab`
- `helm` - terragrunt-модули для деплоя helm-релизов в Kubernetes
  - `release` - деплоит helm-релизы terraform-модулем `helm`
- `dir.hcl` - terragrunt-файл с локальными переменными, относящимися к конкретному окружению

Зависимости terragrunt-модулей внутри окружения:

yandex.ycr -> yandex.subnet -> yandex.folder
yandex.k8s-cluster -> yandex.folder
yandex.k8s-cluster -> yandex.subnet -> yandex.folder
gitlab.repo -> yandex.ycr
helm -> yandex.folder
helm -> yandex.k8s-cluster
helm.release -> gitab.repo

Шаблон `env-live-tmpl` реализован таким образом, чтобы окружения на его основе можно было создавать без модификации файлов в шаблоне, просто скопировав его в директорию `live` под нужным имененм.

### `live` - директория с terragrunt-окружениями

Директория должна содержать terragrunt-модули, описывающие инфраструктуру которая будет развернута в Yandex Cloud. Для удобства окружения могут быть скопированы из шаблона `env-live-tmpl`. При создании инфраструтктуры будут созданы каталоги в облаке Yandex Cloud с именами соответствующим имени директории окружения. Так же в GitLab будут созданы пользователи и репозитории с именами соответствующими имени директории окружения.

В данном примере будут созданы окружения `dev`, `stage` и `prod`.

Так же в каталоге представлены следующие файлы:

- `terragrunt.hcl` - шаблон конфигурации бекенда terraform для хранения стейта
- `common.hcl` - переменные, относящиеся к общим компонентам инфраструктуры
- `env.hcl` - общие переменные, использующиеся для настройки terraform-провайдеров
- `envs.hcl` - уникальные настройки каждого окружения, задаются при создании новых окружений

## Подготовка

Перед началом работы должны быть созданы каталог `common` и ресурсы в нем, описанные в разделе "Описание инфраструктуры"

В данном примере предполагается работа с инфраструктурой с виртуальной машины `yc-toolbox`, созданной и настроенной согласно описанию в разделе "Описание инфраструктуры". Для удобства на виртуальной машине `yc-toolbox` рекомендуется поднять и настройть vscode-server как описано в разделе "Описание инфраструктуры".

Перед созданием инфраструктуры необходимо задать значения переменных в следующих файлах:

### `tf.env`

Создайте файл `tf.env` из примера `tf.env.example`

Заполните значения переменных:

`AWS_ACCESS_KEY_ID` - идентификатор статического ключа сервисного аккаунта, назначенного виртуальной машине `yc-toolbox`
`AWS_SECRET_ACCESS_KEY` - секретная часть статического ключа сервисного аккаунта, назначенного виртуальной машине `yc-toolbox`
`TF_VAR_gitlab_token` - персональный авторизационный токен администратора GitLab

### `live/terragrunt.hcl`

Заполните значения переменных:

`bucket_name` - имя s3 бакета в Yandex Object Storage для хранения стейта terraform, созданного ранее в каталоге `common` в Yandex Cloud
`dynamodb_endpoint` - DynamoDB Document API endpoint, ссылка для доступа к DynamoDB для хранения блокировок, можно посмотреть в свойствах базы YDB созданной ранее в каталоге `common` в Yandex Cloud
`dynamodb_table` - имя таблицы в YDB для хранения блокировок, изменить если отличается.

### `live/common.hcl`

Заполните значения переменных:

`vpc_id` - идентификатор сети в каталоге `common` в Yandex Cloud
`gitlab_project_import_url` - url шаблонного git-репозитория. В GitLab будут созданы репозитории идентичные указанному в данном url
`gitlab_group_full_path` - имя группы/подгруппы в GitLab, в которой будут создаваться репозитории
`helm_ingress_domain` - домен для ingress который можно использовать в helm-чартах. В данном примере не используется

### `live/env.hcl`

Заполните значения переменных:

`gitlab_fqdn` fqdn инстанса GitLab, в котором будут созданы пользователи и репозитории

### `live/envs.hcl`

Файл заполняется по шаблону. Пример:

```javascript
locals {
  envs = {
    "dev" = {
      subnet_octet = "11",
      gitlab_project_force_recreate_salt = "0",
    },
    "stage" = {
      subnet_octet = "12",
      gitlab_project_force_recreate_salt = "0",
    },
    "prod" = {
      subnet_octet = "13",
      gitlab_project_force_recreate_salt = "0",
    },
  }
}
```

Переменная `envs` содержит список окружений, где имя элемента должно соответствовать имени директории с окружением в директории `live/`, а в значении задаются следующии параметры:

- `subnet_octet` - номер второго октета для подсети. В каждом каталоге создются подсети по шаблону `"10.%s.0.0/16"`, где `%s` заменяется на значение данной переменной.
- `gitlab_project_force_recreate_salt` - при изменении данного значения на любое другое, gitlab-репозиторий в соответствующем окружении будет пересоздан из шаблона. ВАЖНО: все изменения в пересоздаваемом репозитории будут потерены без запроса на прдтверждение.

## Создание инфраструктуры

После того как все файлы заполнены, можно создать инфраструктуру

Заполняем переменные окружения:

```shell
source tf.env
```

Создаем инфраструктуру

```shell
# Переходим в каталог live/
cd live/

# Инициализируем terragrunt, выполняется в следующих случаях:
# - при первом запуске
# - при создании новых модулей terragrunt
# - при изменении версий провайдеров в модулях terraform
terragrunt run-all init

# Получаем план изменений инфраструктуры
terragrunt run-all plan

# Применяем изменения
terragrunt run-all apply
```
