package planetresearch
package modules.spark.config

import com.typesafe.config.Config

object SparkConfig {
  private val config: Config = com.typesafe.config.ConfigFactory.load()

  def getSparkAppName: String = config.getString("planetresearch.spark.app_name")

  def getSparkMaster: String = config.getString("planetresearch.spark.master")
}
