#-----------------------------------------------------------------
# Terraform configuration
#-----------------------------------------------------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

#-----------------------------------------------------------------
# Provider
#-----------------------------------------------------------------
provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
}

#-----------------------------------------------------------------
# Variables
#-----------------------------------------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "account" {
  type = string
}

variable "shot-batch-vcpu" {
  type = string
}

variable "shot-batch-image" {
  type = string
}

variable "scheduling-batch-interval" {
  type = string
}