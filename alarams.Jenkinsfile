pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    parameters {
        choice(name: 'workspace',  choices: ['dev', 'prod'])
        choice(name: 'region', choices: ['us-east-1', 'us-east-2', 'us-west-1', 'us-west-2', 'eu-central-1', 'eu-west-1', 'eu-west-2', 'eu-west-3', 'eu-north-1'])
        booleanParam(name: 'autoApprove', defaultValue: false)
        booleanParam(name: 'destroy', defaultValue: false)
    }

    stages {

        stage('Create Plan') {
            when{ expression {params.destroy == false }}
            steps {
                sh 'terraform init -input=false -no-color'
                sh "terraform workspace select -or-create -no-color ${params.region}-${params.workspace}"  // check workspace existence, create if new needed
                sh "terraform plan -input=false -out tfplan_out -no-color -var=region=\"${params.region}\" --var-file=regions/${params.region}-${params.workspace}.tfvars  --var-file=environments/${params.workspace}.tfvars"
                sh 'terraform show -no-color tfplan_out > tfplan.txt'
            }
        }


        stage('Destroy Plan') {
            when{ expression {params.destroy == true }}
            steps {
                sh 'terraform init -input=false -no-color'
                sh "terraform workspace select -or-create -no-color ${params.region}-${params.workspace}"  // check workspace existence, create if new needed
                sh "terraform plan -destroy -input=false -out tfplan_out -no-color -var=region=\"${params.region}\" --var-file=regions/${params.region}-${params.workspace}.tfvars  --var-file=environments/${params.workspace}.tfvars"
                sh 'terraform show -no-color tfplan_out > tfplan.txt'
            }
        }

        stage('Approval') {
            when { expression { params.autoApprove == false  } }
            steps{
                 script {
                def plan = readFile 'tfplan.txt'
                input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
            }
            }
           
        }


        stage('Apply') {
            steps {
                sh "terraform apply -no-color -input=false tfplan_out"
            }
        }

        
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    }
}