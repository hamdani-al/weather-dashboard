variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region to deploy to"
  type        = string
  default     = "uksouth"
}

variable "project_name" {
  description = "Project name used as a prefix for all resources"
  type        = string
  default     = "weatherdash"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "weather_api_key" {
  description = "OpenWeatherMap API key (passed to the container at runtime)"
  type        = string
  sensitive   = true
}