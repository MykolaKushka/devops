# 🚀 CI/CD для Django: Jenkins + Helm + Terraform + Argo CD

Домашнє завдання №8–9 (GoIT DevOps)

Проєкт демонструє повний CI/CD-процес для Django-застосунку в Kubernetes (AWS EKS) з використанням:

- Terraform — створення інфраструктури
- Amazon ECR — Docker registry
- Jenkins — CI (build + push + update Helm)
- Helm — деплой застосунку
- Argo CD — GitOps CD

---

## Структура проєкту

lesson-8-9/
├── main.tf
├── backend.tf
├── outputs.tf
├── Jenkinsfile
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   ├── eks/
│   ├── rds/
│   ├── jenkins/
│   └── argo_cd/
└── charts/
    └── django-app/

---

## Terraform

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

Підключення до EKS:

```bash
aws eks update-kubeconfig --region us-west-2 --name lesson-7-eks
kubectl get nodes
```

---

## Jenkins

Jenkins встановлюється через Helm за допомогою Terraform.

Pipeline (Jenkinsfile):

1. Checkout репозиторію
2. Build Docker image (Kaniko)
3. Push в Amazon ECR
4. Оновлення Helm values.yaml (image tag)
5. Commit + push у Git

---

## Helm

Django Helm chart знаходиться у:

charts/django-app

---

## Argo CD

Argo CD встановлюється через Helm + Terraform.

Argo Application автоматично синхронізує Helm chart з Git.

---

## 🗄 Terraform RDS module (універсальний)

Модуль `modules/rds` дозволяє створювати:

- звичайну RDS instance (PostgreSQL / MySQL)
- або Aurora Cluster (залежно від use_aurora)

### Приклад використання

```hcl
module "rds" {
  source = "./modules/rds"

  name       = "app-db"
  use_aurora = false

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"

  db_name  = "appdb"
  username = "appuser"
  password = var.db_password
}
```

---

## Видалення ресурсів

```bash
terraform destroy -auto-approve
```
