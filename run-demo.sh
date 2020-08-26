docker images | grep "^<none" | awk '{print $3}' | xargs docker rmi -f  > /dev/null
docker images | grep "^making/hello-" | awk '{print $3}' | xargs docker rmi -f  > /dev/null
docker volume ls | grep pack | awk '{print $2}' | xargs docker volume rm  > /dev/null

rm -rf hello-jjug

. demo-magic.sh
export DEMO_PROMPT="(\w): "
clear

export TYPE_SPEED=1000
export XMLLINT_INDENT="        "

############

printf "\033[32m⭐️ Spring InitializrでSpring Boot Projectの雛形を作成します \033[0m\n"
pe "curl -s https://start.spring.io/starter.tgz \\
  -d javaVersion=11 \\
  -d artifactId=hello-jjug  \\
  -d baseDir=hello-jjug \\
  -d dependencies=web  \\
  -d packageName=com.example  \\
  -d applicationName=HelloJjugApplication | tar -xzvf -"

############

printf "\033[32m⭐️ ディレクトリを変更します \033[0m\n"
pe "cd hello-jjug"

############

printf "\033[32m⭐️ ソースコードを修正します \033[0m\n"
pe "cat <<'EOF' > src/main/java/com/example/HelloJjugApplication.java
package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication(proxyBeanMethods = false)
@RestController
public class HelloJjugApplication {

        @GetMapping(\"/\") 
        public String hello() {
                return \"Hello JJUG!\";
        }

        public static void main(String[] args) {
                SpringApplication.run(HelloJjugApplication.class, args);
        }
}
EOF"
############

export TYPE_SPEED=50

printf "\033[32m⭐️ Cloud Native Buildpacksで普通のコンテナイメージをBuildします (BellSoft Liberica JRE) \033[0m\n"
pe "./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=making/hello-jjug:bellsoft -DskipTests"

printf "\033[32m⭐️ Dockerイメージを確認します \033[0m\n"
pe "docker images"

printf "\033[32m⭐️ Dockerイメージを実行します \033[0m\n"
pe "docker run --rm  \\
    -p 8080:8080  \\
    making/hello-jjug:bellsoft"

printf "\033[32m⭐️ ソースコードを更新します \033[0m\n"
pe "sed -i '' -e 's/JJUG/JJUG 🍃/g' src/main/java/com/example/HelloJjugApplication.java"

printf "\033[32m⭐️ Cloud Native Buildpacksで普通のコンテナイメージを再Buildします (BellSoft Liberica JRE) \033[0m\n"
pe "./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=making/hello-jjug:bellsoft -DskipTests"

printf "\033[32m⭐️ Dockerイメージを実行します \033[0m\n"
pe "docker run --rm  \\
    -p 8080:8080  \\
    making/hello-jjug:bellsoft"

printf "\033[32m⭐️ pom.xmlにnative image用のCustomBuilderの設定をします。 \033[0m\n"
pe "sed -i '' -e 's|<artifactId>spring-boot-maven-plugin</artifactId>|<artifactId>spring-boot-maven-plugin</artifactId><!-- ✨ここから✨ --><configuration><image><builder>making/java-native-image-cnb-builder</builder><env><BP_BOOT_NATIVE_IMAGE>1</BP_BOOT_NATIVE_IMAGE></env></image></configuration><!-- ✨ここまで✨ --><!-- 詳細は https://blog.ik.am/entries/542 -->|' pom.xml"

mv pom.xml pom.xml.bak
xmllint --format pom.xml.bak > pom.xml
rm -f pom.xml.bak

printf "\033[32m⭐️ pom.xmlを確認します。 \033[0m\n"
pe "cat pom.xml"


printf "\033[32m⭐️ Cloud Native Buildpacksでnative-imageのコンテナイメージをBuildします (GraalVM) \033[0m\n"
pe "./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=making/hello-jjug:native -DskipTests"

printf "\033[32m⭐️ Dockerイメージを確認します \033[0m\n"
pe "docker images"

printf "\033[32m⭐️ Dockerイメージを実行します \033[0m\n"
pe "docker run --rm  \\
    -p 8080:8080  \\
    making/hello-jjug:native"
