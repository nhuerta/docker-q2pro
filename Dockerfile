FROM ubuntu:22.04

# Set noninteractive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    pkg-config \
    zlib1g-dev \
    meson \
    ninja-build \
    python3 \
    gcc-multilib \
    g++-multilib \
    && rm -rf /var/lib/apt/lists/*

# Clone q2pro repository
RUN git clone https://github.com/skullernet/q2pro.git /q2pro-src

# Create cross-file for build - using your exact format
WORKDIR /q2pro-src
RUN echo '[binaries]' > cross_file.txt && \
    echo "c = 'gcc'" >> cross_file.txt && \
    echo "cpp = 'g++'" >> cross_file.txt && \
    echo "ar = 'ar'" >> cross_file.txt && \
    echo "strip = 'strip'" >> cross_file.txt && \
    echo '[properties]' >> cross_file.txt && \
    echo "c_args = ['-m32']" >> cross_file.txt && \
    echo "c_link_args = ['-m32']" >> cross_file.txt && \
    echo "cpp_args = ['-m32']" >> cross_file.txt && \
    echo "cpp_link_args = ['-m32']" >> cross_file.txt && \
    echo "ld_args = ['-m32']" >> cross_file.txt && \
    echo '[host_machine]' >> cross_file.txt && \
    echo "system = 'linux'" >> cross_file.txt && \
    echo "cpu_family = 'x86'" >> cross_file.txt && \
    echo "cpu = 'i686'" >> cross_file.txt && \
    echo "endian = 'little'" >> cross_file.txt

# Build q2pro with meson
RUN meson setup builddir --cross-file=cross_file.txt -Dgame-abi-hack=enabled && \
    cd builddir && \
    ninja

# Create a non-root user to run the server
RUN useradd -m q2user

# Create the proper directory structure
RUN mkdir -p /home/q2user/.q2pro/baseq2 /home/q2user/.q2pro/ctf && \
    chown -R q2user:q2user /home/q2user/.q2pro

# Copy the compiled server to user's home directory
RUN cp /q2pro-src/builddir/q2proded /home/q2user/

# Set working directory
WORKDIR /home/q2user

# Use the non-root user
USER q2user

# Expose the default Quake 2 port
EXPOSE 27910/udp

# Command to run the server
# ./q2proded +game ctf +exec server.cfg +gamemap q2ctf1 +set sv_airaccelerate 1
CMD ["./q2proded", "+game", "ctf", "+exec", "server.cfg", "+gamemap", "q2ctf1", "+set", "sv_airaccelerate", "1"]
