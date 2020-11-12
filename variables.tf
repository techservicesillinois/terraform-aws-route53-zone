variable "comment" {
  description = "Optional comment for the hosted zone"
  default     = ""
}

variable "name" {
  description = "Name of the hosted zone"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "vpc" {
  description = "VPC for naming internal Route 53 zone"
  default     = ""
}

variable "parent_name" {
  description = "Name of the parent hosted zone"
  default     = ""
}

variable "parent_zone_id" {
  description = "Zone ID of the parent hosted zone"
  default     = ""
}

variable "parent_tags" {
  description = "Tags of the parent hosted zone"
  type        = map(string)
  default     = {}
}

variable "parent_ttl" {
  description = "The TTL of the record created in the parent hosted zone"
  default     = 60
}

variable "soa" {
  description = "Map of attributes for a Start of Authority (SOA) record if being explicitly managed"
  type        = map(any)
  default     = {}
}
