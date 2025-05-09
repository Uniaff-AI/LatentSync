FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

# Основное окружение
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    PYTHON_VERSION=3.10.13 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYENV_ROOT=/root/.pyenv \
    PATH=/root/.pyenv/shims:/root/.pyenv/bin:/root/.pyenv/versions/3.10.13/bin:$PATH

# Установка системных зависимостей и pyenv
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget unzip bzip2 ca-certificates build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev llvm libncursesw5-dev xz-utils tk-dev \
    libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libgl1 libglib2.0-0 \
    ffmpeg libsm6 libxext6 software-properties-common python3-pip git-lfs \
    cmake ninja-build && \
    git lfs install && \
    curl https://pyenv.run | bash && \
    pyenv install $PYTHON_VERSION && \
    pyenv global $PYTHON_VERSION

# Установка Python-зависимостей
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -rf /root/.cache/pip

# Копирование проекта
WORKDIR /workspace
COPY . /workspace

# Открытие порта для Gradio
EXPOSE 7860

# Запуск (по умолчанию Gradio)
CMD ["python", "gradio_app.py"]
