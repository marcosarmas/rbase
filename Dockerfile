FROM ubuntu:14.04.4
###original: cannin/r-base
MAINTAINER marcosarmas

##### UBUNTU
# Update Ubuntu and add extra repositories
RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN apt-get -y install apt-transport-https

RUN echo 'deb https://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN add-apt-repository -y ppa:openjdk-r/ppa

RUN apt-get -y update && apt-get -y upgrade

# Install basic commands
RUN apt-get -y install links nano htop git

ENV R_BASE_VERSION 3.3.2-1trusty0

# Necessary for getting a specific R version (get oldest working packages by manual date comparison) and set main repository
#RUN apt-cache policy r-cran-matrix
RUN apt-get install -y --no-install-recommends \
  littler \
  r-cran-littler \
  r-cran-matrix=1.2-4-1trusty0 \
  r-cran-codetools=0.2-14-1~ubuntu14.04.1~ppa1 \
  r-cran-survival=2.38-3-1trusty0 \
  r-cran-nlme=3.1.123-1trusty0 \
  r-cran-mgcv=1.8-7-1trusty0 \
  r-cran-kernsmooth=2.23-15-1trusty0 \
  r-cran-cluster=2.0.3-1trusty0 \
  r-base=${R_BASE_VERSION}* \
  r-base-dev=${R_BASE_VERSION}* \
  r-recommended=${R_BASE_VERSION}* \
  r-doc-html=${R_BASE_VERSION}* \
  r-base-core=${R_BASE_VERSION}* \
  r-base-html=${R_BASE_VERSION}*

RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site
RUN echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r

# Install software needed for common R libraries
# For RCurl
RUN apt-get -y install libcurl4-openssl-dev
# For rJava
RUN apt-get -y install libpcre++-dev
RUN apt-get -y install openjdk-8-jdk
# For XML
RUN apt-get -y install libxml2-dev

##### R: COMMON PACKAGES
# To let R find Java
RUN R CMD javareconf

COPY r-requirements.txt /
COPY installPackages.R /
COPY runInstallPackages.R /
RUN R -e 'source("runInstallPackages.R")'
