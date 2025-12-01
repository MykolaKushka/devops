# Terraform AWS Infrastructure — Lesson 5

Цей проєкт створює інфраструктуру AWS за допомогою Terraform.  
Конфігурація містить модулі для:

- S3 bucket (Terraform state)
- DynamoDB таблиці (state locking)
- VPC (мережа, підмережі, маршрути)
- ECR репозиторію

## Структура проєкту

```
lesson-5/
├── main.tf
├── backend.tf
├── outputs.tf
├── README.md
└── modules/
    ├── s3-backend/
    ├── vpc/
    └── ecr/
```

## Модулі

### 1. s3-backend
Створює:
- S3 bucket з versioning та encryption
- DynamoDB таблицю для блокування Terraform state

### 2. vpc
Створює:
- VPC (10.0.0.0/16)
- Три public subnets
- Три private subnets
- Internet Gateway
- NAT Gateway
- Route tables та асоціації

### 3. ecr
Створює:
- ECR репозиторій
- Увімкнене сканування образів
- Політику доступу для акаунта

## Команди для роботи

### Ініціалізація
```bash
terraform init
```

### Перегляд плану
```bash
terraform plan
```

### Створення інфраструктури
```bash
terraform apply
```

### Видалення інфраструктури
```bash
terraform destroy
```

## Налаштування backend

Backend активується до створення S3 bucket, тому порядок дій:

1. Тимчасово закоментувати блок backend у `backend.tf`
2. Запустити:
   ```bash
   terraform init
   terraform apply
   ```
3. Розкоментувати backend
4. Повторно виконати:
   ```bash
   terraform init
   ```
5. Підтвердити перенесення state у S3

## Outputs

Після `terraform apply` ви отримаєте:

- ID створеної VPC
- Списки public/private subnet IDs
- URL ECR репозиторію
- Назву S3 bucket
- Назву DynamoDB таблиці