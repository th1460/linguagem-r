FROM openwhisk/dockerskeleton
ARG NOT_CRAN=TRUE
ARG ARROW_R_DEV=TRUE
RUN apk update && apk add R R-dev R-doc \
    build-base libsodium-dev autoconf automake bash \ 
    cmake g++ gcc make libxml2-dev
RUN set -ex && apk --no-cache add sudo
RUN sudo R -e "install.packages('arrow', repos = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN sudo R -e "install.packages(c('jsonlite', 'tidypredict', 'pins', 'paws.storage'), repos = 'http://cran.rstudio.com/')"