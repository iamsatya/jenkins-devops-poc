pipeline{
  agent any
  environment {
    PATH = "${PATH}:${getTerraformPath()}"
  }
  stages{
    stage('S3bucket'){
	  steps{
	    sh "cp /etc/ansible/ansible.cfg-org ."
		sh "mv ansible.cfg-org ansible.cfg"
		sh "ansible-playbook s3bucket.yml"
		}
	}
	stage('terraform-init'){
	  steps{
	    sh "terraform init"
		sh "ansible-playbook terraformbackend.yml"
		sh "terraform apply -auto-approve"
		sh "rm -rf ansible.cfg"
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
	stage ('inventory') {
	  steps {
	    sh "chmod +x inventoryaws.sh"
		sh "./inventoryaws.sh"
      }   
    }
    
	stage('tomcat-install'){
	  steps{
	    sh "ansible-playbook -i dynainvent.aws tomcat-install.yml"
		}
	}
    
	stage('deploy'){
	  steps{
		sh "ansible-playbook -i dynainvent.aws deploy-app.yml"
		}
	}
 }
}  

def getTerraformPath(){
  def tfHome = tool name: 'terraform12', type: 'terraform'
  return tfHome
  }
 