# Use the official Jupyter PySpark Notebook image as the base image
FROM jupyter/pyspark-notebook:latest

# Set environment variables for PySpark
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS="lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser"

# Set the working directory in the container
WORKDIR /home/jovyan/work

# Install PySpark and any other necessary Python packages
RUN pip install pyspark

# Register PySpark kernel in user path (not system-wide)
RUN /opt/conda/bin/python -m ipykernel install --user --name pyspark --display-name "PySpark"

# Launch JupyterLab with no token/password
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
