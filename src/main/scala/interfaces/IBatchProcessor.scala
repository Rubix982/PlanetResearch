package planetresearch
package interfaces

import org.apache.spark.sql.types.StructType

trait IBatchProcessor {
  def writeBatch(batch: Seq[String], schema: StructType, outputPath: String): Unit

  def save(input: String, outputPath: String, batchSize: Int = 100): Unit
}
