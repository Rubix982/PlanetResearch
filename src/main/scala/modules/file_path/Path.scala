package planetresearch
package modules.file_path

import java.io.File

object Path {
  def join(prefixPath: String, postfixPath: String): String = new File(prefixPath, postfixPath).getPath
}
