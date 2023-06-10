package planetresearch
package config

object PathsConfig {
  def CurrentUserProjectPath: String = sys.env("user.dir")
}
