uname -a
apt-get update
apt -y install git
mkdir /root/huhang
cd /root/huhang
git clone https://github.com/bhlx3lyx7/griffin-sample.git
cd griffin-sample/accuracy-sample/

hadoop fs -mkdir -p /griffin/accuracy/persist
hadoop fs -mkdir -p /griffin/data/
hadoop fs -put users_info_src.avro /griffin/data/
hadoop fs -put users_info_target.avro /griffin/data/
curl -O https://search.maven.org/remotecontent?filepath=org/apache/griffin/measure/0.1.5-incubating/measure-0.1.5-incubating.jar
spark-submit --class org.apache.griffin.measure.batch.Application \
	--master yarn-client \
	measure-0.1.5-incubating.jar \
	env.json config.json local,local
