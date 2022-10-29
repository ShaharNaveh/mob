### Setup

```sh
cd terraform/terraform-lock/
terraform apply -auto-approve
```

Then taking the value of the S3 bucket name and put it in `terraform/terraform-lock/production.backend`, then:

```sh
terraform init -backend-config=production.backend -migrate-state
```

### Task-(3|7)

```sh
cd terraform/infrastructure/
terraform init -backend-config=production.backend -reconfigure
terraform apply -auto-approve
```

---

### Task-4

#### Prerequisites:

1. Placing the public IP of the EC2 instance from `Task-3` in `ansible/hosts.yaml` at `.all.children.cicd.hosts`.
2. Downloading `s3://<S3 BUCKET>/artifacts/cicd.pem` and placing it in `~/.ssh/keys/cicd.pem`

---

```sh
cd ansible/
ansible-playbook deploy.yaml
```
