#!/bin/bash

#############################################
# Author: Cem VAROL
# Date: 01/19/24
# Version: V1
# Desc: AWS Usage Reporter
# This script uses Github API for user and branch info
#############################################



# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
     collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Function to list branches in the repository
function list_branches {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/branches"

      Fetch the list of branches on the repository
    branches="$(github_api_get "$endpoint" | jq '.[] | .name')"

    # Display the list of branches
    if [[ -z "$branches" ]]; then
        echo "No branches found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "branches on ${REPO_OWNER}/${REPO_NAME}:"
        echo "$branches"
    fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access

echo "Listing brancehes on ${REPO_OWNER}/${REPO_NAME}..."
list_branches
