 # syntax=docker/dockerfile:1

# BUILD STAGE
FROM golang:1.20.4-bullseye

# First install all necessary tools
RUN apt update
RUN apt install -y wget unzip

# Frontend
# Node
RUN wget https://deb.nodesource.com/setup_19.x 
RUN chmod +x setup_19.x
RUN ./setup_19.x
RUN apt-get install -y nodejs
#
# Elm
# There is no arm64 release of Elm, so this just uses the standard version
# It works on Mac but is slow and apparently uses a lot of memory
RUN wget -O elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
RUN gunzip elm.gz
RUN chmod +x elm
RUN mv elm /usr/local/bin/

# Sass
ARG BUILDARCH
RUN if [ "$BUILDARCH" = "arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=x64; fi \
    && wget "https://github.com/sass/dart-sass/releases/download/1.58.3/dart-sass-1.58.3-linux-${ARCHITECTURE}.tar.gz" \
    && tar -xvzf "dart-sass-1.58.3-linux-${ARCHITECTURE}.tar.gz" 
RUN mv dart-sass/sass /usr/local/bin/
RUN mv dart-sass/src/ /usr/local/bin/

# Dev
RUN apt install -y wget zsh ripgrep fish entr

# ZSH, Oh my ZSH
RUN chsh -s $(which zsh)
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Go tooling
RUN go install -v golang.org/x/tools/gopls@latest
RUN go install -v github.com/go-delve/delve/cmd/dlv@latest
RUN go install -v honnef.co/go/tools/cmd/staticcheck@latest

# WKHMTLTOPDF
RUN wget "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_${BUILDARCH}.deb"
RUN apt install "./wkhtmltox_0.12.6.1-2.bullseye_${BUILDARCH}.deb" -y