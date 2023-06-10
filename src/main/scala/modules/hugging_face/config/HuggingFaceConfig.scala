package planetresearch
package modules.hugging_face.config

import com.typesafe.config.Config

object HuggingFaceConfig {
  private val config: Config = com.typesafe.config.ConfigFactory.load()

  def getHuggingFaceActorName: String = "ActorSystem"

  def getHuggingFaceName: String = config.getString("planetresearch.hugging_face.name")

  def getHuggingFaceToken: String = config.getString("planetresearch.hugging_face.token")

  def getHuggingFaceDatasetNameUrl: String = config.getString("planetresearch.hugging_face.dataset_url")

  def getHuggingFaceScientificPaper: String = config.getString("planetresearch.hugging_face.papers.scientific")
}
