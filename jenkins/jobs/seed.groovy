pipelineJob('address-book-pipeline') {
    description('CI/CD pipeline for the Address Book Spring Boot application. Source is fetched from the address-book GitHub repo.')

    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/jasoncalalang/address-book.git')
                    }
                    branches('*/main')
                }
            }
            scriptPath('Jenkinsfile')
            lightweight(false)
        }
    }

    triggers {
        scm('H/5 * * * *')
    }
}
