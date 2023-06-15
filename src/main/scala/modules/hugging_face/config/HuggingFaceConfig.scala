package planetresearch
package modules.hugging_face.config

import interfaces.IProvideTypesafeConfig

object HuggingFaceConfig extends IProvideTypesafeConfig {
  def getHuggingFaceActorName: String = "ActorSystem"

  def getHuggingFaceName: String = config.getString("planetresearch.hugging_face.name")

  def getHuggingFaceToken: String = config.getString("planetresearch.hugging_face.token")

  def getHuggingFaceDatasetNameUrl: String = config.getString("planetresearch.hugging_face.dataset_url")

  def getHuggingFaceScientificPaper: String = config.getString("planetresearch.hugging_face.papers.scientific")
}
