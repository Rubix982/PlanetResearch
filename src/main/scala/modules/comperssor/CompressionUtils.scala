package planetresearch
package modules.comperssor

import org.apache.commons.compress.compressors.gzip.{GzipCompressorInputStream, GzipCompressorOutputStream}

import java.io.{ByteArrayInputStream, ByteArrayOutputStream}

object CompressionUtils {
  /**
   * @param data - uncompressed data
   * @return - compressed data
   */
  def compress(data: Array[Byte]): Array[Byte] = {
    val outputStream = new ByteArrayOutputStream()
    val compressor = new GzipCompressorOutputStream(outputStream)
    compressor.write(data)
    compressor.close()
    outputStream.toByteArray
  }

  /**
   * @param data - compressed data
   * @return - uncompressed data
   */
  def decompress(data: Array[Byte]): Array[Byte] = {
    val inputStream = new ByteArrayInputStream(data)
    val decompressor = new GzipCompressorInputStream(inputStream)
    val buffer = new Array[Byte](1024)
    var length = 0
    val outputStream = new ByteArrayOutputStream()
    while ( {
      length = decompressor.read(buffer)
      length != -1
    }) {
      outputStream.write(buffer, 0, length)
    }
    outputStream.toByteArray
  }
}
