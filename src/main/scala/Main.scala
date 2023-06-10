package planetresearch

object Main {
  def main(args: Array[String]): Unit = {
    val providers: List[interfaces.IDataHarvest] = List(
      new modules.hugging_face.providers.HuggingFaceHandler(),
    )

    providers.foreach(provider => provider.init())
  }
}