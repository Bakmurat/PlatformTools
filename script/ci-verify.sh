#!/bin/bash
set -e

REPO_PATH=$(git rev-parse --show-toplevel)

# which kustomize &> /dev/null
echo "Kustomize version - $(kustomize version)"

CLUSTERS=$(find "${REPO_PATH}/clusters" -mindepth 1 -maxdepth 3 -type f -not -path "*patch*" -not -path "*base*" -name "kustomization.yaml" -exec dirname {} \;)
for cluster in ${CLUSTERS[@]}; do
  echo "Building cluster manifest - ${cluster}"
  kustomize build "${cluster}" --load-restrictor LoadRestrictionsNone > /dev/null
done

INFRASTRUCTURES=$(find "${REPO_PATH}/infrastructures" -mindepth 1 -maxdepth 4 -type f -not -path "*patch*" -not -path "*base*" -name "kustomization.yaml" -exec dirname {} \;)
for infrastructures in ${INFRASTRUCTURES[@]}; do
  echo "Building infrastructure manifest in each namespace - ${infrastructures}"
  kustomize build "${infrastructures}" --load-restrictor LoadRestrictionsNone > /dev/null
done
