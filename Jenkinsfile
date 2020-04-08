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
	stage ('inventory') {
	  steps {
	    sh 'aws ec2 describe-instances --filter Name=tag-key,Values=Name --query "Reservations[*].Instances[*].{Instance:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value}" --output text | grep APP-Servers |cut -f 1 > dynainvent.aws'
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
 