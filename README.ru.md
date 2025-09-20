# 🚀 Скрипты установки n8n

**Языки:** [English](README.md) | [Русский](README.ru.md)

Автоматизированные скрипты установки платформы автоматизации рабочих процессов n8n на Ubuntu 22.04 с поддержкой SSL

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu 22.04](https://img.shields.io/badge/Ubuntu-22.04%20LTS-orange.svg)](https://ubuntu.com/)
[![n8n Latest](https://img.shields.io/badge/n8n-Latest-blue.svg)](https://n8n.io/)

## 🚀 Быстрая установка

⚡ **Рекомендуется:** Протестировано и оптимизировано для VPS серверов [MyHosti.pro](https://myhosti.pro/en/services/vds) (тарифы MVK)

### Продакшн установка (с SSL)
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/n8n-installer/main/install-n8n.sh | sudo bash
```

### Установка для разработки (только HTTP)
```bash 
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/n8n-installer/main/simple-install.sh | sudo bash
```

## 📋 Что включено

| Скрипт | Версия | Назначение | Статус |
|--------|---------|------------|---------|
| `install-n8n.sh` | v2.3.1 | 🔒 Полная HTTPS настройка с nginx прокси | ✅ Протестировано |
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
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/n8n-installer/main/check-requirements.sh | bash
```

**Требования:**
- Ubuntu 22.04 LTS
- Минимум 1GB RAM
- sudo привилегии
- Домен с DNS указывающим на ваш сервер (для HTTPS)

### Шаг 2: Настройка DNS
Направьте ваш домен на IP сервера:
```bash
# Проверить распространение DNS
dig +short yourdomain.com
```

### Шаг 3: Запуск установки
```bash
# Скачать установщик
wget https://raw.githubusercontent.com/YOUR_USERNAME/n8n-installer/main/install-n8n.sh

# Сделать исполняемым
chmod +x install-n8n.sh

# Запустить установку
sudo ./install-n8n.sh
```

Установщик выполнит:
1. 📦 Установку Node.js 20 LTS
2. 🚀 Установку последней версии n8n
3. 🌐 Настройку nginx обратного прокси
4. 🔒 Получение SSL сертификата
5. ⚙️ Настройку systemd сервиса
6. 🎯 Настройку правил файервола

## 🔧 Расширенное использование

### Ручные шаги установки
```bash
# 1. Проверка системных требований
bash check-requirements.sh

# 2. Установка с пользовательским доменом
sudo ./install-n8n.sh --domain yourdomain.com --email your@email.com

# 3. Доступ к вашему экземпляру n8n
# https://yourdomain.com
```

### Удаление
```bash
# Интерактивное удаление
sudo bash uninstall-n8n.sh

# Тихое удаление
sudo bash uninstall-n8n.sh --auto
```

## 🛠️ Что устанавливается

- **Node.js 20** - Последняя LTS версия через NodeSource
- **n8n** - Последний стабильный релиз через npm
- **nginx** - Веб-сервер и обратный прокси
- **certbot** - Управление SSL сертификатами
- **systemd сервис** - Управление процессами и автозапуск

## 🌐 Точки доступа

- **HTTPS доступ:** `https://yourdomain.com` (Порт 443)
- **HTTP доступ:** `http://server-ip:5678` (только simple-install)
- **Внутренний сервис:** `localhost:5678` (за nginx прокси)

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

## 📁 Структура проекта

```
n8n-installer/
├── README.md                 # Этот файл
├── README.ru.md             # Русская документация
├── LICENSE                  # MIT лицензия
├── install-n8n.sh          # Основной HTTPS установщик
├── simple-install.sh       # HTTP-только установщик
├── uninstall-n8n.sh       # Скрипт полного удаления
├── check-requirements.sh   # Проверка системы
├── docs/
│   ├── installation.md     # Подробное руководство установки
│   ├── security.md        # Лучшие практики безопасности
│   └── troubleshooting.md # Частые проблемы и решения
└── examples/
    ├── nginx.conf         # Пример конфигурации nginx
    └── n8n.service       # Пример systemd сервиса
```

## 🤝 Участие в разработке

Мы приветствуем участие в разработке! Пожалуйста, см. [CONTRIBUTING.md](CONTRIBUTING.md) для деталей.

1. Сделайте Fork репозитория
2. Создайте вашу feature ветку (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте ваши изменения (`git commit -m 'Add amazing feature'`)
4. Отправьте в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект лицензирован под MIT License - см. файл [LICENSE](LICENSE) для деталей.

## ⭐ Поддержка

Если этот проект вам помог, пожалуйста поставьте ⭐ на GitHub!

## 🔗 Ссылки

- [Официальная документация n8n](https://docs.n8n.io/)
- [Ubuntu 22.04 LTS](https://ubuntu.com/download/server)
- [Let's Encrypt](https://letsencrypt.org/)
- [MyHost.pro VPS](https://myhost.pro) - Рекомендуемый хостинг

---

**✅ Протестировано на Ubuntu 22.04 LTS**  
**🚀 Готово к продакшену**  
**🔒 Ориентировано на безопасность**
