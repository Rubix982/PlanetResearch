package planetresearch
package config

object HttpConfig {
  def authHeader: String = "Authorization"

  def authBearer: String = "Bearer"

  def httpPoolReferenceName: String = "httpPool"
}
