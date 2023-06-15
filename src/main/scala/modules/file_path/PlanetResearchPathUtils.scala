package planetresearch
package modules.file_path

import java.io.File

object PlanetResearchPathUtils {
  def join(prefixPath: String, postfixPath: String): String = new File(prefixPath, postfixPath).getPath

  def getCurrentWorkingDirectory: String = System.getProperty("user.dir")
}
