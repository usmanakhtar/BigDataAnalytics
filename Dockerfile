# Use Jupyter PySpark Notebook as base
FROM jupyter/pyspark-notebook:latest

# Switch to root to install Spark
USER root

# Install dependencies
RUN apt-get update && apt-get install -y curl openjdk-11-jdk && apt-get clean

# Set environment variable for Java
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Download and install Spark 3.3.0 with Hadoop 3
RUN curl -L https://archive.apache.org/dist/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz | tar xz -C /opt/ && \
    mv /opt/spark-3.3.0-bin-hadoop3 /opt/spark

# Set Spark environment variables
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS="lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser"

# Create working directory
WORKDIR /home/jovyan/work

# Switch back to default user
USER jovyan

# Register PySpark kernel
RUN /opt/conda/bin/python -m ipykernel install --user --name pyspark --display-name "PySpark"

# Launch JupyterLab without token
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
