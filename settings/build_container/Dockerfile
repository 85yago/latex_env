FROM python:3.10-slim-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    file \
    gcc \
    git \
    libc6-dev \
    locales \
    make \
    perl \
    vim \
    ssh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git config --global core.filemode false

# Set the locale
RUN sed -i 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV DISPLAY host.docker.internal:0.0

RUN pip install pygments

RUN cpan YAML::Tiny File::HomeDir Unicode::GCString

ADD ./indentconfig.yaml /root/

WORKDIR /root/donwload/

ADD ./texlive.profile /root/donwload/

RUN curl -OL http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

RUN tar xvf install-tl-unx.tar.gz

RUN cd install-tl-2* && ./install-tl -no-gui -profile /root/donwload/texlive.profile

RUN tlmgr update --self

RUN tlmgr install pict2e framed frame algorithmicx algorithms mathtools minted mdframed multirow braket tcolorbox graphics algpseudocodex askmaps float fvextra etoolbox fancyvrb upquote lineno catchfile xstring zref needspace pgf environ everyhook svn-prov import latexindent newtx fontaxes xkeyval filehook type1cm fontspec bxpapersize circuitikz siunitx cleveref autonum etextools textpos

ENV PATH $PATH:/usr/local/texlive/2022/texmf-dist/scripts/latexindent/
ENV PATH $PATH:/usr/local/texlive/2022/texmf-dist/scripts/latexindent/latexindent.pl
