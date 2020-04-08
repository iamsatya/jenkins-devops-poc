pipeline{
  agent any
  environment {
    PATH = "${PATH}:${getTerraformPath()}"
  }
  stages{
    stage('S3bucket'){
	  steps{
	    sh "ansible-playbook s3bucket.yml"
		}
	}
	stage('terraform-init'){
	  steps{
	    sh "terraform init"
		sh "ansible-playbook terraformbackend.yml"
		sh "terraform apply -auto-approve"
		}
	}
	stage ('Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }
    stage ('Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true clean test compile package' 
            }
        }
  }
}  

def getTerraformPath(){
  def tfHome = tool name: 'terraform12', type: 'terraform'
  return tfHome
  }
 