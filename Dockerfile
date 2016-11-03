FROM debian:jessie
MAINTAINER Evan Floden <evanfloden@gmail.com>


RUN apt-get update -y --fix-missing && apt-get install -y \
    git \
    cmake \
    libargtable2-dev \
 wget \
 ed \
 less \
 locales \
 vim-tiny \
 git \
 cmake \
 build-essential \
 gcc-multilib \
 apt-utils \
 perl \
 python \
 ruby \
 expat \
 libexpat-dev \
 libarchive-zip-perl \
 libdbd-mysql \
 libdbd-mysql-perl \
 libdbd-pgsql \
 libgd2-noxpm-dev \
 libgd-gd2-perl \
 libpixman-1-0 \
 libpixman-1-dev \
 graphviz \
 libxml-parser-perl \
 libsoap-lite-perl \
 libxml-libxml-perl \
 libxml-dom-xpath-perl \
 libxml-libxml-simple-perl \
 libxml-dom-perl \
 cpanminus \
 && rm -rf /var/lib/apt/lists/*


# Install perl modules
RUN cpanm --force CPAN::Meta \
 XML::Parser \
 readline \ 
 Term::ReadKey \
 YAML \
 Digest::SHA \
 Module::Build \
 ExtUtils::MakeMaker \
 Test::More \
 Data::Stag \
 Config::Simple \
 Statistics::Lite \
 Statistics::Descriptive \
 Parallel::ForkManager \
 GD \
 GD::Graph \
 GD::Graph::smoothlines \
 Test::Most \
 Algorithm::Munkres \
 Array::Compare Clone \
 PostScript::TextBlock \
 SVG \
 SVG::Graph \
 Set::Scalar \
 Sort::Naturally \
 Graph \
 GraphViz \
 HTML::TableExtract \
 Convert::Binary::C \
 Math::Random \
 Error \
 Spreadsheet::ParseExcel \
 XML::Parser::PerlSAX \
 XML::SAX::Writer \
 XML::Twig XML::Writer \
 && rm -rf /root/.cpanm/work

# Install BioPerl last built and Guidance v2.01
RUN cpanm -v  \
 CJFIELDS/BioPerl-1.6.924.tar.gz \
 && apt-get update -y --fix-missing && apt-get install -y gengetopt \
 libpng-dev \
 time \
 && rm -rf /root/.cpanm/work \
 && wget -q -O- http://guidance.tau.ac.il/ver2/guidance.v2.01.tar.gz | tar xz && cd guidance.v2.01 && make

ENV PERL5LIB="/guidance.v2.01/www/Selecton:/guidance.v2.01/www/bioSequence_scripts_and_constants:/guidance.v2.01/www/Guidance"

#
# Clustal2 
# 
RUN wget -q http://www.clustal.org/download/current/clustalw-2.1-linux-x86_64-libcppstatic.tar.gz -O- \
  | tar xz \
  && mv clustalw-*/clustalw2 /usr/local/bin \
  && rm -rf clustalw-*
  
#
# Prank 
# 
RUN wget -O- -q http://wasabiapp.org/download/prank/prank.source.150803.tgz | tar xz \
  && cd prank-msa/src/ \
  && make \
  && cp prank /usr/local/bin \
  && rm -rf /prank-msa

#  
RUN wget -q http://mafft.cbrc.jp/alignment/software/mafft-7.130-with-extensions-src.tgz -O- \
  | tar xz && \
  cd mafft-7.130-with-extensions/core && \
  make && make install && \
  cd $HOME && \
  rm -rf mafft-7.130-with-extensions

#
# HMMER for esl-suite of tools
#
RUN wget -q http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2-linux-intel-x86_64.tar.gz && \
  tar xf hmmer-3.1b2-linux-intel-x86_64.tar.gz
  
ENV PATH=$PATH:/hmmer-3.1b2-linux-intel-x86_64/binaries

#
# Download T-Coffee pre-built package
#
RUN wget -q http://www.tcoffee.org/Packages/Stable/Version_11.00.8cbe486/linux/T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz && \
  tar xf T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz && \
  mv T-COFFEE_installer_Version_11.00.8cbe486_linux_x64 /opt/tcoffee && \
  rm -rf T-COFFEE_installer_Version_11.00.8cbe486_linux_x64.tar.gz
    
ENV PATH=$PATH:/opt/tcoffee/bin:/opt/tcoffee/plugins/linux/ TEMP=/tmp DIR_4_TCOFFEE=/opt/tcoffee EMAIL_4_TCOFFEE=tcoffee.msa@gmail.com CACHE_4_TCOFFEE=/tmp/cache/ LOCKDIR_4_TCOFFEE=/tmp/lck/ TMP_4_TCOFFEE=/tmp/tmp/  


#	
# Get and compile ClustalO
#
RUN wget http://www.clustal.org/omega/clustal-omega-1.2.1.tar.gz -q -O- | tar -xz &&\
  cd clustal-omega-1.2.1 &&\
  ./configure &&\
  make &&\
  cp src/clustalo /usr/local/bin/ &&\
  rm -rf /clustal-omega-1.2.1   


#
# Get and compile FastTree
#
RUN mkdir FastTree_dir &&\
 cd FastTree_dir &&\
 wget http://meta.microbesonline.org/fasttree/FastTree.c -q &&\
 gcc -O3 -finline-functions -funroll-loops -Wall -o FastTree FastTree.c -lm &&\
 mv FastTree /usr/local/bin/ &&\
 rm -rf /FastTree_dir

#
# Get and compile SeqBoot
#
RUN wget http://evolution.gs.washington.edu/phylip/download/phylip-3.696.tar.gz -q -O- | tar -xz &&\
 cd phylip-3.696/src &&\
 make -f Makefile.unx install &&\
 mv ../exe/seqboot /usr/local/bin/ &&\
 rm -rf /phylip-3.696

# Guidance v 1.5
 RUN wget http://guidance.tau.ac.il/ver2/guidance.v1.5.tar.gz && \
    tar xzf guidance.v1.5.tar.gz && cd guidance.v1.5 && make

ENV PERL5LIB="/guidance.v1.5/www/Selecton:/guidance.v1.5/www/bioSequence_scripts_and_constants:/guidance.v1.5/www/Guidance"
