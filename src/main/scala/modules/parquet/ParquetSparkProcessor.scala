package planetresearch
package modules.parquet

import config.{DateConfig, FileTypes, MiscConfig}
import interfaces.{IBatchProcessor, IUseDataFrames, IUseSparkProcessor}
import modules.comperssor.CompressionUtils
import modules.file_path.Path

import org.apache.spark.TaskContext
import org.apache.spark.rdd.RDD
import org.apache.spark.sql.functions.{col, collect_list}
import org.apache.spark.sql.types.{BinaryType, StructField, StructType}
import org.apache.spark.sql.{DataFrame, Row, SaveMode}

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class ParquetSparkProcessor extends IUseSparkProcessor with IBatchProcessor with IUseDataFrames {

  override def save(input: String, outputPath: String, batchSize: Int): Unit = {
    val inputAsBytes = input.getBytes(MiscConfig.CharsetStandard)
    val compressedData = CompressionUtils.compress(inputAsBytes)
    val schema: StructType = StructType(Seq(StructField(DataFrameColumnName, BinaryType)))
    val data: DataFrame = spark.createDataFrame(Seq(compressedData)
      .map(Tuple1.apply))
      .toDF(DataFrameColumnName)
    val partitions: DataFrame = data.repartition(batchSize)

    partitions
      .select(collect_list(col(DataFrameColumnName)).over())
      .where(s"size($DataFrameColumnName) > 0")
      .foreachPartition { batch: Iterator[Row] => {
        val seqRow: Seq[Row] = batch.toSeq
        val seqString: Seq[String] = seqRow.map(_.mkString(MiscConfig.SeqRowToStringChar))
        writeBatch(seqString, schema, outputPath)
      }
      }
  }

  override def writeBatch(batch: Seq[String], schema: StructType, outputPath: String): Unit = {
    val timestamp: String = LocalDateTime.now.format(DateTimeFormatter.ofPattern(DateConfig.DateFormatForFileSave))
    val partitionIndex: Int = TaskContext.getPartitionId()
    val fileName: String = s"part-$timestamp-$partitionIndex.${FileTypes.Parquet}"
    val pathToSaveTo: String = Path.join(outputPath, fileName)
    val parallelizedBatch: RDD[String] = spark.sparkContext.parallelize(batch)
    val batchDF: DataFrame = spark.createDataFrame(parallelizedBatch.asInstanceOf[RDD[Row]], schema)
    batchDF.write.mode(SaveMode.Append).parquet(pathToSaveTo)
  }
}
