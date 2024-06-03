# Ansible Deployment

The following directory contains necessary files for nodes configuration




## Files summary

- /roles - Folder with ansible roles
- geocitizen-playbook.yml - Ansible playbook
- inventory.gcp.yml - GCP dynamic inventory for the playbook



## Using in Jenkins pipeline (see more in jenkins folder)

Code used in Jenkins pipeline for this ansible playbook

```bash
withCredentials([file(credentialsId: 'google_secret_file', variable: 'GCP_SERVICE_ACCOUNT_FILE')]) {
    script {
        env.GCP_PROJECT = "capybarageocity"
        sh "sed -i -e \'s/PROJECT_NAME/${env.GCP_PROJECT}/g\' ../inventory.gcp.yml"
        sh('sed -i -e \'s/CREDS_FILE_PATH/$GCP_SERVICE_ACCOUNT_FILE/g\' ../inventory.gcp.yml')
    }
    sh "ansible-inventory -i '../inventory.gcp.yml' --graph"
    ansiblePlaybook playbook: '../geocitizen-playbook.yml', inventory: '../inventory.gcp.yml', credentialsId: 'ansible', extras: '--ssh-extra-args="-o StrictHostKeyChecking=no"'
}
```

Change **env.GCP_PROJECT** variable with your project id in GCP.

Also change **credentialsId** to your GCP Service account file credentials id.
    