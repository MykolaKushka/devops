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

```
final/
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
```

---

## Terraform

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

---

## Підключення до EKS

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
3. Push image в Amazon ECR
4. Оновлення Helm `values.yaml` (image tag)
5. Commit + push у Git

### Перевірка Jenkins

```bash
kubectl get all -n jenkins
```

Доступ до Jenkins UI:

```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

В браузері:
http://localhost:8080

---

## Helm

Django Helm chart знаходиться у:

```
charts/django-app
```

Helm chart використовується Jenkins (оновлення image tag) та Argo CD для деплою застосунку.

---

## Argo CD

Argo CD встановлюється через Helm + Terraform.

Argo Application автоматично синхронізує Helm chart з Git-репозиторієм та підтримує desired state у кластері.

### Перевірка Argo CD

```bash
kubectl get all -n argocd
```

Доступ до Argo CD UI:

```bash
kubectl port-forward svc/argocd-server 8081:443 -n argocd
```

В браузері:
https://localhost:8081

Отримання initial admin password (за потреби):

```bash
kubectl get secret argocd-initial-admin-secret \
  -n argocd \
  -o jsonpath="{.data.password}" | base64 -d
```

---

## 🗄 Terraform RDS module (універсальний)

Модуль `modules/rds` дозволяє створювати:

- звичайну RDS instance (PostgreSQL / MySQL)
- або Aurora Cluster (залежно від `use_aurora`)

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

## Перевірка після розгортання (згідно ТЗ)

```bash
kubectl get all -n jenkins
kubectl get all -n argocd
```

---

## Видалення ресурсів

```bash
terraform destroy -auto-approve
```

⚠️ Команда видалить також S3 backend bucket та DynamoDB table для Terraform state.
