Step to integrate config server:

1. create one project with name configserver.
2. add config-serevr depedency.

   <dependency>
   	   <groupId>org.springframework.cloud</groupId>
   	   <artifactId>spring-cloud-config-server</artifactId>
   	</dependency>

3. Create one folder with config and create multiple yml file for each project(local, qa, prod, etc)
4. add configuration in yml file.
   # if we want to use local yml file(active: native).

   spring:
     application:
       name: "configserver"
     profiles:
       active: native
     cloud:
       config:
         server:
           native:
             search-locations: "classpath:/config"

   # if we want to use remote (git) yml file(active: git)
   spring:
     application:
       name: "configserver"
     profiles:
       active: git
     cloud:
       config:
         server:
           git:
             uri: "https://github.com/eazybytes/eazybytes-config.git"
             default-label: main
             timeout: 5
             clone-on-start: true
             force-pull: true

5. add below dependency in accounts project:

      <dependency>
      			<groupId>org.springframework.cloud</groupId>
      			<artifactId>spring-cloud-starter-config</artifactId>
      </dependency>

      # it is provide integration.
      <dependencyManagement>
      		<dependencies>
      			<dependency>
      				<groupId>org.springframework.cloud</groupId>
      				<artifactId>spring-cloud-dependencies</artifactId>
      				<version>${spring-cloud.version}</version>
      				<type>pom</type>
      				<scope>import</scope>
      			</dependency>
      		</dependencies>
      	</dependencyManagement>

5. goto accounts project, and do following setup in yml file.

   spring:
     application:
       name: "accounts"
     profiles:
       active: "prod" #which profile environment you want to use, put here. like prod, qa etc.
     config:
       import: "optional:configserver:http://localhost:8071/"


   Note : ==> we need to keep application name(spring.application.name=accounts) must be
   "accounts",in configserver project cofig folder, because based on this name we have create corresponding yml file.
    Syntax :
       <spring.application.name>.yml
       <spring.application.name>-qa.yml
       <spring.application.name>-prod.yml

   Ex: accounts.yml
       accounts-prod.yml
       accounts-qa.yml

   based on application we need to create yml file.

