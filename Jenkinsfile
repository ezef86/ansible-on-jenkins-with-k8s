pipeline {
    // 1. Specify the agent to use
    // This tells Jenkins to run the pipeline inside a Docker container
    // built from the image you pushed to Docker Hub.
    agent {
        docker {
            image 'colosodocker/ansible-agent'
            args '-u root' // Run the container as root to have permissions
        }
    }

    // 2. Define environment variables used in the pipeline
    environment {
        // Use the branch name to determine the current environment
        // The trim() function removes any whitespace.
        // The toLowerCase() makes it 'dev', 'test', or 'main' consistently.
        ENV_NAME = "${env.BRANCH_NAME.trim().toLowerCase()}"
    }

    // 3. Define the stages of the pipeline
    stages {
        stage('Checkout') {
            steps {
                // This step is mostly automatic. Jenkins checks out the
                // code from the branch that triggered the job.
                checkout scm
                echo "Running deployment for [${ENV_NAME}] environment."
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                // 4. Securely load the SSH key credential
                // 'ec2-ssh-key' is the ID you gave the SSH key in Jenkins.
                // The key is loaded into the SSH_KEY variable.
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {

                    // 5. Check which environment we are in and run the playbook
                    // The script block allows for more complex Groovy logic.
                    script {
                        // We map the branch name to the correct inventory file path.
                        def inventoryPath = ""
                        if (env.ENV_NAME == 'dev') {
                            inventoryPath = "ansible/inventory/dev"
                        } else if (env.ENV_NAME == 'test') {
                            inventoryPath = "ansible/inventory/test"
                        } else if (env.ENV_NAME == 'main') {
                            // In a real-world scenario, the `main` branch might deploy to `prod`
                            inventoryPath = "ansible/inventory/prod"
                        } else {
                            // If the branch is something else, stop the pipeline.
                            error "Unknown branch: ${env.ENV_NAME}. No inventory found."
                        }
                        
                        // For production, add a manual approval step.
                        // Jenkins will pause and wait for a user to click "Proceed".
                        if (env.ENV_NAME == 'main') {
                            input "Deploy to PRODUCTION?"
                        }

                        // 6. Execute the Ansible command
                        // This command is executed inside the Docker container.
                        sh """
                        ansible-playbook \\
                            --private-key ${SSH_KEY} \\
                            -i ${inventoryPath} \\
                            -e "@ansible/vars/${env.ENV_NAME == 'main' ? 'prod' : env.ENV_NAME}.yml" \\
                            ansible/deploy-webapp.yml
                        """
                    }
                }
            }
        }
    }

    // 7. Post-build actions
    // This block runs after all stages are complete.
    post {
        always {
            echo 'Pipeline finished.'
            cleanWs() // Clean up the workspace
        }
    }
}