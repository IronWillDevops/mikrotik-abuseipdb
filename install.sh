#!/bin/bash

# Параметры приложения
APP_NAME="mikrotik-abuseipdb"
GITHUB_REPO="IronWillDevops/mikrotik-abuseipdb"
INSTALL_DIR="/etc/ITkha/$APP_NAME"
VERSION_FILE="$INSTALL_DIR/version.txt"
REMOTE_TAGS_URL="https://api.github.com/repos/$GITHUB_REPO/tags"
REMOTE_ARCHIVE_URL="https://github.com/$GITHUB_REPO/archive/"

# Функция для получения текущей версии приложения
get_local_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "0.0.0.0"
    fi
}

# Функция для получения последней версии приложения с GitHub
get_remote_version() {
    local latest_tag=$(curl -s "$REMOTE_TAGS_URL" | jq -r '.[0].name' 2>/dev/null)
    echo "${latest_tag#v}"  # Извлекаем версию из тега, например, "v1.2.3" -> "1.2.3"
}

# Функция для установки или обновления приложения
install_or_update_app() {
    local local_version=$(get_local_version)
    local remote_version=$(get_remote_version)

    if [ "$local_version" == "$remote_version" ]; then
        echo "The application is already installed and up to date (version $local_version)."
    else
        echo "Application update (version $local_version -> $remote_version)."

        # Скачивание и распаковка архива с GitHub
        curl -sL "${REMOTE_ARCHIVE_URL}${remote_version}.tar.gz" | tar -xz -C "$INSTALL_DIR" --strip-components=1

        # Обновление файла версии
        echo "$remote_version" > "$VERSION_FILE"

        echo "The update completed successfully."
    fi
}

# Основной блок скрипта
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Installing the application in $INSTALL_DIR."
    
    # Скачивание и распаковка архива с GitHub
    mkdir -p "$INSTALL_DIR"
    curl -sL "${REMOTE_ARCHIVE_URL}main.tar.gz" | tar -xz -C "$INSTALL_DIR" --strip-components=1

    # Запись версии в файл
    get_remote_version > "$VERSION_FILE"

    echo "Installation completed successfully."
else
    install_or_update_app
fi
 sudo cp -r ./*  $INSTALL_DIR
