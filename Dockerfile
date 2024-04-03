# Используем базовый образ с Nginx
FROM nginx

# Установка пакетов openssh-server и vim (для удобства редактирования)
RUN apt-get update && apt-get install -y openssh-server vim

# Создаем привилегированную директорию для SSH
RUN mkdir /run/sshd

# Копируем файл конфигурации Nginx
COPY html/nginx.conf /etc/nginx/nginx.conf

# Копируем файлы вашего проекта внутрь контейнера
COPY html/assets /usr/share/nginx/html/assets
COPY html/icons /usr/share/nginx/html/icons
COPY html/favicon.ico /usr/share/nginx/html/favicon
COPY html/index.html /usr/share/nginx/html/index.html

# Копируем файл конфигурации SSH
COPY html/sshd_config /etc/ssh/sshd_config

# Генерация ключей SSH (пример, не для продакшена)
RUN ssh-keygen -A

# Set the root password
RUN echo 'root:kdenisb' | chpasswd

# Открываем порты 80 (для Nginx) и 22 (для SSH)
EXPOSE 80 22

# Запускаем SSH и Nginx при старте контейнера
CMD ["sh", "-c", "exec nginx -g 'daemon off;' & /usr/sbin/sshd -D"]