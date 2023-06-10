package planetresearch
package modules.spark.config

import com.typesafe.config.{Config, ConfigFactory}

object SparkConfig {
  private val config: Config = ConfigFactory.load()

  def getSparkAppName: String = config.getString("planetresearch.spark.app_name")

  def getSparkMaster: String = config.getString("planetresearch.spark.master")
}
