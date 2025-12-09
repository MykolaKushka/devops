# 🚀 Django + AWS EKS + ECR + Terraform + Helm  
### Домашнє завдання №7 — GoIT DevOps Ci/CD

Цей проєкт розгортає Django-застосунок у Kubernetes-кластері AWS EKS, використовуючи Terraform для інфраструктури, ECR для зберігання Docker-образу та Helm для деплою.

---

## 📌 Структура проєкту

```
lesson-7/
│
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│   ├── vpc/
│   ├── ecr/
│   ├── eks/
│   └── s3-backend/
│
├── django/
│   ├── manage.py
│   ├── myproject/
│   ├── requirements.txt
│   └── Dockerfile
│
└── charts/
    └── django-app/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── deployment.yaml
            ├── service.yaml
            ├── configmap.yaml
            └── hpa.yaml
```

---

## ✅ 1. Створення Kubernetes-кластеру через Terraform

### Команди:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

### Після створення:

```bash
aws eks update-kubeconfig --region us-west-2 --name lesson-7-eks
kubectl get nodes
```

---

## ✅ 2. Побудова Docker-образу Django та пуш в ECR

### Перейти в Django-проєкт:

```bash
cd django
```

### Зібрати образ:

```bash
docker build -t lesson7-app .
```

### Логін в ECR:

```bash
$TOKEN = aws ecr get-login-password --region us-west-2
docker login -u AWS -p $TOKEN 431118444370.dkr.ecr.us-west-2.amazonaws.com
```

### Тег та пуш:

```bash
docker tag lesson7-app:latest 431118444370.dkr.ecr.us-west-2.amazonaws.com/lesson-7-ecr:latest
docker push 431118444370.dkr.ecr.us-west-2.amazonaws.com/lesson-7-ecr:latest
```

---

## ✅ 3. Деплой Helm-чарту

### Перейти в корінь проєкту:

```bash
cd ..
```

### Встановити:

```bash
helm install django-app ./charts/django-app
```

### Оновити:

```bash
helm upgrade django-app ./charts/django-app
```

---

## 📡 4. Перевірка деплою

### Поди:

```bash
kubectl get pods
```

### Сервіс:

```bash
kubectl get svc
```

---

## 🧩 5. ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: django-config
data:
  DEBUG: "True"
```

Підключення у Deployment:

```yaml
envFrom:
  - configMapRef:
      name: django-config
```

---

## 📈 6. Horizontal Pod Autoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: django-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: django-app
  minReplicas: 2
  maxReplicas: 6
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

---

## Backend (Terraform State)

У початковій структурі проєкту передбачався бекенд на базі S3 + DynamoDB для зберігання стану Terraform.  
Через те, що попередній AWS акаунт був заблокований, а всі ресурси видалені, бекенд було замінено на локальний:

```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```

## 📝 Результат

✔️ Створений EKS-кластер  
✔️ Налаштований ECR  
✔️ Django-додаток запушений як Docker-образ  
✔️ Деплой у Kubernetes через Helm  
✔️ Service типу LoadBalancer працює  
✔️ HPA масштабує поди  
✔️ ConfigMap використовується застосунком  

---
