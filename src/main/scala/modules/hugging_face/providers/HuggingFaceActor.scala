package planetresearch
package modules.hugging_face.providers

import config.HttpConfig
import modules.hugging_face.config.HuggingFaceConfig

import akka.actor.Actor

import java.net.URI
import java.net.http.{HttpClient, HttpRequest, HttpResponse}
import java.nio.charset.StandardCharsets

/**
 *
 */
class HuggingFaceActor extends Actor {

  def receive: Receive = {
    case url: String =>
      val response = makeHttpRequest(url)
      sender() ! response
  }

  def makeHttpRequest(dataset_name: String): String = {
    val datasetName = dataset_name
    val token = HuggingFaceConfig.getHuggingFaceToken
    val url = s"${HuggingFaceConfig.getHuggingFaceDatasetNameUrl}/$datasetName"

    val request = HttpRequest.newBuilder()
      .uri(URI.create(url))
      .header(HttpConfig.authHeader, s"${HttpConfig.authBearer} $token")
      .build()

    val client = HttpClient.newBuilder().build()
    val response = client.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8))

    response.body()
  }
}
