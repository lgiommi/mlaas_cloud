FROM continuumio/anaconda3
LABEL maintainer="Luca Giommi luca.giommi3@unibo.it"

# add environment
ENV WDIR=/workarea

# install several useful packages
RUN /opt/conda/bin/conda config --add channels conda-forge
RUN /opt/conda/bin/conda update --all
RUN /opt/conda/bin/conda install xrootd -y
RUN apt-get update && apt-get install -y libgtk2.0-dev && \
    rm -rf /var/lib/apt/lists/* && \
    /opt/conda/bin/conda install jupyter jupyterhub notebook -y && \
    /opt/conda/bin/conda install vim numpy pandas scikit-learn matplotlib pyyaml h5py keras -y && \
    /opt/conda/bin/conda upgrade dask && \
    /opt/conda/bin/conda install backports.lzma -y && \ 
    pip install gdown && \
    pip install tensorflow imutils

# install voms-clients
RUN apt-get update && apt-get install -y voms-clients

# install uproot
RUN /opt/conda/bin/conda install uproot==3.12

# install pytorch
RUN /opt/conda/bin/conda install pytorch -y

# build mlaas
WORKDIR ${WDIR}
RUN git clone https://github.com/vkuznet/MLaaS4HEP.git
ENV PYTHONPATH="${WDIR}/MLaaS4HEP/src/python:${PYTHONPATH}"
ENV PATH="${WDIR}/MLaaS4HEP/bin:${PATH}"

# run mlaas
WORKDIR ${WDIR}/folder_test
ENTRYPOINT ["python", "../MLaaS4HEP/src/python/MLaaS4HEP/workflow.py"]