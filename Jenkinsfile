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
	
	stage('terraform-destroy'){
	  steps{
	    sh "terraform destroy -auto-approve"
		}
	}
  }
}  

def getTerraformPath(){
  def tfHome = tool name: 'terraform12', type: 'terraform'
  return tfHome
  }
 