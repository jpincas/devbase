# syntax=docker/dockerfile:1

FROM golang:1.20

# First install all necessary tools
RUN apt update
RUN apt install -y wget unzip

# Node
RUN wget https://deb.nodesource.com/setup_19.x 
RUN chmod +x setup_19.x
RUN ./setup_19.x
RUN apt-get install -y nodejs
#
# Elm
RUN wget -O elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
RUN gunzip elm.gz
RUN chmod +x elm
RUN mv elm /usr/local/bin/

# Sass
RUN wget https://github.com/sass/dart-sass/releases/download/1.58.3/dart-sass-1.58.3-linux-x64.tar.gz
RUN tar -xvzf dart-sass-1.58.3-linux-x64.tar.gz 
RUN mv dart-sass/sass /usr/local/bin/
RUN mv dart-sass/src/ /usr/local/bin/

# WKHMTLTOPDF
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb
RUN apt install ./wkhtmltox_0.12.6.1-2.bullseye_amd64.deb -y

# json2goconst
RUN go install github.com/jpincas/json2goconst@latest 

# DEV TOOLS
RUN apt install -y wget zsh ripgrep fish entr

# ZSH, Oh my ZSH
RUN chsh -s $(which zsh)
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Go dev tooling
RUN go install -v golang.org/x/tools/gopls@latest
RUN go install -v github.com/go-delve/delve/cmd/dlv@latest
RUN go install -v honnef.co/go/tools/cmd/staticcheck@latest