#!/usr/bin/env bash

set -euo pipefail

echo "=== DevOps tools installer for Ubuntu/Debian ==="

# -----------------------------
# Допоміжні функції
# -----------------------------

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# -----------------------------
# Docker
# -----------------------------

install_docker() {
  if have_cmd docker; then
    echo "Docker вже встановлено: $(docker --version)"
  else
    echo "Встановлюємо Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    # запускаємо та додаємо в автозапуск
    if command -v systemctl >/dev/null 2>&1; then
      sudo systemctl enable --now docker || true
    fi
    echo "Docker встановлено: $(docker --version)"
  fi
}

# -----------------------------
# Docker Compose
# -----------------------------

install_docker_compose() {
  if have_cmd docker-compose; then
    echo "Docker Compose вже встановлено: $(docker-compose --version)"
  elif docker compose version >/dev/null 2>&1; then
    echo "Docker Compose (plugin) вже встановлено: $(docker compose version 2>/dev/null | head -n 1)"
  else
    echo "Встановлюємо Docker Compose..."
    sudo apt-get update
    # класичний docker-compose пакет для Ubuntu/Debian
    sudo apt-get install -y docker-compose
    echo "Docker Compose встановлено: $(docker-compose --version)"
  fi
}

# -----------------------------
# Python 3 (3.9+)
# -----------------------------

check_python_version() {
  local ver major minor
  ver="$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"
  major="${ver%%.*}"
  minor="${ver#*.}"
  minor="${minor%%.*}"

  if [ "$major" -gt 3 ] || { [ "$major" -eq 3 ] && [ "$minor" -ge 9 ]; }; then
    return 0
  else
    return 1
  fi
}

install_python() {
  if have_cmd python3; then
    echo "Знайдено Python3: $(python3 --version)"
    if check_python_version; then
      echo "Версія Python >= 3.9 — ок ✅"
    else
      echo "⚠ Увага: встановлена версія Python < 3.9."
      echo "   Спробуємо оновити Python через apt..."
      sudo apt-get update
      sudo apt-get install -y python3 python3-pip
      if check_python_version; then
        echo "Python успішно оновлено: $(python3 --version)"
      else
        echo "⚠ Після оновлення все ще версія < 3.9."
        echo "   Можливо, у цій версії Ubuntu/Debian немає новішого Python у стандартних репозиторіях."
        echo "   Для ДЗ це допустимо, але за потреби можна вручну встановити Python 3.9+ з PPA/pyenv."
      fi
    fi
  else
    echo "Python3 не знайдено. Встановлюємо Python3 та pip..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
    echo "Встановлено: $(python3 --version)"
  fi

  if have_cmd pip3; then
    echo "pip3 вже встановлено: $(pip3 --version)"
  else
    echo "Встановлюємо pip3..."
    sudo apt-get update
    sudo apt-get install -y python3-pip
    echo "pip3 встановлено: $(pip3 --version)"
  fi
}

# -----------------------------
# Django (через pip)
# -----------------------------

install_django() {
  if python3 -m django --version >/dev/null 2>&1; then
    echo "Django вже встановлено: $(python3 -m django --version)"
  else
    echo "Встановлюємо Django через pip..."
    # встановлення у поточного користувача
    pip3 install --user django
    echo "Django встановлено: $(python3 -m django --version)"
  fi
}

# -----------------------------
# Запуск установок
# -----------------------------

install_docker
install_docker_compose
install_python
install_django

echo "=== Готово! Усі необхідні інструменти встановлено (або вже були встановлені) ✅ ==="
