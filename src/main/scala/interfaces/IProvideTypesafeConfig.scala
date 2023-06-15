package planetresearch
package interfaces

import modules.file_path.PlanetResearchPathUtils

import com.typesafe.config.{Config, ConfigFactory}

import java.io.File

trait IProvideTypesafeConfig {
  private val projectRoot: String = PlanetResearchPathUtils.getCurrentWorkingDirectory

  private val configPath: String = s"$projectRoot/conf/application.conf"

  protected val config: Config = ConfigFactory.parseFile(new File(configPath))
}
