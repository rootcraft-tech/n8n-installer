# 🚀 Скрипты установки n8n

**Языки:** [English](README.md) | [Русский](README.ru.md)

Автоматизированные скрипты установки платформы автоматизации рабочих процессов n8n на Ubuntu 22.04 с поддержкой SSL

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu 22.04](https://img.shields.io/badge/Ubuntu-22.04%20LTS-orange.svg)](https://ubuntu.com/)
[![n8n Latest](https://img.shields.io/badge/n8n-Latest-blue.svg)](https://n8n.io/)

## 🚀 Быстрая установка

⚡ **Рекомендуется:** Протестировано и оптимизировано для VPS серверов [MyHosti.pro](https://myhosti.pro/services/vds) (тарифы MVK)

### Проверка системных требований
```bash
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/check-requirements.sh | bash
```

### Продакшн установка (с SSL) - скрипт запросит домен и email
```bash
sudo -E DOMAIN="yourdomain.com" EMAIL="your@email.com" bash -c 'curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/install-n8n.sh | bash'
```

### Установка для разработки (только HTTP)
```bash
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/simple-install.sh | sudo bash
```

### Полное удаление n8n

```bash
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/uninstall-n8n.sh | sudo bash -s -- --auto
```
## 🌐 Точки доступа

**После HTTPS установки (install-n8n.sh):**
- 🌍 Публичный доступ: `https://yourdomain.com` (порт 443)
- 🔒 Внутренний сервис: `localhost:5678` (доступен только на сервере)

**После HTTP установки (simple-install.sh):**  
- 🌍 Прямой доступ: `http://server-ip:5678`
- 📝 Пример: `http://n8n.tech:5678`

## 📋 Что включено

| Скрипт | Версия | Назначение | Статус |
|--------|---------|------------|---------|
| `install-n8n.sh` | v2.4 | 🔒 Полная HTTPS настройка с nginx прокси | ✅ Протестировано |
| `simple-install.sh` | v1.0 | ⚡ Быстрая HTTP установка | ✅ Протестировано |
| `uninstall-n8n.sh` | v2.2 | 🗑️ Полное удаление с режимом --auto | ✅ Протестировано |
| `check-requirements.sh` | v1.0 | 🔍 Проверка системных требований | ✅ Протестировано |

## ✨ Возможности

- **🔒 HTTPS готов** - Автоматические SSL сертификаты через Let's Encrypt
- **⚡ Установка в один клик** - Полная автоматизация без настройки
- **🛡️ Безопасность в приоритете** - nginx прокси с заголовками безопасности
- **🔧 Простое управление** - systemd сервис с автозапуском
- **🗑️ Чистое удаление** - Опция полной деинсталляции
- **✅ Предварительная проверка** - Проверка системных требований

## 📖 Руководство по установке

### Шаг 1: Проверка требований
```bash
# Скачать и запустить проверку системы
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/check-requirements.sh | bash
```

**Требования:**
- **ОС:** Ubuntu 22.04 LTS
- **RAM:** Минимум 1 GB, рекомендуется 2+ GB
- **CPU:** Любой современный процессор (2+ ядра рекомендуется)
- **Диск:** Минимум 4 GB SSD, рекомендуется 40+ GB
- **Права:** sudo привилегии
- **Домен:** DNS указывающий на ваш сервер (только для HTTPS)

### Шаг 2: Настройка DNS
Настройте DNS записи у вашего регистратора домена или DNS провайдера:

**Добавьте A-записи:**
- `yourdomain.com` → `YOUR_SERVER_IP`
- `www.yourdomain.com` → `YOUR_SERVER_IP` (опционально)

**Где настраивать:**
- У **регистратора домена** (где покупали домен)
- Или у **DNS провайдера** (если используете внешний DNS)

**Проверка распространения DNS:**
```bash
# Проверить что домен указывает на ваш сервер
dig +short yourdomain.com

# Должен вернуть IP вашего сервера
```
### Шаг 3: Установка

### Продакшн установка (с SSL) - скрипт запросит домен и email
```bash
sudo -E DOMAIN="yourdomain.com" EMAIL="your@email.com" bash -c 'curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/install-n8n.sh | bash'
```

### Установка для разработки (только HTTP)
```bash
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/simple-install.sh | sudo bash
```

## 🛠️ Что устанавливается

- **Node.js 20** - Последняя LTS версия через NodeSource
- **n8n** - Последний стабильный релиз через npm
- **nginx** - Веб-сервер и обратный прокси
- **certbot** - Управление SSL сертификатами
- **systemd сервис** - Управление процессами и автозапуск

## 🛡️ Функции безопасности

- **SSL/TLS шифрование** с автоматическим обновлением
- **Заголовки безопасности** (HSTS, X-Frame-Options, и др.)
- **Настройка файервола** (правила ufw)
- **Изоляция сервиса** (выделенная учетная запись пользователя)
- **Усиление прав доступа** к файлам

## 🚨 Устранение неполадок

### Частые проблемы

**Проблемы DNS:**
```bash
# Проверить разрешение DNS
dig +short yourdomain.com
nslookup yourdomain.com

# Перезапустить nginx
sudo systemctl restart nginx
```

**Проблемы SSL сертификата:**
```bash
# Ручное обновление сертификата
sudo certbot renew --dry-run
sudo certbot certificates

# Проверить конфигурацию nginx
sudo nginx -t
```

**Проблемы сервиса:**
```bash
# Проверить статус сервиса n8n
sudo systemctl status n8n
sudo journalctl -u n8n -f

# Перезапустить сервисы
sudo systemctl restart n8n nginx
```

### Расположение логов
- **логи n8n:** `sudo journalctl -u n8n -f`
- **логи nginx:** `/var/log/nginx/`
- **логи certbot:** `/var/log/letsencrypt/`

## 📄 Лицензия

Этот проект лицензирован под MIT License - см. файл [LICENSE](LICENSE) для деталей.

## ⭐ Поддержка

Если этот проект вам помог, пожалуйста поставьте ⭐ на GitHub!

## 🔗 Ссылки

- [Официальная документация n8n](https://docs.n8n.io/)
- [Ubuntu 22.04 LTS](https://ubuntu.com/download/server)
- [Let's Encrypt](https://letsencrypt.org/)
- [MyHost.pro](https://myhosti.pro/services/auction) - Рекомендуемый хостинг

---
