package planetresearch
package modules.spark.container

import modules.spark.config.SparkConfig

import org.apache.spark.sql.SparkSession

object SparkSessionSingleton {

  @transient private var instance: SparkSession = _

  def getInstance(): SparkSession = {
    if (instance == null) {
      instance = SparkSession.builder()
        .appName(SparkConfig.getSparkAppName)
        .master(SparkConfig.getSparkMaster)
        .getOrCreate()
    }
    instance
  }
}
