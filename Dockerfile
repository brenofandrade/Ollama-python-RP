ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

# # Set the shell and enable pipefail for better error handling
# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set basic environment variables
ARG PYTHON_VERSION
ARG TORCH_VERSION
ARG CUDA_VERSION

# Set basic environment variables
ENV SHELL=/bin/bash 
ENV PYTHONUNBUFFERED=True 
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS=/workspace/models
ENV DATA_DIR=/workspace/data
# ENV WEBUI_AUTH=False
ENV START_OLLAMA=True

# Override the default huggingface cache directory.
ENV HF_HOME="/runpod-volume/.cache/huggingface/"

# Faster transfer of models from the hub to the container
ENV HF_HUB_ENABLE_HF_TRANSFER="1"

# Shared python package cache
ENV PIP_CACHE_DIR="/runpod-volume/.cache/pip/"
ENV UV_CACHE_DIR="/runpod-volume/.cache/uv/"

# Set working directory
WORKDIR /

# Install essential packages (optimized to run in one command)
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        git wget curl bash nginx-light rsync sudo binutils ffmpeg lshw nano vim tzdata file build-essential nvtop htop \
        libgl1 libglib2.0-0 clang libomp-dev ninja-build \
        openssh-server ca-certificates && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# # Install essential Python packages
# RUN pip install --no-cache-dir -U \
#     pip setuptools wheel \
#     jupyterlab jupyterlab_widgets ipykernel ipywidgets \
#     numpy scipy matplotlib pandas scikit-learn seaborn requests tqdm pillow pyyaml \
#     huggingface_hub hf_transfer \
#     open-webui \
#     torch==${TORCH_VERSION} torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/${CUDA_VERSION}

# # Install Ollama
# ADD https://ollama.com/install.sh /ollama-installer.sh
# RUN sh /ollama-installer.sh && rm /ollama-installer.sh

# Create logs, models, and data subdirectories under /workspace
RUN mkdir -p /workspace/{logs,models,data}

# # NGINX Proxy Configuration
# COPY proxy/nginx.conf /etc/nginx/nginx.conf
# COPY proxy/readme.html /usr/share/nginx/html/readme.html
# COPY README.md /usr/share/nginx/html/README.md

# Copy and set execution permissions for start scripts
COPY scripts/start.sh /
COPY scripts/pre_start.sh /
COPY scripts/post_start.sh /
RUN chmod +x /start.sh /pre_start.sh /post_start.sh

# Set entrypoint to the start script
CMD ["/start.sh"]
