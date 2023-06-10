ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "2.13.11"

lazy val root = (project in file("."))
  .settings(
    name := "PlanetResearch",
    idePackagePrefix := Some("planetresearch")
  )

libraryDependencies += "com.typesafe.akka" %% "akka-actor" % "2.8.0"
libraryDependencies += "org.apache.spark" %% "spark-core" % "3.3.2"
libraryDependencies += "org.apache.spark" %% "spark-sql" % "3.3.2"
