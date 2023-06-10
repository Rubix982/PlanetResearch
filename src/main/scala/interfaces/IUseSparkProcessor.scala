package planetresearch
package interfaces

import modules.spark.container.SparkSessionSingleton

import org.apache.spark.sql.SparkSession

trait IUseSparkProcessor {
  protected val spark: SparkSession = SparkSessionSingleton.getInstance()
}
