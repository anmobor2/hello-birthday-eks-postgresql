# Hello Birthday EKS PostgreSQL

This project is a simple Python microservice that calculates the days until your birthday or congratulates you if it’s today. It uses Flask and SQLAlchemy (initially in-memory, migrating to Postgres). Deployed on AWS EKS with Terraform, CI/CD via GitHub Actions, and Postgres HA with Zalando Operator (1 writer + readers, synchronous/asynchronous multi-region replication).

## Structure
- **app/**: Python code (app.py).
- **deploy/**: Terraform for EKS, k8s/ for YAML manifests.
- **docker/**: Dockerfile for the app.
- **scripts/**: Automation (e.g., deploy.sh migrated to kubectl).
- **tests/**: Unit/integration tests.
- **.github/workflows/**: CI/CD (deploy.yml with tests, security, build, deploy EKS/Postgres).

Key files: `hello-api.db` (SQLite persistent for dev; ignore in prod).

## Requirements
- AWS account with EKS permissions.
- GitHub Secrets: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, SONAR_TOKEN, SLACK_WEBHOOK_URL.
- Python 3.10, Docker, Terraform 1.5.7, kubectl, Helm.

## Setup Local

1. **Helm install** `postgres-operator postgres-operator-charts/postgres-operator --namespace default`
2. **Install deps**: `pip install -r requirements.txt`.
3. **Run app**: `python app.py` (endpoint: http://localhost:5000/birthday?date=YYYY-MM-DD).
4. **Tests**: `pytest`.

For local K8s (Minikube):
1. `minikube start`.
2. Install Helm: See above.
3. Install Zalando Operator: `helm install postgres-operator postgres-operator-charts/postgres-operator --namespace default` (see docs).
4. `kubectl apply -f deploy/k8s/postgres-cluster.yaml` for local Postgres HA.

For offline tests (LocalStack):
1. Run LocalStack: `docker run -d -p 4566:4566 localstack/localstack`.
2. In Terraform: Add provider endpoints to localhost:4566, set `local_test=true`.
3. `terraform plan -var="local_test=true"` (validates S3/ECR without EKS).

## Migration to EKS and Postgres HA
- **From ECS to EKS**: Terraform now creates EKS cluster (eu-west-1 primary, eu-west-3 secondary). Remove ECS resources in main.tf.
- **Postgres HA**: Uses Zalando Operator with Patroni.
  - Primary: 1 writer + 2 readers, synchronous, multi-AZ.
  - Standby: Asynchronous via S3 WAL for DR (without VPC peering).
  - YAML in k8s/: postgres-cluster.yaml (primary), standby-cluster.yaml.
- **DB Migration**: In app.py, change engine to Postgres URL (e.g., postgresql://...@birthday-pg-cluster...).
- **Terragrunt (optional)**: For state management by environment (dev/prod), install Terragrunt and use hcl files to vary buckets.

## Deployment
- Push to a branch (main/develop/staging) triggers workflow.
- Terraform provisions EKS.
- Deploy: kubectl applies manifests, installs operator, creates Postgres cluster.

## Security/HA
- Scans: Bandit, Safety, Trivy, ZAP.
- HA: Automatic failover with Patroni, replication slots to prevent data loss.
- Monitoring: Add Prometheus (future).

Issues? Open an issue. Contribute with PRs!