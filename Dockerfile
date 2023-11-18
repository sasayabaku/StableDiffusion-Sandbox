FROM nvidia/cuda:12.1.1-devel-ubuntu20.04

# COPY ./resource /resource

RUN apt update 
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y build-essential vim \
    wget curl git zip gcc make openssl \
    libssl-dev libbz2-dev libreadline-dev \
    libsqlite3-dev python3-tk tk-dev python-tk \
    libfreetype6-dev libffi-dev liblzma-dev -y

RUN git clone https://github.com/yyuu/pyenv.git /root/.pyenv
ENV HOME  /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN pyenv --version
RUN pyenv install 3.10
RUN pyenv global 3.10
RUN python --version
RUN pyenv rehash


# Install Stable diffusion UI
RUN pip install --upgrade pip


RUN mkdir /workspace
WORKDIR /workspace

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
WORKDIR /workspace/stable-diffusion-webui

COPY ./src /workspace/src
RUN pip install -r /workspace/src/requirements.txt


# RUN  wget https://huggingface.co/nuigurumi/basil_mix/resolve/main/Basil_mix_fixed.safetensors -O /workspace/stable-diffusion-webui/models/Stable-diffusion/Basil_mix_fixed.safetensors
# RUN wget https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors -O /workspace/stable-diffusion-webui/models/VAE/vae-ft-mse-840000-ema-pruned.safetensors

# COPY ./resource/bra_v5.safetensors /workspace/stable-diffusion-webui/models/Stable-diffusion/bra_v5.safetensors
# COPY ./resource/museV1_v1.safetensors /workspace/stable-diffusion-webui/models/museV1_v1.safetensors

# CMD python launch.py --share --xformers --enable-insecure-extension-access

CMD ["/workspace/src/startup.sh"]
