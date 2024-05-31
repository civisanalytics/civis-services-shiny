FROM civisanalytics/datascience-r:4.0.4

RUN apt-get update && apt-get install -y \
    git

COPY ./requirements.txt /requirements.txt
RUN Rscript -e "packages <- readLines('/requirements.txt'); install.packages(packages)"

COPY ./app ./app

EXPOSE 3838

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
