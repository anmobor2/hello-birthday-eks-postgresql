¡Por supuesto! Aquí tienes el README.md general del proyecto en inglés, con toda la sintaxis de Markdown visible para que puedas copiarlo y pegarlo directamente en la raíz de tu repositorio.
Markdown

# Hello Birthday EKS PostgreSQL

This repository contains a cloud-native application, "Hello Birthday," deployed on an Amazon EKS cluster, along with all the necessary Infrastructure as Code (IaC) and a complete DevSecOps pipeline for its management and deployment.

The project is designed to demonstrate best practices in Site Reliability Engineering (SRE), automation, and security within an AWS environment.

---

## Solution Architecture

The architecture focuses on robustness, scalability, and observability, utilizing a set of modern technologies and proven design patterns.

* **Compute:** An **Amazon EKS** cluster provides the container orchestration platform.
* **Application:** A Python API written with **FastAPI**, containerized with **Docker**.
* **Database:** A high-availability **PostgreSQL** cluster managed by the **Zalando Operator**, running directly within EKS.
* **Networking & Exposure:** Ingress traffic is managed by an **AWS Application Load Balancer**, automatically provisioned and configured by the **AWS Load Balancer Controller**.
* **Observability:**
    * **Metrics & Traces:** Collected by the **AWS Distro for OpenTelemetry (ADOT) Collector**.
    * **Metrics Storage:** **Amazon Managed Service for Prometheus (AMP)**.
    * **Visualization:** **Amazon Managed Grafana (AMG)**.
    * **Logs:** Aggregated and sent to an **S3 bucket** for long-term archival and analysis.
* **Disaster Recovery:** The solution includes a hybrid DR plan to replicate the database to an on-premise environment. For more details, see the [**Disaster Recovery Plan**](./disaster-recovery/README.md).

---

## Technology Stack

| Domain                  | Primary Technology                                                         |
| ----------------------- | -------------------------------------------------------------------------- |
| **Cloud** | Amazon Web Services (AWS)                                                  |
| **Containers** | Docker, Amazon EKS (Kubernetes)                                            |
| **Infrastructure (IaC)**| Terraform, Terragrunt                                                      |
| **Application** | Python, FastAPI                                                            |
| **Database** | PostgreSQL, Zalando Operator, Patroni                                      |
| **CI/CD & DevSecOps** | GitHub Actions, SonarQube, Trivy                                           |
| **App Deployment** | Helm                                                                       |
| **Observability** | OpenTelemetry, Prometheus, Grafana                                         |

---

## Project Structure

The repository is organized into clear domains for easy navigation and management:

* `/app`: Contains the Python application source code and its `Dockerfile`.
* `/infra`: Hosts all the Infrastructure as Code (IaC), organized by technology components.
* `/kubernetes`: Contains the Helm chart for deploying the application and its dependencies.
* `/.github/workflows`: Defines the CI/CD pipeline with GitHub Actions.
* `/disaster-recovery`: Includes the scripts and documentation for the DR plan.

### Infrastructure as Code (IaC)

The infrastructure is managed using **Terragrunt** as an orchestrator on top of **Terraform**. This allows us to maintain clean and DRY (Don't Repeat Yourself) code. The structure follows a "component-centric" pattern:

* `/infra/<component>/environments/<environment>`

Each component (`vpc`, `eks`, `iam`, etc.) is independent and has its own Terraform state, minimizing the blast radius of changes and enabling granular management.

### DevSecOps Pipeline

The pipeline defined in `.github/workflows/cicd.yml` automates the entire software lifecycle, from code to deployment, integrating security at every step:

1.  **Test & Quality:** Unit tests (`pytest`) and static code quality analysis (`SonarQube`) are executed.
2.  **Build & Scan:** The Docker image is built and scanned for known vulnerabilities using `Trivy`.
3.  **Publish:** The Docker image and the Helm chart are versioned and published to **Amazon ECR** as an OCI artifact.
4.  **Deploy Infra:** The Terraform/Terragrunt configuration is applied to provision or update the base infrastructure.
5.  **Deploy App:** The application is deployed to the EKS cluster using the newly published Helm chart version.

Authentication with AWS is handled securely using **OIDC**, eliminating the need for long-lived access keys.

---

## Getting Started

### Prerequisites

1.  An AWS account.
2.  Terraform and Terragrunt installed locally.
3.  AWS credentials configured in your terminal.
4.  GitHub Secrets configured in the repository (`AWS_IAM_ROLE_ARN`, `SONAR_TOKEN`, etc.).

### Backend Bootstrap

The resources for the Terraform backend (an S3 bucket and a DynamoDB table) must be created once. This can be done with a simple Terraform script or manually.

### Deployment

Once the prerequisites are met, deployment is fully automated. A `push` to the `develop` or `main` branch will trigger the GitHub Actions pipeline, which will handle the entire process.

