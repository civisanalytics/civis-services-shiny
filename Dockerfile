FROM civisanalytics/datascience-r:4.0.4

RUN apt-get update && apt-get install -y \
    git

# TODO: Verify if these changes will work with pre-existing services
WORKDIR /app
COPY ./app .

COPY ./requirements.txt /requirements.txt
RUN Rscript -e "packages <- readLines('/requirements.txt'); install.packages(packages)"

EXPOSE 3838

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
