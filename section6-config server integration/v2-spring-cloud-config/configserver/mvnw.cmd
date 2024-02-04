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
             default-label: main  ==> here put branch name
             timeout: 5  ==> configserver wait fot  5 sec to connect with github server else through error.
             clone-on-start: true ==> true means config server clone github repo while server start up. if false means cloning happens while first request came to config server.
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


 7. then verify by starting both configserver and accounts application server.
    localhost: 88071/<spring.application.name>/<environment>
    Ex:
      localhost:88071/accounts/qa
      here you will get all configuration in json format.
      response ::

      {
      "name": "accounts",
      "profiles": [
      "qa"
      ],
      "label": null,
      "version": "a718ea09891c741b1d8545cecc3fde6c7b262a51",
      "state": null,
      "propertySources": [
      {
      "name": "https://github.com/eazybytes/eazybytes-config.git/accounts-qa.yml",   ==> location of all application yml file.
      "source": {
      "build.version": "2.0",
      "accounts.message": "Welcome to EazyBank accounts related QA APIs ",
      "accounts.contactDetails.name": "Smitha Ray - QA Lead",
      "accounts.contactDetails.email": "smitha@eazybank.com",
      "accounts.onCallSupport[0]": "(666) 265-3765",
      "accounts.onCallSupport[1]": "(666) 734-8371"
      }
      },
      {
      "name": "https://github.com/eazybytes/eazybytes-config.git/accounts.yml", ==> location of all application yml file.
      "source": {
      "build.version": "3.0",
      "accounts.message": "Welcome to EazyBank accounts related docker APIs ",
      "accounts.contactDetails.name": "John Doe - Developer",
      "accounts.contactDetails.email": "john@eazybank.com",
      "accounts.onCallSupport[0]": "(555) 555-1234",
      "accounts.onCallSupport[1]": "(555) 523-1345"
      }
      }
      ]
      }


Step to encrypt properties in yml file:

1. put below configuration in configserver yml file.configserver

   encrypt:
     key: "45D81EC1EF61DF9AD8D3E5BB397F9"

2. then import below curl in postman:

   curl --location 'http://localhost:8071/encrypt' \
   --header 'Content-Type: text/plain' \
   --data-raw 'aishwarya@eazybank.com'

   Note : in postman body select raw data.

   and try to hit, once you hit above api then you will get encrypted data.
   and put that encrypted data where yuo want to put.

   Ex:

   accounts:
     message: "Welcome to EazyBank accounts related prod APIs "
     contactDetails:
       name: "Reine Aishwarya - Product Owner"
       email: "aishwarya@eazybank.com"
     onCallSupport:
       - (453) 392-4829
       - (236) 203-0384

    let encrypt aishwarya@eazybank.com mail id.

    with this email id hit above api. you will get encrypted data. then replace plane email with encrypted data.

    accounts:
         message: "Welcome to EazyBank accounts related prod APIs "
         contactDetails:
           name: "Reine Aishwarya - Product Owner"
           email: "bdsaddasslfsfdslgsjNDJDASKSKLKSDVSDVDSVSDMVMKJDV"
         onCallSupport:
           - (453) 392-4829
           - (236) 203-0384


           and when you hit account service then you will get decrypted email.