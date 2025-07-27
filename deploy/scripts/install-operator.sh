helm repo add postgres-operator-charts https://opensource.zalando.com/postgres-operator/charts/postgres-operator
helm repo update
helm install postgres-operator postgres-operator-charts/postgres-operator --namespace default