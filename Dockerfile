# Use the official Jupyter PySpark Notebook image as the base image
FROM jupyter/pyspark-notebook:latest

# Switch to root user to install packages
USER root

# Set environment variables for PySpark
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS="lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser"

# Set the working directory in the container
WORKDIR /home/jovyan/work

# Install Hive and its dependencies
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://downloads.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz && \
    tar -xzf apache-hive-3.1.3-bin.tar.gz && \
    mv apache-hive-3.1.3-bin /opt/hive && \
    rm apache-hive-3.1.3-bin.tar.gz && \
    apt-get clean

# Set Hive environment variables
ENV HIVE_HOME=/opt/hive
ENV PATH=$PATH:$HIVE_HOME/bin

# Switch back to the jovyan user
USER jovyan

# Install PySpark and any other necessary Python packages
# RUN pip install pyspark

# Register PySpark kernel in user path (not system-wide)
RUN /opt/conda/bin/python -m ipykernel install --user --name pyspark --display-name "PySpark"

# Launch JupyterLab with no token/password
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
