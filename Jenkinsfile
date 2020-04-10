pipeline{
  agent any
  environment {
    PATH = "${PATH}:${getTerraformPath()}"
  }
  stages{
    stage('TF-S3Bucket'){
	  steps{
	    sh "cp /etc/ansible/ansible.cfg-org ."
		sh "mv ansible.cfg-org ansible.cfg"
		sh "ansible-playbook s3bucket.yml"
		}
	}
	stage('TF-Backend'){
	  steps{
	    sh "terraform init"
		sh "ansible-playbook terraformbackend.yml"
		sh "terraform apply -auto-approve"
		sh "rm -rf ansible.cfg"
		}
	}
	stage ('APP-ENV') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }
    stage ('Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true clean compile test package' 
            }
        }
	stage ('AWS-Inventory') {
	  steps {
	    sh "chmod +x inventoryaws.sh"
		sh "./inventoryaws.sh"
      }   
    }
    
	stage('APPServer-Config'){
	  steps{
	    sh "ansible-playbook -i dynainvent.aws tomcat-install.yml"
		}
	}
    
	stage('APP-Deploy'){
	  steps{
		sh "ansible-playbook -i dynainvent.aws deploy-app.yml"
		}
	}
	
	stage('Scan with Probely') {
      steps {
        probelyScan targetId: 'YmxppLPT5uwC', credentialsId: 'probely-security'
      } 
    }
	
	
	stage('Feedback'){
	  steps{
	    slackSend botUser: true, 
	    channel: '#devops-cicd', 
	    color: 'good', 
	    message: '"Status of pipeline: ${currentBuild.currentResult}"',
	    notifyCommitters: true, 
	    teamDomain: 'govanin.slack.com',
	    tokenCredentialId: 'slack-token'
	    }
    }
 }
}  

def getTerraformPath(){
  def tfHome = tool name: 'terraform12', type: 'terraform'
  return tfHome
  }
 