import os
import pyspark
# Configure Spark
master_url = "k8s://https://" + os.environ["KUBERNETES_SERVICE_HOST"] + ":" + os.environ["KUBERNETES_SERVICE_PORT_HTTPS"]
spark = pyspark.sql.SparkSession.builder \
    .master(master_url) \
    .appName("jupyter-spark") \
    .getOrCreate()
# Example usage
data = spark.range(100).toDF("value")
data.show()
