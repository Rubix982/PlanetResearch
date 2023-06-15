package planetresearch
package modules.spark.config

import interfaces.IProvideTypesafeConfig

object SparkConfig extends IProvideTypesafeConfig {
  def getSparkAppName: String = config.getString("planetresearch.spark.app_name")

  def getSparkMaster: String = config.getString("planetresearch.spark.master")
}
