#!/bin/bash
SERVICE_NAME="flask-default"
IMAGE_VERSION="v_"${BUILD_NUMBER}
TASK_FAMILY="flask-default"

# Create a new task definition for this build
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" task-def-temp.json > task-def-temp.json-v_${BUILD_NUMBER}.json
aws ecs register-task-definition --family flask-default --cli-input-json file://task-def-temp.json-v_${BUILD_NUMBER}.json

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition flask-default | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} | egrep "desiredCount" | tr "/" " " | awk '{print $2}' | sed 's/,$//'`
if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
fi
echo ${DESIRED_COUNT}
aws ecs update-service --cluster ${SERVICE_NAME} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}