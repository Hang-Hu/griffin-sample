**Griffin accuracy sample**
--
Accuracy measures the match percentage of source data with target data, the formula of accuracy is
```
(# matched data in source and target) / (# source data) * 100%
```
In griffin, accuracy is an important measurement, we can create an accuracy sample by configuring our config files.

**data source**  
First of all, we need to prepare our data sources. Hive table or avro file are supported in current version.  
In this sample, we use avro files. Put our data files onto hdfs.
```
hadoop fs -put users_info_src.avro /griffin/data/
hadoop fs -put users_info_target.avro /griffin/data/
```

**env.json**  
We also need to configure the environment parameters.  
In env.json, we can configure spark parameters in "spark.config", just like the raw spark parameters. In "persist", we can configure multiple persist ways, supporting "log", "hdfs" and "http" ways.
```
{
  "spark": {
    "log.level": <the spark app log level>,
    "config": {
      <spark parameters>
    }
  },

  "persist": [
    {
      "type": "log",
      "config": {
        "max.log.lines": <max lines to log>
      }
    },
    {
      "type": "hdfs",
      "config": {
        "path": <persist path in hdfs>,
        "max.persist.lines": <max lines to persist>,
        "max.lines.per.file": <max lines per file to persist>
      }
    },
    {
      "type": "http",
      "config": {
        "method": <http method>,
        "api": <url>
      }
    }
  ]
}
```

**config.json**  
We need to configure the measure parameters. "source" and "target" are parameters of source and target data sources, "evaluateRule.rule" defines the measure rule for source and target.  
```
{
  "name": <app name>,
  "type": "accuracy",

  "process.type": "batch",

  "source": {
    "type": "avro",
    "version": <avro version>,
    "config": {
      "file.name": <avro file path>
    }
  },

  "target": {
    "type": "avro",
    "version": <avro version>,
    "config": {
      "file.name": <avro file path>
    }
  },

  "evaluateRule": {
    "rules": "$source.user_id = $target.user_id AND $source.first_name = $target.first_name AND $source.last_name = $target.last_name AND $source.address = $target.address AND $source.email = $target.email AND $source.phone = $target.phone AND $source.post_code = $target.post_code"
  }
}
```

**execution**  
After data and configuration files prepared, we can execute griffin measure manually.  
1. Download [griffin measure package](https://search.maven.org/remotecontent?filepath=org/apache/griffin/measure/0.1.5-incubating/measure-0.1.5-incubating.jar).
2. Move griffin measure package and two configuration files in the same directory.
3. Submit spark application to execute griffin accuracy sample.  
```
spark-submit --class org.apache.griffin.measure.batch.Application \
--master yarn-client \
measure-0.1.5-incubating.jar \
env.json config.json local,local
```
Actually, env.json and config.json could be deployed on local file system, hdfs or raw json string, with the third parameter describing the types of them, "local,local" means that env.json and config.json are both local file system paths.  

**result**  
After execution of measurement, we can get result as configured in "persist" field.  
"log": the result will be printed in console.  
"hdfs": the result will be persisted in hdfs path configured.  
"http": the result will be submitted to the url by the http method configured.
