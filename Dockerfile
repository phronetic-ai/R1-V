FROM python:3.11

RUN mkdir -p /app
WORKDIR /app
ADD . .

RUN apt-get update && apt-get install -y \
    vim curl wget python3-dev build-essential ninja-build ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install NVIDIA CUDA Toolkit manually
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb \
    && dpkg -i cuda-keyring_1.0-1_all.deb \
    && apt-get update && apt-get install -y cuda-toolkit-12-4

# Set up environment variables for CUDA
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV CUDA_HOME="/usr/local/cuda"

# Ensure `nvcc` is installed
RUN nvcc --version

# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel

# Run setup.sh to install dependencies (including flash-attn)
RUN chmod +x setup.sh
RUN ./setup.sh

CMD ["sleep", "infinity"]
