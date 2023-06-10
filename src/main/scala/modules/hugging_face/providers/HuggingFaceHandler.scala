package planetresearch
package modules.hugging_face.providers

import config.{HttpConfig, MiscConfig, PathsConfig}
import interfaces.IDataHarvest
import modules.file_path.Path
import modules.hugging_face.config.HuggingFaceConfig
import modules.parquet.ParquetSparkProcessor

import akka.actor.{ActorRef, ActorSystem, Props}
import akka.pattern.ask
import akka.routing.RoundRobinPool
import akka.util.Timeout

import scala.annotation.unused
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import scala.concurrent.duration.DurationInt

@unused
class HuggingFaceHandler extends IDataHarvest {

  private val sparkProcessor: ParquetSparkProcessor = new ParquetSparkProcessor()

  /**
   *
   */
  @unused
  override def init(): Unit = {
    // Create an actor system
    val system: ActorSystem = ActorSystem(HuggingFaceConfig.getHuggingFaceActorName)

    // Create a pool of HttpActors
    val pool: ActorRef = system.actorOf(Props[HuggingFaceActor].withRouter(RoundRobinPool(5)),
      HttpConfig.httpPoolReferenceName)

    // Send GET requests to the pool
    implicit val timeout: Timeout = Timeout(5.seconds)
    val responses: List[Future[Any]] = List(
      pool ? HuggingFaceConfig.getHuggingFaceScientificPaper
    )

    // Create the output path
    val outputPath: String = Path.join(
      Path.join(PathsConfig.CurrentUserProjectPath, MiscConfig.DataFolderName),
      HuggingFaceConfig.getHuggingFaceName)

    // Handle responses when they complete
    Future.sequence(responses).onComplete { results =>
      sparkProcessor.save(results.toString, outputPath)
    }
  }
}
